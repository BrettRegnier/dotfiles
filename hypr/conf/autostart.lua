local programs = require("conf.programs")

local config_dir = debug.getinfo(1, "S").source:match("^@(.+/)")

hl.on("hyprland.start", function()
    hl.exec_cmd(programs.notifications)
    hl.exec_cmd(programs.wallpaper)

    -- Scripts
    hl.exec_cmd(config_dir .. "../scripts/launch-waybar.sh")
end)
