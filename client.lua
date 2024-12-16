local showAni = false
local animations = Config.Animations

RegisterNUICallback("closeAni", function(data, cb)
    showAni = false
    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("selectAnimation", function(data, cb)
    local animationName = data.animation
    local animation = nil

    for _, ani in ipairs(animations) do
        if ani.name == animationName then
            animation = ani
            break
        end
    end

    if animation then
        if animation.type == "walking_style" then
            RequestWalking(animation.style)
        elseif animation.type == "animation" then
            RequestAnimDict(animation.dict)
            while not HasAnimDictLoaded(animation.dict) do
                Wait(0)
            end
            TaskPlayAnim(PlayerPedId(), animation.dict, animation.anim, 8.0, -8.0, -1, animation.flags, 0, false, false, false)
        end
    end

    cb("ok")
end)

function RequestWalking(style)
    RequestAnimSet(style)
    while not HasAnimSetLoaded(style) do
        Wait(0)
    end
    SetPedMovementClipset(PlayerPedId(), style, 0.2)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) 

        if IsControlJustPressed(0, 170) then 
            if not showAni then
                showAni = true
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "openAni",
                    animations = animations 
                })
            end
        end
    end
end)
