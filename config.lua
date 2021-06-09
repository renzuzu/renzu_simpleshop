Config              = {}
Config.DrawDistance = 100
Config.Size         = {x = 1.0, y = 1.0, z = 1.0}
Config.Color        = {r = 0, g = 128, b = 255}
Config.Type         = 21
Config.Locale = 'en'

Config.Zones = {
	['Engineshop'] = {
		Items = {},
		Job = 'mechanic', -- set to false if for everyone
		Societymoney = 'society_mechanic', -- set to false if no society
		Weapons = false,
		Defaultammo = 99,
		Blackmoney = false,
		Pos = {
			{x = 803.00921630859, y = -810.10388183594, z = 26.193387985229}
		}
	},
	-- ['ammunationshop'] = {
	-- 	Items = {},
	-- 	Job = false, -- set to false if for everyone
	-- 	Societymoney = 'society_police', -- set to false if no society
	-- 	Weapons = true,
	-- 	Defaultammo = 99,
	-- 	Blackmoney = false,
	-- 	Pos = {
	-- 		{x = 19.487602233887, y = -1106.2524414062, z = 29.797027587891}
	-- 	}
	-- },
}