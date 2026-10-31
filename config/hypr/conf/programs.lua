-- Set programs that you use
return {
	terminal = "ghostty",
	file_manager = "nemo",
	menu = "hyprlauncher",
	wallpaper = "hyprpaper",
	notifications = "mako",
	screenshot = "hyprshot -m region -o ~/Pictures/Screenshots",
	browser = "brave-browser",
	quickshell = "quickshell -p ~/.config/quickshell/root.qml",
	applets = {
		tailscale = "tailscale systray",
		nm_applet = "nm-applet --indicator",
	},
}
