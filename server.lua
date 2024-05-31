local QBCore = exports['qb-core']:GetCoreObject()

local function GetJobCount(cid)
    local result = MySQL.query.await('SELECT COUNT(*) as jobCount FROM save_jobs WHERE cid = ?', {cid})
    local jobCount = result[1].jobCount
    return jobCount
end

lib.callback.register('kuban_multijob:server:myJobs', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local storeJobs = {}
    local result = MySQL.query.await('SELECT * FROM save_jobs WHERE cid = ?', {Player.PlayerData.citizenid})
    for k, v in pairs(result) do
        local job = QBCore.Shared.Jobs[v.job]
        if job then
            local grade = job.grades[tostring(v.grade)]
            storeJobs[#storeJobs + 1] = {
                job = v.job,
                salary = grade.payment,
                jobLabel = job.label,
                gradeLabel = grade.name,
                grade = v.grade,
            }
        end
    end
    return storeJobs
end)









local branding = 
[[ 
     _  ___    _ ____          _   _  _____  _____ _____  _____ _____ _______ _____ 
    | |/ / |  | |  _ \   /\   | \ | |/ ____|/ ____|  __ \|_   _|  __ \__   __/ ____|
    | ' /| |  | | |_) | /  \  |  \| | (___ | |    | |__) | | | | |__) | | | | (___  
    |  < | |  | |  _ < / /\ \ | . ` |\___ \| |    |  _  /  | | |  ___/  | |  \___ \ 
    | . \| |__| | |_) / ____ \| |\  |____) | |____| | \ \ _| |_| |      | |  ____) |
    |_|\_\\____/|____/_/    \_\_| \_|_____/ \_____|_|  \_\_____|_|      |_| |_____/ 
                                                                                                                                                                                                                                                                                                                                  
  ]]

versionChecker = true -- Set to false to disable version checker


-- Don't touch
resourcename = "kuban_multijob"
version = "1.0.4"
rawVersionLink = "https://raw.githubusercontent.com/Swqppingg/RPCore/main/version.txt"

-- Check for version updates.
if versionChecker then
print(branding)
PerformHttpRequest(rawVersionLink, function(errorCode, result, headers)
    if (string.find(tostring(result), version) == nil) then
        print("\n\r[".. GetCurrentResourceName() .."] ^1WARNING: Your version of ".. resourcename .." is not up to date. Please make sure to update whenever possible.\n\r")
    else
        print("\n\r[".. GetCurrentResourceName() .."] ^2You are running the latest version of ".. resourcename ..".\n\r")
    end
end, "GET", "", "")
end

RegisterNetEvent('kuban_multijob:server:changeJob', function(job, grade)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.name == job then QBCore.Functions.Notify(src, 'Your current job is already set to this.', 'error') return end

    local jobInfo = QBCore.Shared.Jobs[job]
    if not jobInfo then QBCore.Functions.Notify(src, 'Invalid job.', 'error') return end

    Player.Functions.SetJob(job, grade)
    Player.Functions.SetJobDuty(false)
    TriggerClientEvent('QBCore:Client:SetDuty', src, false)
    QBCore.Functions.Notify(src, 'Your job is now: ' .. jobInfo.label)
end)

RegisterNetEvent('kuban_multijob:server:newJob', function(newJob)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local hasJob = false
    local cid = Player.PlayerData.citizenid
    if newJob.name == 'unemployed' then return end
    local result = MySQL.query.await('SELECT * FROM save_jobs WHERE cid = ? AND job = ?', {cid, newJob.name}) 
    if result[1] then
        MySQL.query.await('UPDATE save_jobs SET grade = ? WHERE job = ? and cid = ?', {newJob.grade.level, newJob.name, cid})
        hasJob = true
        return
    end
    if not hasJob and GetJobCount(cid) < Config.MaxJobs then 
	MySQL.insert.await('INSERT INTO save_jobs (cid, job, grade) VALUE (?, ?, ?)', {cid, newJob.name, newJob.grade.level})
    else
        return QBCore.Functions.Notify(src, 'You have the max amount of jobs.', 'error')
    end
end)

RegisterNetEvent('kuban_multijob:server:deleteJob', function(job)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.query.await('DELETE FROM `save_jobs` WHERE `cid` = ? and `job` = ?', {Player.PlayerData.citizenid, job})
    QBCore.Functions.Notify(src, 'You deleted '..QBCore.Shared.Jobs[job].label..' job from your menu.')
    Player.Functions.SetJob('unemployed', 0)
end)

RegisterNetEvent('qb-bossmenu:server:FireEmployee', function(target) -- Removes job when fired from qb-bossmenu.
    local Employee = QBCore.Functions.GetPlayerByCitizenId(target)
    if Employee then
	local oldJob = Employee.PlayerData.job.name
        MySQL.query.await('DELETE FROM save_jobs WHERE cid = ? AND job = ?', {Employee.PlayerData.citizenid, oldJob})
    end
end)


---------------------------------------------------------------------------
-- Fetch vehicles for a player based on their citizen ID
local function fetchPlayerVehicles(citizenid, callback)
    local vehicles = {}
    if Config.Database == 'oxmysql' then
        exports.oxmysql:execute('SELECT * FROM ' .. Config.PlayerVehiclesTable .. ' WHERE citizenid = ?', {citizenid}, function(result)
            if result then
                for _, vehicle in ipairs(result) do
                    table.insert(vehicles, {
                        plate = vehicle.plate,
                        name = vehicle.vehicle,
                        garage = vehicle.garage
                    })
                end
            end
            callback(vehicles)
        end)
    elseif Config.Database == 'mysql-async' then
        MySQL.Async.fetchAll('SELECT * FROM ' .. Config.PlayerVehiclesTable .. ' WHERE citizenid = @citizenid', {['@citizenid'] = citizenid}, function(result)
            if result then
                for _, vehicle in ipairs(result) do
                    table.insert(vehicles, {
                        plate = vehicle.plate,
                        name = vehicle.vehicle,
                        garage = vehicle.garage
                    })
                end
            end
            callback(vehicles)
        end)
    else
        print("Unsupported database type in config")
        callback(vehicles)
    end
end

-- Create a QBCore callback to get the player's vehicles
QBCore.Functions.CreateCallback('getPlayerVehicles', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    fetchPlayerVehicles(citizenid, cb)
end)
