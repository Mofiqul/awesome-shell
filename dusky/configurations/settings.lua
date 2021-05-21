local settings = {}

settings.wlan_interface = "wlp7s0"
settings.lan_interface = "enp19s0"
-- Turn this to false if you have no bluetooth available, otherwise your dbus will get polutate with bluetoothctl
settings.is_bluetooth_presence = true
settings.script_dir = "/home/devops/.config/awesome/scripts/"
settings.openweathermap_api_key = "bf45bf455cd1656ac6fc31b8aef272f1"
settings.openweathermap_coordinates = {
	"26.1862", -- lat
	"91.751" -- lng
}
return settings
