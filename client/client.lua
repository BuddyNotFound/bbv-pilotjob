Main = {
    w = Wrapper,
    inroute = false,
    injob = false,
    plane = nil,
    jobid = nil,
    ped = PlayerPedId,
}

CreateThread(function()
    for k,v in pairs(Config.Targets) do 
        Wrapper:Target('pilot'..k,Config.Targets[k].label,Config.Targets[k].pos,Config.Targets[k].event)
    end
end)

-- AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
--     for k,v in pairs(Config.Targets) do 
--         Wrapper:Target('pilot'..k,Config.Targets[k].label,Config.Targets[k].pos,Config.Targets[k].event)
--     end
-- end)
--     Wrapper:Blip('pilot_job_plane','Planes',Config.Targets.GetPlane.pos,423,1)

RegisterNetEvent('bbv-pilot:start', function()
    if Main.started then
        Wrapper:Notify(Lang.AlreadyWorking, 'error', 2500)
        return
    end
    Main.started = true 
    Wrapper:Notify(Lang.JobStart, 'success',2500)
    print('pilot_job_vehs','Vehicles',Config.Targets.GetPlane.pos,357,18,0.6)
    Wrapper:Blip('pilot_job_vehs','Vehicles',Config.Targets.GetCar.pos,357,18,0.6)
end)

RegisterNetEvent('bbv-pilot:getplane',function()
    if not Main.started then
        Wrapper:Notify(Lang.SigInFirst, 'error', 2500)
        return
    end
    Main:SpawnPlane()
end)

RegisterNetEvent('bbv-pilot:getcar',function()
    if not Main.started then
        Wrapper:Notify(Lang.SigInFirst, 'error', 2500)
        return
    end
    Wrapper:SpawnVehicle('pilot_car',Config.Targets.GetCar.model,Config.Targets.GetCar.vehpos,Config.Targets.GetCar.vehpos.w)
    Wrapper:Warp('pilot_car',-1)
    _pl = Wrapper:QBPlate('pilot_car')
    TriggerEvent('qb-vehiclekeys:client:AddKeys',_pl)
end)

function Main:SpawnPlane()
    if not Main.started then
        Wrapper:Notify(Lang.SigInFirst, 'error', 2500)
        return
    end
    Wrapper:Notify(Lang.GetPlane,'succes',2500)
    print(Config.Settings.Plane.planemodel,Config.Settings.Plane.pos,Config.Settings.Plane.pos.w)
    self.plane = Wrapper:SpawnVehicle('plane',Config.Settings.Plane.planemodel,Config.Settings.Plane.pos,Config.Settings.Plane.pos.w)
    Wrapper:Warp('plane',-1)
    self.inroute = true
    self.plate = Wrapper:QBPlate('plane')
    TriggerEvent('qb-vehiclekeys:client:AddKeys',self.plate)
    TriggerEvent('bbv-pilot:checkplane')
    self:FindJob()
end

function Main:FindJob()
    _job = math.random(1,#Config.DeliveryLocations)
    if not Config.DeliveryLocations[_job].busy then
        Config.DeliveryLocations[_job].busy = true
        self.job,self.jobid = Config.DeliveryLocations[_job].pos,_job
        self:JobSetup(Config.DeliveryLocations[_job])
        return
    end
end

RegisterNetEvent('bbv-pilot:checkplane',function()
    while Main.plane ~= nil do 
        Wait(Config.PlaneRefresh)
        if not IsVehicleDriveable(Main.plane, 1) then
            Main.plane = nil
            Wrapper:Notify(Lang.MissionFailed,'error',5000)
            Main:LeaveJob()
        end
    end
    return
end)

RegisterNetEvent('bbv-pilot:delivery:setup',function(_pos)
    deliverypos = _pos
    while deliverypos ~= nil do 
        Wait(0)
        local dist = #(GetEntityCoords(Main.ped()) - deliverypos)
        if dist < 20 then 
            DrawMarker(33, deliverypos.x, deliverypos.y, deliverypos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 3.0, 3.0, 3.0, 233, 0, 150, 0, 0, 2, 0, 0, 0, false )
            if dist < 5 then 
                Wrapper:Prompt('Press ~b~[E]~w~ to deliver the cargo.')
                if IsControlJustReleased(1, 46) then 
                    if GetVehiclePedIsIn(Main.ped()) == Main.plane and IsPedInAnyPlane(Main.ped()) then
                        deliverypos = false 
                        Main:SetupReturn(deliverypos)
                    else
                        Wrapper:Notify(Lang.WrongVehicle,'error',3000)
                    end
                end
            end
        end
    end
end)

function Main:JobSetup(data)
    self.w:Notify(Lang.Goto.. ' ' ..data.name,'success',2500)
    self.w:Blip('job_end','Delivery',data.pos,357,1,1.4)
    TriggerEvent('bbv-pilot:delivery:setup',data.pos)
end

function Main:SetupReturn(r_pos)
    self.w:Notify(Lang.Goto.. ' ' ..Config.DeliveryLocations[0].name,'success',2500)
    self.w:Blip('job_return','Return Plane',Config.DeliveryLocations[0].pos,357,1,1.4)
    self.w:RemoveBlip('job_end')
    while self.job ~= nil do 
        Wait(0)
        dist = #(GetEntityCoords(Main.ped()) - Config.DeliveryLocations[0].pos)
        if dist < 20 then 
            DrawMarker(33, Config.DeliveryLocations[0].x, Config.DeliveryLocations[0].y, Config.DeliveryLocations[0].z, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 3.0, 3.0, 3.0, 233, 0, 150, 0, 0, 2, 0, 0, 0, false )
            if dist < 5 then 
                Wrapper:Prompt('Press ~b~[E]~w~ to return the plane.')
                if IsControlJustReleased(1, 46) then 
                    if GetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(Main.ped()) == self.plate) then
                    self.LeaveJob()
                    self.w:Notify(Lang.EndJob,'success',3000)
                    self.w:AddMoney(Config.Payment,Config.Reward)
                    else
                    Wrapper:Notify(Lang.WrongVehicle,'error',3000)
                    end
                end
            end
        end
    end
end

function Main:LeaveJob()
    Config.DeliveryLocations[Main.jobid].busy = false
    Main.plane = nil 
    Main.inroute = nil 
    Main.job = nil 
    Main.jobid = nil
    Main.plate = nil
    Main.started = false
    Main.w:DeleteVehicle('plane')
    Main.w:RemoveBlip('job_end')
    Main.w:RemoveBlip('job_return')
end