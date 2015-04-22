-- Load Extensions
local application = require "hs.application"
local window = require "hs.window"
local hotkey = require "hs.hotkey"
local keycodes = require "hs.keycodes"
local fnutils = require "hs.fnutils"
local alert = require "hs.alert"
local screen = require "hs.screen"
local grid = require "hs.grid"
local hints = require "hs.hints"
local appfinder = require "hs.appfinder"

local tabs = require "tabs"

local definitions = nil
local hyper = nil
local hyper2 = nil

local gridset = function(frame)
	return function()
		local win = window.focusedWindow()
		if win then
			grid.set(win, frame, win:screen())
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
  local scrs = screen:allScreens()
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

function init()
  createHotkeys()
  keycodes.inputSourceChanged(rebindHotkeys)
  tabs.enableForApp("Emacs")

  alert.show("Hammerspoon, at your service.")
end

-- Actual config =================================

hyper = {"cmd", "alt", "ctrl","shift"}
hyper2 = {"ctrl"}
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
  "Safari","Aurora","Nightly","Xcode","Qt Creator","Google Chrome",
  "Google Chrome Canary", "Eclipse", "Coda 2", "iTunes", "Emacs", "Firefox"
}
local layout2 = {
  Airmail = {1, gomiddle},
  Spotify = {1, gomiddle},
  Calendar = {1, gomiddle},
  Dash = {1, gomiddle},
  iTerm = {2, goright},
  MacRanger = {2, goleft},
}
fnutils.each(fullApps, function(app) layout2[app] = {1, gobig} end)

definitions = {
  [";"] = saveFocus,
  a = focusSaved,

  h = gridset(gomiddle),
  t = gridset(goleft),
  n = grid.maximizeWindow,
  s = gridset(goright),

  g = applyLayout(layout2),

  d = grid.pushWindowNextScreen,
  r = hs.reload,
  q = function() appfinder.appFromName("Hammerspoon"):kill() end,

  k = function() hints.windowHints(appfinder.appFromName("Emacs"):allWindows()) end,
  j = function() hints.windowHints(window.focusedWindow():application():allWindows()) end,
  ll = function() hyper, hyper2 = hyper2,hyper; rebindHotkeys() end,
  ec = function() hints.windowHints(nil) end
}

-- launch and focus applications
fnutils.each({
  { key = "o", app = "MacRanger" },
  { key = "e", app = "Google Chrome" },
  { key = "u", app = "Emacs" },
  { key = "i", app = "iTerm2" },
  { key = "m", app = "Airmail" }
}, function(object)
    definitions[object.key] = function()
      local app = appfinder.appFromName(object.app)
      if app then app:activate() end
    end
end)

for i=1,6 do
  definitions[tostring(i)] = function()
    local app = application.frontmostApplication()
    tabs.focusTab(app,i)
  end
end

init()
