fx_version 'cerulean'

game 'gta5'

description 'SecureNet Impregnable Fortress'
version '0.1'

shared_scripts {
    'config.lua'
}

client_scripts {
	'client.lua',
	'detection.js'
}

server_scripts {
	'server.lua',
	'webhook.lua',
	'server_ins.lua'
}