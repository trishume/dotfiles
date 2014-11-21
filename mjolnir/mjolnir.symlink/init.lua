-- Load Extensions
local application = require "mjolnir.application"
local window = require "mjolnir.window"
local hotkey = require "mjolnir.hotkey"
local keycodes = require "mjolnir.keycodes"
local fnutils = require "mjolnir.fnutils"
local alert = require "mjolnir.alert"
local grid = require "mjolnir.bg.grid"
local screen = require "mjolnir.screen"
-- Music controls
local spotify = require "mjolnir.lb.spotify"

-- Set up hotkey combinations
local hyper = {"cmd", "alt", "ctrl","shift"}
-- Set grid size.
grid.GRIDWIDTH  = 6
grid.GRIDHEIGHT = 4
grid.MARGINX = 0
grid.MARGINY = 0

local gridset = function(x, y, w, h)
	return function()
		local win = window.focusedwindow()
		if win then
			grid.set(win, {x=x, y=y, w=w, h=h}, win:screen())
		else
			alert.show("No focused window. Check your OS X Accessibility settings. Uncheck and check Mjolnir there if you have moved it.")
		end
	end
end

auxWin = nil
function saveFocus()
  auxWin = window.focusedwindow()
  alert.show("Window '" .. auxWin:title() .. "' saved.")
end
function focusSaved()
  if auxWin then
    auxWin:focus()
  end
end

local definitions = {
  [";"] = saveFocus,
  a = focusSaved,

  h = gridset(2, 1, 2, 2),
  t = gridset(0, 0, 3, 4),
  n = grid.maximize_window,
  s = gridset(3, 0, 3, 4),

  d = grid.pushwindow_nextscreen,
  r = mjolnir.reload
}

-- launch and focus applications
fnutils.each({
  { key = "o", app = "MacRanger" },
  { key = "e", app = "Google Chrome" },
  { key = "u", app = "Emacs" },
  { key = "i", app = "iTerm" },
  { key = "m", app = "Airmail" }
}, function(object)
    definitions[object.key] = function() application.launchorfocus(object.app) end
end)

-- Bind the hotkey definitions
local hotkeys = {}

function createHotkeys()
  for key, fun in pairs(definitions) do
    local hk = hotkey.new(hyper, key, fun)
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

keycodes.inputsourcechanged(rebindHotkeys)

createHotkeys()
alert.show("Mjolnir, at your service.")
