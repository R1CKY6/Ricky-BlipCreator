fx_version 'bodacious'
lua54 'yes' 
game 'gta5' 

author 'R1CKY®#2220'
description 'Blip Creator'
version '1.0'


client_scripts {
    'client.lua'
}

shared_scripts {
    'config.lua',
}
server_scripts {
   '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.otf',
    'web/img/*.png',
}
