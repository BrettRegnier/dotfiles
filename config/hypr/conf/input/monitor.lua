local status, _ = pcall(require, "conf.local_monitors")

if not status then
    hl.monitor({
        output = "",
        mode = "highrr",
        position = "auto",
        scale = "1",
    })
end
