local programs = require("conf.programs")
local autostart = require("conf.autostart")

local main_mod = "SUPER" -- Sets "Windows" key as main modifier

-- TODO make globals file
local num_workspaces_per_monitor = 3

for i = 1, num_workspaces_per_monitor do
    hl.bind(main_mod .. " + " .. i, function()
        local monitor = hl.get_active_monitor()
        local id = 0
        if monitor == nil then
            id = 0
        else
            id = monitor.id
        end

        local workspace = id * num_workspaces_per_monitor + i
        hl.dispatch(hl.dsp.focus({ workspace = workspace }))
    end)

    hl.bind(main_mod .. " + SHIFT + " .. i, function()
        local monitor = hl.get_active_monitor()
        local id = 0
        if monitor == nil then
            id = 0
        else
            id = monitor.id
        end

        local workspace = id * num_workspaces_per_monitor + i
        hl.dispatch(hl.dsp.window.move({ workspace = workspace, follow = false }))
    end)
end

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(main_mod .. " + Q", hl.dsp.exec_cmd(programs.terminal))
hl.bind(main_mod .. " + ALT + SHIFT + S", hl.dsp.exec_cmd(programs.screenshot))

local closeWindowBind = hl.bind(main_mod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(
    main_mod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd(programs.file_manager))
hl.bind(main_mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + R", hl.dsp.exec_cmd(programs.menu))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + B", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(main_mod .. " + T", hl.dsp.exec_cmd("~/dotfiles/scripts/theme-switcher.sh"))

-- Move focus with main_mod + arrow keys
hl.bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with main_mod + [0-9]
-- Move active window to a workspace with main_mod + SHIFT + [0-9]
-- for i = 1, 10 do
--     local key = i % 10 -- 10 maps to key 0
--     hl.bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
--     hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
-- end

-- Example special workspace (scratchpad)
hl.bind(main_mod .. " + SPACE", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + SPACE", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with main_mod + scroll
hl.bind(main_mod .. " + SHIFT + J", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + SHIFT + K", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(main_mod .. " + N", hl.dsp.workspace.move)
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())

-- Move/resize windows with main_mod + LMB/RMB and dragging
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd(programs.screenshot))

-- Open all my work stuff
hl.bind(main_mod .. " + SHIFT + H", autostart.launch_socials_music)

-- Toggle screen on offlocal screen_on = true
local screen_on = true

hl.bind(main_mod .. " + O", function()
    if screen_on then
        hl.dispatch(hl.dsp.dpms({ action = "off" }))
        screen_on = false
    else
        hl.dispatch(hl.dsp.dpms({ action = "on" }))
        screen_on = true
    end
end)

local BOTTOM_HEIGHT = 50
local TERMINAL = "ghostty" -- kitty | alacritty | foot | ghostty

hl.config({
    dwindle = {
        preserve_split = true,
        smart_split = false,
    },
})

local function term_cmd(title, dir)
    if TERMINAL == "kitty" then
        return string.format('kitty --title "%s" --directory "%s"', title, dir)
    elseif TERMINAL == "alacritty" then
        return string.format('alacritty --title "%s" --working-directory "%s"', title, dir)
    elseif TERMINAL == "foot" then
        return string.format('foot -T "%s" -D "%s"', title, dir)
    else -- ghostty
        return string.format('ghostty --title="%s" --working-directory="%s"', title, dir)
    end
end

local function spawn_term(title, dir)
    hl.dispatch(hl.dsp.exec_cmd(term_cmd(title, dir)))
end

hl.on("window.open", function(w)
    if w.title == "HL3TERM_C" then
        local cwd = io.popen("readlink /proc/" .. w.pid .. "/cwd"):read("*l")
        hl.dispatch(hl.dsp.layout("preselect u"))
        spawn_term("HL3TERM_A", cwd)
    elseif w.title == "HL3TERM_A" then
        hl.dispatch(hl.dsp.focus("title:^(HL3TERM_A)$"))
        hl.dispatch(hl.dsp.layout("preselect r"))
        local cwd = io.popen("readlink /proc/" .. w.pid .. "/cwd"):read("*l")
        spawn_term("HL3TERM_B", cwd)
    elseif w.title == "HL3TERM_B" then
        hl.timer(function()
            hl.dispatch(hl.dsp.focus("title:^(HL3TERM_C)$"))
            local c = hl.get_active_window()
            if c ~= nil and c.title == "HL3TERM_C" then
                local delta = BOTTOM_HEIGHT - c.size.y
                hl.dispatch(hl.dsp.window.resize(0, delta))
            end
        end, { timeout = 150, type = "oneshot" })
    end
end)

-- Maximize floating window to fit within the reserved area (e.g. Waybar)
hl.bind(main_mod .. " + G", function()
    local w = hl.get_active_window()
    if w == nil then return end

    -- Get the monitor the window is currently on
    local m = w.monitor
    if m == nil then return end


    local waybar_height = 34;
    local padding = 4;

    -- Monitor geometry
    local mx = m.position.x + padding
    local my = m.position.y + waybar_height + padding
    local mw = m.width - padding * 2
    local mh = m.height - waybar_height - padding * 2

    -- Ensure the window is floating first
    if w.floating == true then
        hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        return
    else
        hl.dispatch(hl.dsp.window.float({ action = "set" }))
    end

    -- Resize to fill available area
    hl.dispatch(hl.dsp.window.resize({
        exact = true,
        x = mw,
        y = mh,
    }))

    -- Move to top-left corner of the available area (centered = same thing here)
    hl.dispatch(hl.dsp.window.move({
        exact = true,
        x = mx,
        y = my,
    }))
end)

local function get_cmd_output(cmd)
    local handle = assert(io.popen(cmd, 'r'))
    local output = assert(handle:read('*a'))
    handle:close()
    return output
end

hl.bind("SUPER + ALT + N", function()
    local my_result = get_cmd_output("hyprctl -j monitors | jq '.[] | {name: .name, reserved: .reserved}")
    hl.notification.create({ text = my_result, duration = 1000 })
end)
