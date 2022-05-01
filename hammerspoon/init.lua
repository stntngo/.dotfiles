-- TODO: Convert this from lua to fennel because why not?

hs.ipc.cliInstall()

-- option + shift + n creates a new space
hs.hotkey.bind({"alt", "shift"}, "N", function()
  local ok, msg = hs.spaces.addSpaceToScreen()
  if not ok then
    hs.alert.show("Failed to create new space: " .. msg)
  end
end)
