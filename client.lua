local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = nil

-- \ Tables (Dont edit it)
local attached_weapons = {}
local slots = {}

-- \  Player Loaded Event
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()    
  PlayerData = QBCore.Functions.GetPlayerData()
end)

-- \ Check if weapon in inventory
function InInventory(hash)
  for slot, item in pairs(slots) do
    if item and item.type == "weapon" and Config.compatable_weapon_hashes[item.name] then
      if hash == GetHashKey(item.name) then
        return true
      end
    end
  end
  return false
end

-- \ Attach the weapon object to the player
function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR)
	local bone = GetPedBoneIndex(PlayerPedId(), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end
  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }
	AttachEntityToEntity(attached_weapons[attachModel].handle, PlayerPedId(), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

-- \ Loop that checks for weapon and attach to player \ detach from player
CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn then
      local me = PlayerPedId()
      local items = PlayerData.items
      if items and PlayerData then 
        slots = { items[1], items[2], items[3], items[4], items[5], items[6], items[7], items[8], items[9], items[10], items[11], items[12], items[13], items[14], items[15], items[16], items[17], items[18], items[19], items[20], items[21], items[22], items[23], items[24], items[25], items[26], items[27], items[28], items[29], items[30], items[31], items[32], items[33], items[34], items[35], items[36], items[37], items[38], items[39], items[40], items[41], items[42], items[43], items[44], items[45], items[46], items[47], items[48], items[49], items[50]}
        for slot, item in pairs(slots) do
          if item and item.type == "weapon" and Config.compatable_weapon_hashes[item.name] then
            local wep_model = Config.compatable_weapon_hashes[item.name].model
            local wep_hash = Config.compatable_weapon_hashes[item.name].hash              
            if (not attached_weapons[wep_model]) and (GetSelectedPedWeapon(me) ~= wep_hash) then
              AttachWeapon(wep_model, wep_hash, Config.Positions[Config.Sling].bone, Config.Positions[Config.Sling].x, Config.Positions[Config.Sling].y, Config.Positions[Config.Sling].z, Config.Positions[Config.Sling].x_rotation, Config.Positions[Config.Sling].y_rotation, Config.Positions[Config.Sling].z_rotation)
            end
          end
        end
        for key, attached_object in pairs(attached_weapons) do
          if (GetSelectedPedWeapon(me) == attached_object.hash) or (not InInventory(attached_object.hash)) then
            DeleteObject(attached_object.handle)
            attached_weapons[key] = nil
          end
        end
      end
    end
    Wait(500)
  end
end)