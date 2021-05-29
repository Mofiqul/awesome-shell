local settings = {}

settings.wlan_interface = "wlp7s0"
settings.lan_interface = "enp19s0"
-- Turn this to false if you have no bluetooth available, otherwise your dbus will get polutate with bluetoothctl
settings.is_bluetooth_presence = true
settings.script_dir = "/home/devops/.config/awesome/scripts/"
settings.openweathermap_api_key = "<API_KEY>"
settings.openweathermap_coordinates = {
	"<LAT>", -- lat
	"<LNG>" -- lng
}
return settings
