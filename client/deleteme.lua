RegisterCommand("test1",function()
    SetEntityCoords(PlayerPedId(),Config.Targets.GetPlane.pos)
end)

RegisterCommand('test2',function(source)
    local src = source
    print(Config.DeliveryLocations[1].busy[src])
    print(Config.DeliveryLocations[2].busy[src])
end)