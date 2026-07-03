-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,

        border_size = 2,

        col = {
            active_border = "rgba(33ccffa0)",
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1,
        -- inactive_opacity = 0.90,

        blur = {
            enabled = true,
            size = 10,
            passes = 3,
            new_optimizations = true,
            ignore_opacity = true,
            noise = 0,
            brightness = 0.90,
        },

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },


        -- glow = {
        -- 	enabled = true,
        -- 	range = 2,
        -- 	render_power = 1,
        -- 	color = "rgb(255,215,0)",
        -- },
    },

    group = {
        groupbar = {
            enabled = true,
        },
    },

    animations = {
        enabled = true,
    },
})
