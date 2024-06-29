fx_version 'cerulean'
game 'gta5'

author 'Vurosek'
description 'BikeRent https://discord.gg/qPHCbr7US7'
version '1.0.0'
lua54 'yes'

-- Definicja plików źródłowych
client_scripts {
    'config.lua', -- Wczytujemy konfigurację jako pierwszy plik
    'client.lua' -- Upewnij się, że plik klienta jest wczytany
}

server_script 'server.lua'

-- Pliki współdzielone (shared resources)
shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'
}
