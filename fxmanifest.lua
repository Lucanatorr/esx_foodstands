fx_version 'adamant'

game 'gta5'

name 'ESX Food Stands'
description 'ESX-based Food Stands spread across San Andreas'
author 'Lucanatorr'
version '1.0'

dependencies {
	'es_extended',
}

server_scripts {
	'server/version_check.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
}
