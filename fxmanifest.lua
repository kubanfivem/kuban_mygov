--[[
  _  ___    _ ____          _   _    _____  ________      ________ _      ____  _____  __  __ ______ _   _ _______ _____ 
 | |/ / |  | |  _ \   /\   | \ | |  |  __ \|  ____\ \    / /  ____| |    / __ \|  __ \|  \/  |  ____| \ | |__   __/ ____|
 | ' /| |  | | |_) | /  \  |  \| |  | |  | | |__   \ \  / /| |__  | |   | |  | | |__) | \  / | |__  |  \| |  | | | (___  
 |  < | |  | |  _ < / /\ \ | . ` |  | |  | |  __|   \ \/ / |  __| | |   | |  | |  ___/| |\/| |  __| | . ` |  | |  \___ \ 
 | . \| |__| | |_) / ____ \| |\  |  | |__| | |____   \  /  | |____| |___| |__| | |    | |  | | |____| |\  |  | |  ____) |
 |_|\_\\____/|____/_/    \_\_| \_|  |_____/|______|   \/   |______|______\____/|_|    |_|  |_|______|_| \_|  |_| |_____/ 
                                                                                                                                                                                                                                                 
discord.gg/kubanscripts | @Kuban
Renaming Any Files. = Script Breaking
]]--
fx_version 'cerulean'
game 'gta5'
shared_scripts { '@ox_lib/init.lua' }
author 'Kuban' 
lua54 'yes'
server_script {
  'server/*.lua',
  '@oxmysql/lib/MySQL.lua'
  }
shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'
