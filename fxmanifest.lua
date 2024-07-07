fx_version 'cerulean'
game 'gta5'

author 'Vurosek'
description 'BikeRent https://discord.gg/qPHCbr7US7'
version '1.0.0'
lua54 'yes'

client_scripts {
    'config.lua',
    'client.lua' 
}

server_script 'server.lua'


shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}
