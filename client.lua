local QBCore = exports['qb-core']:GetCoreObject()

if Config.JobMenu then
RegisterCommand('myjobs', function(source, args)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local dutyStatus = PlayerData.job.onduty and 'On Duty' or 'Off Duty'
    local dutyIcon = PlayerData.job.onduty and 'fa-solid fa-toggle-on' or 'fa-solid fa-toggle-off'
    local jobMenu = {
        id = 'jobbmenu',
        title = 'My Gov',
        options = {
            {
                title = 'Back',
                icon = 'arrow-left',
                onSelect = function()
                    lib.showContext('playerinteractions')
                end,
            },
            {
                title = 'Toggle Duty',
                description = 'Current Status: ' .. dutyStatus,
                icon = dutyIcon,
                event = 'kuban_multijob:client:toggleDuty',
                args = {},
            },
        },
    }
    lib.callback('kuban_multijob:server:myJobs', false, function(myJobs)
        if myJobs then
            for _, job in ipairs(myJobs) do
                local isDisabled = PlayerData.job.name == job.job
                jobMenu.options[#jobMenu.options + 1] = {
                    title = job.jobLabel,
                    description = 'Rank: ' .. job.gradeLabel .. ' [' .. tonumber(job.grade) .. ']\nPayrate: $' .. job.salary,
                    icon = Config.JobIcons[job.job] or 'fa-solid fa-briefcase',
                    arrow = true,
                    disabled = isDisabled,
                    event = 'kuban_multijob:client:choiceMenu',
                    args = {jobLabel = job.jobLabel, job = job.job, grade = job.grade},
                }
            end
            lib.registerContext(jobMenu)
            lib.showContext('jobbmenu')
        end
    end)
end)
end


AddEventHandler('kuban_multijob:client:choiceMenu', function(args)
    local displayChoices = {
        id = 'choice_menu',
        title = 'Job Actions',
        menu = 'jobbmenu',
        options = {
            {
                title = 'Switch Job',
                description = 'Switch to: '..args.jobLabel,
                icon = 'fa-solid fa-circle-check',
                event = 'kuban_multijob:client:changeJob',
                args = {job = args.job, grade = args.grade}
            },
            {
                title = 'Quit Job',
                description = 'Quit your job!',
                icon = 'fa-solid fa-trash-can',
                event = 'kuban_multijob:client:deleteJob',
                args = {job = args.job}
            },
        }
    }
    lib.registerContext(displayChoices)
    lib.showContext('choice_menu')
end)

AddEventHandler('kuban_multijob:client:changeJob', function(args)
    TriggerServerEvent('kuban_multijob:server:changeJob', args.job, args.grade)
    ExecuteCommand('myjobs')
end)

AddEventHandler('kuban_multijob:client:deleteJob', function(args)
    TriggerServerEvent('kuban_multijob:server:deleteJob', args.job)
    ExecuteCommand('myjobs')
end)

AddEventHandler('kuban_multijob:client:toggleDuty', function()
    TriggerServerEvent('QBCore:ToggleDuty')
    ExecuteCommand('myjobs')
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    TriggerServerEvent('kuban_multijob:server:newJob', JobInfo)
end)

-------------------------------------------------------------------------------------
if Config.MyGov then
    RegisterCommand('mygov', function()
        local id = GetPlayerServerId(PlayerId())
        local playerData = QBCore.Functions.GetPlayerData()
        local jobData = playerData.job or {}
        local gangData = playerData.gang or {}
        local money = playerData.money['bank'] or 0
        local citizenid = playerData.citizenid or "Unknown"
        
        local jobLabel = jobData.label or "Unknown"
        local jobGrade = "Unknown"
        
        if jobData.grade and type(jobData.grade) == "table" and jobData.grade.name then
            jobGrade = jobData.grade.name
        end
        
        local gangLabel = gangData.label or "No Gang"
        local gangGrade = gangData.grade and gangData.grade.name or "No Rank"
        
        -- Ensure character name is set correctly
        local charactername = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname

        lib.registerContext({
            id = 'playerinfo',
            title = charactername,
            options = {
                {
                    title = 'Job Information',
                    description = jobLabel..' - '..jobGrade,
                    icon = 'briefcase'
                },
                {
                    title = 'Gang Information',
                    description = gangLabel..' - '..gangGrade,
                    icon = 'users'
                },
                {
                    title = 'Bank Information',
                    description = 'Bank Money: $'..money,
                    icon = 'dollar-sign'
                },
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('home')
                    end,
                },
            }
        })

        lib.registerContext({
            id = 'home',
            title = 'MyGov',
            options = {
                {
                    title = 'Player Interactions',
                    icon = 'user',
                    onSelect = function()
                        lib.showContext('playerinteractions')
                    end,
                },
                {
                    title = 'City Interactions',
                    icon = 'city',
                    onSelect = function()
                        lib.showContext('cityinteractions')
                    end,
                },
                {
                    title = 'Job Interactions',
                    icon = 'briefcase',
                    -- disabled = true,
                    onSelect = function()
                        lib.showContext('jobinteractions')
                    end,
                },
            }
        })

        -- Handbook
        lib.registerContext({
            id = 'cityinteractions',
            title = 'City Handbook',
            options = {
                {
                    title = 'City Rules',
                    description = 'Revise all city Rules!',
                    icon = 'book',
                    arrow = true,
                    onSelect = function()
                        lib.showContext('cityrules')
                    end,
                },
                {
                    title = 'Getting Started',
                    description = 'Learn the ways of the city!',
                    icon = 'circle-info',
                    arrow = true,
                    onSelect = function()
                        lib.showContext('gettingstarted')
                    end,
                },
                {
                    title = 'Rockstar Editor',
                    icon = 'camera',
                    arrow = true,
                    onSelect = function()
                        ExecuteCommand('editor')
                    end
                },
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('home')
                    end,
                },
            }
        })

        -- Getting Started
        lib.registerContext({
            id = 'gettingstarted',
            title = 'City Handbook',
            options = {
                {
                    title = 'Garbage Job',
                    description = 'Learn how to collect and dispose of waste to maintain cleanliness and hygiene',
                    icon = 'recycle',
                },
                {
                    title = 'Bus Job',
                    description = 'Steering towards excellence as a dedicated bus driver, ensuring safe journeys and exceptional service for passengers every mile of the way.',
                    icon = 'bus',
                },
                --- Add more here
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('cityinteractions')
                    end,
                },
            }
        })

        lib.registerContext({
            id = 'cityrules',
            title = 'Rules',
            options = {
                {
                    title = 'Rule 1',
                    description = 'Respect Everyone',
                    metadata = {
                        {label = 'Within our community, we prioritize respect, inclusivity, and kindness. We are committed to fostering an environment where everyone can enjoy their time free from bullying, discrimination, and harassment. Upholding this commitment is crucial, and it\'s simple — just be kind. While in-character comments are permitted during roleplay, remarks that reference a character\'s "out of character" life or persona are strictly off-limits. Additionally, making derogatory comments towards players who are downed during hostile roleplay is expressly prohibited on our server.', value = ''},
                    },
                },
                {
                    title = 'Rule 2',
                    description = 'Respect the Staff Team',
                    metadata = {
                        {label = 'Our community holds itself to high standards of respect and professionalism. Staff abuse, slander, and disputes are not acceptable. If a staff member provides guidance or imposes a sanction, please refrain from arguing on the spot. If you believe a decision is unjust, we encourage you to submit a detailed staff ticket via our discord. Escalating disagreements with staff only complicates matters. Please value and respect our staff\'s dedication and time. Impersonation of a staff member is strictly prohibited. If you ever have concerns regarding staff conduct, please report it via a ticket.', value = ''},
                    },
                },
                -- Add More
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('cityinteractions')
                    end,
                },
            }
        })

        lib.registerContext({
            id = 'jobinteractions',
            title = 'MyGov Jobs',
            options = {
                {
                    title = 'Police Actions',
                    description = 'Police',
                    icon = 'handcuffs',
                    onSelect = function()
                    end,
                },
                {
                    title = 'Ambulance Actions',
                    description = 'Ambulance',
                    icon = 'suitcase-medical',
                    onSelect = function()
                    end,
                },
                -- Add More
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('home')
                    end,
                },
            }
        })

        lib.registerContext({
            id = 'policeact',
            title = 'Police Actions',
            options = {
                {
                    title = 'Vehicle Lookup',
                    description = 'Choose lookup method',
                    icon = 'magnifying-glass',
                    onSelect = function()
                        lib.showContext('vehlookup')
                    end,
                },
                {
                    title = 'Person Lookup',
                    icon = 'magnifying-glass',
                    description = 'Choose lookup method',
                },
                -- Add More
                {
                    title = 'Back',
                    description = 'Go back to the main menu',
                    icon = 'arrow-left',
                    onSelect = function()
                        lib.showContext('mygov')
                    end,
                },
            }
        })


        -- Fetch vehicle data from server
        QBCore.Functions.TriggerCallback('getPlayerVehicles', function(vehicleData)
            local vehicleOptions = {}
            for _, vehicle in pairs(vehicleData) do
                local vehicleplate = vehicle.plate or "Unknown"
                local vehiclename = vehicle.name or "Unknown"
                local garagelocation = vehicle.garage or "Unknown"
                
                table.insert(vehicleOptions, {
                    title = vehicleplate,
                    description = vehiclename..' | Garage: '..garagelocation,
                    icon = 'car',
                })
            end

            table.insert(vehicleOptions, {
                title = 'Back',
                description = 'Go back to the main menu',
                icon = 'arrow-left',
                onSelect = function()
                    lib.showContext('playerinteractions')
                end,
            })

            lib.registerContext({
                id = 'vehicles',
                title = 'My Vehicles',
                options = vehicleOptions
            })

            lib.registerContext({
                id = 'playerinteractions',
                title = 'MyGov',
                options = {
                    {
                        title = jobLabel .. ' - ' .. jobGrade,
                        description = 'Player ID: '..id..' | Citizen ID: '..citizenid,
                        icon = 'user',
                        iconColor = '#00FF00',
                        onSelect = function()
                            lib.showContext('playerinfo')
                        end,
                    },
                    {
                        title = 'My Jobs',
                        description = 'View & Manage Jobs',
                        icon = 'building',
                        arrow = true,
                        onSelect = function()
                            ExecuteCommand('myjobs')
                        end
                    },
                    {
                        title = 'My Vehicles',
                        description = 'View & Manage Vehicles',
                        icon = 'car',
                        arrow = true,
                        onSelect = function()
                            lib.showContext('vehicles')
                        end
                    },
                    {
                        title = 'Appearance',
                        description = 'Manage Appearance',
                        icon = 'person-dress',
                        onSelect = function()
                            TriggerEvent("illenium-appearance:client:openOutfitMenu", function()
                                OpenMenu(nil, "outfit")
                            end)
                        end,
                        arrow = true,
                    },
                    {
                        title = 'Finance Menu',
                        description = 'Manage Fines & Invoices',
                        icon = 'dollar-sign',
                        onSelect = function()
                            ExecuteCommand(Config.InvoiceCommand)
                        end,
                        arrow = true,
                    },
                    -- {
                    --     title = 'City Handbook',
                    --     description = 'Tips & Tricks',
                    --     icon = 'user',
                    --     arrow = true,
                    --     onSelect = function()
                    --         lib.showContext('handbook')
                    --     end
                    -- },
                    -- {
                    --     -- Only People with the job role police can access this option
                    --     title = 'Police Actions',
                    --     description = 'Police Actions Menu',
                    --     icon = 'shield',
                    --     arrow = true,
                    --     onSelect = function()
                    --         lib.showContext('policeact')
                    --     end
                    -- },
                    {
                        title = 'Back',
                        description = 'Go back to the main menu',
                        icon = 'arrow-left',
                        onSelect = function()
                            lib.showContext('home')
                        end,
                    },
                }
            })
            lib.showContext('home')
        end)
    end)
end

RegisterKeyMapping('home', 'MyGov', 'keyboard', 'F5')
