hl.monitor({
    output   = "DP-3",
    mode     = "3840x2160@240",
    scale    = 1,
})

local vars = require("variables")
hl.bind("SUPER + Return", hl.dsp.exec_cmd(vars.terminal))

hl.on("hyprland.start", function()
    hl.exec_cmd("caelestia wallpaper -f ~/.local/share/wallpapers/nix-binary-black.png")
end)
