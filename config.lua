Config = {}
Config.Debug = true
Config.PlaneRefresh = 5000
Config.Payment = 'cash'
Config.Reward = 350

Config.Settings = {
    Framework = 'QBX', -- QBX/QB/ESX/Custom
    Target = "OX", -- OX/QB/BT
    Inventory = "OX",
    Plane = {
        planemodel = 'miljet',
        pos = vector4(-1265.88, -3389.39, 13.95, 328.82)
    }
}

Config.DeliveryLocations = {
    [0] = {
        name = "Los Santos Airport",
        pos = vector3(-1271.87, -3398.5, 13.94),
        busy = false
    },
    [1] = {
        name = "Sandy Shores",
        pos = vector3(1713.06, 3255.69, 41.08),
        busy = false
    },
    [2] = {
        name = "Military Base",
        pos = vector3(-2133.56, 3258.27, 32.81),
        busy = false
    }
}

Config.Targets = {
    Start = {
        pos = vector4(-900.26, -2979.03, 19.85, 150.96), -- vector 4 position
        label = 'Start Job',
        event = 'bbv-pilot:start'
    },
    GetCar = {
        model = 'ripley',
        pos = vector3(-912.52, -3022.26, 14.75),
        vehpos = vector4(-937.08, -2999.71, 13.95, 56.29),
        label = 'Get Car',
        event = 'bbv-pilot:getcar'
    },
    GetPlane = {
        pos = vector3(-1307.79, -3389.14, 14.7),
        label = 'Get Plane (Start Work)',
        event = 'bbv-pilot:getplane'
    }
}

