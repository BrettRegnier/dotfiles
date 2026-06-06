local programs = require("conf.programs")

local config_dir = debug.getinfo(1, "S").source:match("^@(.+/)")

local num_workspaces_per_monitor = 3
local function setup_workspaces()
    local monitors = hl.get_monitors()
    if #monitors == 1 then
        return
    end

    for i = #monitors, 1, -1 do
        local monitor = monitors[i]
        local workspace = monitor.id * num_workspaces_per_monitor + 1


        hl.dispatch(hl.dsp.focus({ monitor = monitor.id }))
        hl.dispatch(hl.dsp.focus({
            workspace = workspace,
        }))

        if i ~= 1 then
            hl.dispatch(hl.dsp.workspace.move({ workspace = monitor.id + 1, monitor = 0 }))
        end
    end
end

local function launch_socials_music()
    hl.dispatch(hl.dsp.exec_cmd("webex", { workspace = "3 silent" }))
    hl.dispatch(hl.dsp.exec_cmd("spotify-launcher", { workspace = "3 silent" }))
    hl.dispatch(hl.dsp.exec_cmd("discord", { workspace = "3 silent" }))
    hl.dispatch(hl.dsp.exec_cmd("signal-desktop --password-store=kwallet6", { workspace = "3 silent" }))
end


hl.on("hyprland.start", function()
    hl.exec_cmd(programs.notifications)
    hl.exec_cmd(programs.wallpaper)

    -- Scripts
    hl.exec_cmd(config_dir .. "../scripts/launch-waybar.sh")

    hl.timer(function()
        setup_workspaces();
        -- hl.timer(function()
        --     launch_socials_music();
        -- end, { timeout = 50, type = "oneshot" })
    end, { timeout = 50, type = "oneshot" })
end)


return { launch_socials_music = launch_socials_music }
