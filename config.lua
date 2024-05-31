Config = {}

-- DataBase 
Config.Database = 'oxmysql' -- Database type, e.g., 'oxmysql', 'mysql-async'
Config.PlayerVehiclesTable = 'player_vehicles' -- Name of the table storing player vehicles

-- Billing Command
Config.InvoiceCommand = 'invoices'
Config.MaxJobs = 8
Config.MyGov = true 
Config.JobMenu = true
Config.JobIcons = {
	['police'] = 'fa-solid fa-shield',
	['ambulance'] = 'fa-solid fa-user-doctor',
	['electrician'] = 'fa-solid fa-bolt',
	['diving'] = 'fa-solid fa-truck-fish',
	['builder'] = 'fa-solid fa-helmet-safety',
	['judge'] = 'fa-solid fa-gavel',
	['realestate'] = 'fa-solid fa-house',
	['cardealer'] = 'fa-solid fa-car',
	['garbage'] = 'fa-solid fa-trash',
	['casino'] = 'fa-solid fa-dice',
	['mechanic'] = 'fa-solid fa-wrench',
	['tow'] = 'fa-solid fa-truck-tow',
	['taxi'] = 'fa-solid fa-taxi',
	['vineyard'] = 'fa-solid fa-wine-bottle',
	['hotdog'] = 'fa-solid fa-hotdog',
}