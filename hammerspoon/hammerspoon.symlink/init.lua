-- Load Extensions
-- require("luarocks.loader")
local application = require "hs.application"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local keycodes = require "hs.keycodes"
local fnutils = require "hs.fnutils"
local alert = require "hs.alert"
local screen = require "hs.screen"
local grid = require "hs.grid"
local hints = require "hs.hints"
local timer = require "hs.timer"
local appfinder = require "hs.appfinder"
-- local applescript = require "hs.applescript"
local eventtap = require "hs.eventtap"
local popclick = require "hs.noises"
-- local popclick = require "thume.popclick"

-- local tabs = require "tabs"

local definitions = nil
local hyper = nil
local hyper2 = nil

function pokeSublime(win)
  if win:application():name() == "Sublime Text" then
    hs.execute("/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl --command auto_max_pane -b")
  end
end

local gridset = function(frame)
	return function()
		local win = window.focusedWindow()
		if win then
			grid.set(win, frame, win:screen())
      pokeSublime(win)
		else
			alert.show("No focused window.")
		end
	end
end

auxWin = nil
function saveFocus()
  auxWin = window.focusedWindow()
  alert.show("Window '" .. auxWin:title() .. "' saved.")
end
function focusSaved()
  if auxWin then
    auxWin:focus()
  end
end

local hotkeys = {}

function createHotkeys()
  for key, fun in pairs(definitions) do
    local mod = hyper
    if string.len(key) == 2 and string.sub(key,2,2) == "c" then
      mod = {"cmd"}
    elseif string.len(key) == 2 and string.sub(key,2,2) == "l" then
      mod = {"ctrl"}
    end

    local hk = hotkey.new(mod, string.sub(key,1,1), fun)
    table.insert(hotkeys, hk)
    hk:enable()
  end
end

function rebindHotkeys()
  for i, hk in ipairs(hotkeys) do
    hk:disable()
  end

  hotkeys = {}
  createHotkeys()
  alert.show("Rebound Hotkeys")
end

function applyPlace(win, place)
  local scrs = screen.allScreens()
  local scr = scrs[place[1]]
  grid.set(win, place[2], scr)
end

function applyLayout(layout)
  return function()
    for appName, place in pairs(layout) do
      local app = appfinder.appFromName(appName)
      if app then
        for i, win in ipairs(app:allWindows()) do
          applyPlace(win, place)
        end
      end
    end
  end
end

function newScroller(delay, tick)
  return { delay = delay, tick = tick, timer = nil }
end

function startScroll(scroller)
  if scroller.timer == nil then
    scroller.timer = timer.doEvery(scroller.delay, function()
      eventtap.scrollWheel({0,scroller.tick},{}, "pixel")
      end)
  end
end

function stopScroll(scroller)
  if scroller.timer then
    scroller.timer:stop()
    scroller.timer = nil
  end
end

listener = nil
popclickListening = false
local tssScrollDown = newScroller(0.02, -10)
function scrollHandler(evNum)
  -- alert.show(tostring(evNum))
  if evNum == 1 then
    startScroll(tssScrollDown)
  elseif evNum == 2 then
    stopScroll(tssScrollDown)
  elseif evNum == 3 then
    if application.frontmostApplication():name() == "ReadKit" then
      eventtap.keyStroke({}, "j")
    else
      eventtap.scrollWheel({0,250},{}, "pixel")
    end
  end
end

function popclickPlayPause()
  if not popclickListening then
    listener:start()
    alert.show("listening")
  else
    listener:stop()
    alert.show("stopped listening")
  end
  popclickListening = not popclickListening
end

local function wrap(fn)
  return function(...)
    if fn then
      local ok, err = xpcall(fn, debug.traceback, ...)
      if not ok then hs.showerror(err) end
    end
  end
end

function popclickInit()
  popclickListening = false
  -- local fn = wrap(scrollHandler)
  local fn = scrollHandler
  listener = popclick.new(fn)
end

function pedalInit()
  local scrollDown = newScroller(0.01, -10)
  local hk = hotkey.new({}, "f8", function() startScroll(scrollDown) end, function() stopScroll(scrollDown) end)
  hk:enable()
  local hk = hotkey.new({}, "f10", function() startScroll(scrollDown) end, function() stopScroll(scrollDown) end)
  hk:enable()
  local scrollUp = newScroller(0.01, 10)
  local hk = hotkey.new({}, "f7", function() startScroll(scrollUp) end, function() stopScroll(scrollUp) end)
  hk:enable()
  local hk = hotkey.new({}, "f9", function() startScroll(scrollUp) end, function() stopScroll(scrollUp) end)
  hk:enable()
end

function init()
  createHotkeys()
  popclickInit()
  pedalInit()
  -- keycodes.inputSourceChanged(rebindHotkeys)
  -- tabs.enableForApp("Emacs")
  -- tabs.enableForApp("Atom")
  -- tabs.enableForApp("Sublime Text")

  alert.show("Hammerspoon, at your service.")
end

-- Actual config =================================

hyper = {"cmd","ctrl","alt","shift"}
hyper2 = {"alt"}
hs.window.animationDuration = 0;
-- hints.style = "vimperator"
-- Set grid size.
grid.GRIDWIDTH  = 6
grid.GRIDHEIGHT = 8
grid.MARGINX = 0
grid.MARGINY = 0
local gw = grid.GRIDWIDTH
local gh = grid.GRIDHEIGHT

local gomiddle = {x = 1, y = 1, w = 4, h = 6}
local goleft = {x = 0, y = 0, w = gw/2, h = gh}
local goright = {x = gw/2, y = 0, w = gw/2, h = gh}
local gobig = {x = 0, y = 0, w = gw, h = gh}

local fullApps = {
  "Safari","Aurora","Nightly","Xcode","Qt Creator","Google Chrome","Papers 3.4.2", "ReadKit",
  "Google Chrome Canary", "Eclipse", "Coda 2", "iTunes", "Emacs", "Firefox", "Sublime Text"
}
local layout2 = {
  Airmail = {1, gomiddle},
  Spotify = {1, gomiddle},
  Calendar = {1, gomiddle},
  Messenger = {1, gomiddle},
  Messages = {1, gomiddle},
  Dash = {1, gomiddle},
  Spark = {1, gomiddle},
  Tweetbot = {1, goleft},
  ["iTerm2"] = {2, goright},
  MacRanger = {2, goleft},
  ["Path Finder"] = {2, goleft},
  Mail = {2, goright},
}
fnutils.each(fullApps, function(app) layout2[app] = {1, gobig} end)
local layout2fn = applyLayout(layout2)

-- screen.watcher.new(function()
--   if #(screen.allScreens()) > 1 then
--     timer.doAfter(3, function()
--       layout2fn()
--     end)
--   end
-- end):start()

definitions = {
  [";"] = saveFocus,
  a = focusSaved,

  h = gridset(gomiddle),
  t = gridset(goleft),
  n = function() grid.maximizeWindow(); pokeSublime(window.focusedWindow()) end,
  s = gridset(goright),

  g = layout2fn,
  d = grid.pushWindowNextScreen,
  -- r = hs.reload,
  -- q = function() appfinder.appFromName("Hammerspoon"):kill() end,
  l = popclickPlayPause,

  k = function() hints.windowHints(appfinder.appFromName("Sublime Text"):allWindows()) end,
  j = function() hints.windowHints(window.focusedWindow():application():allWindows()) end,
  -- rl = function() hyper, hyper2 = hyper2,hyper; rebindHotkeys() end,
  ec = function() hints.windowHints(nil) end,
  -- focus last tab
  ["9"] = function() window.focusedWindow():focusTab(9000) end
}

-- launch and focus applications
fnutils.each({
  { key = "o", app = "Path Finder" },
  { key = "e", app = "Google Chrome" },
  { key = "u", app = "Sublime Text" },
  { key = "i", app = "iTerm2" },
  { key = "x", app = "Xcode" },
  { key = "m", app = "Spark" },
  { key = "p", app = "Messenger" },
}, function(object)
    definitions[object.key] = function()
      local app = appfinder.appFromName(object.app)
      if app then app:activate() end
    end
end)

-- hyper+1-8 to focus tab indices 1-8
for i=1,8 do
  definitions[tostring(i)] = function()
    window.focusedWindow():focusTab(i)
  end
end

init()
