
local ok, err = pcall(function()

    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local RS         = game:GetService("ReplicatedStorage")

    local Folder = RS:FindFirstChild("CP_System")
    if not Folder then
        Folder = Instance.new("Folder")
        Folder.Name = "CP_System"
        Folder.Parent = RS
    end

    local function GetOrCreate(class, name)
        local i = Folder:FindFirstChild(name)
        if i then return i end
        i = Instance.new(class)
        i.Name = name
        i.Parent = Folder
        return i
    end

    local SaveRemote  = GetOrCreate("RemoteEvent",    "CP_SaveCheckpoint")
    local TPRemote    = GetOrCreate("RemoteEvent",    "CP_TeleportToCheckpoint")
    local QueryRemote = GetOrCreate("RemoteFunction", "CP_GetCheckpoints")

    local Data = {}

    local MAX_POINTS    = 60
    local SAVE_COOLDOWN = 0.8
    local TP_COOLDOWN   = 0.5
    local LOCK_TIME     = 2.5
    local MAX_SAVE_DIST = 150

    local function GetData(plr)
        Data[plr.UserId] = Data[plr.UserId] or { list = {}, selected = 0, lastSave = 0 }
        return Data[plr.UserId]
    end

    local function HRP(plr)
        local c = plr.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function IsFiniteCF(cf)
        local okI = pcall(function() return cf:IsFinite() end)
        return okI and cf:IsFinite()
    end

    SaveRemote.OnServerEvent:Connect(function(plr, payload)
        if typeof(payload) == "string" and payload == "clear" then
            local d = GetData(plr)
            d.list = {}; d.selected = 0
            return
        end
        if typeof(payload) ~= "CFrame" then return end
        if not IsFiniteCF(payload) then return end

        local d = GetData(plr)
        local now = os.clock()
        if now - d.lastSave < SAVE_COOLDOWN then return end

        local hrp = HRP(plr)
        if not hrp then return end
        if (hrp.Position - payload.Position).Magnitude > MAX_SAVE_DIST then return end

        if #d.list >= MAX_POINTS then
            table.remove(d.list, 1)
            d.selected = d.selected - 1
        end

        d.lastSave = now
        d.selected = #d.list + 1
        d.list[d.selected] = payload
    end)

    local LastTP = {}

    TPRemote.OnServerEvent:Connect(function(plr, index)
        if type(index) ~= "number" then return end

        local d = GetData(plr)
        local cf = d.list[index]
        if not cf or not IsFiniteCF(cf) then return end

        local now = os.clock()
        if LastTP[plr.UserId] and now - LastTP[plr.UserId] < TP_COOLDOWN then return end
        LastTP[plr.UserId] = now
        d.selected = index

        local hrp = HRP(plr)
        if not hrp then return end

        hrp.CFrame = cf
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        -- قفل الموقع: أي محاولة رجوع من AC => رد فوري
        local ts = os.clock()
        local lock
        lock = RunService.Heartbeat:Connect(function()
            local h = HRP(plr)
            if not h then lock:Disconnect(); return end
            if os.clock() - ts > LOCK_TIME then lock:Disconnect(); return end
            if (h.Position - cf.Position).Magnitude > 0.75 then
                h.CFrame = cf
                h.AssemblyLinearVelocity = Vector3.zero
                h.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end)

    QueryRemote.OnServerInvoke = function(plr)
        local d = GetData(plr)
        return { count = #d.list, selected = d.selected, list = d.list }
    end

    local function SetupPlayer(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(1)
            local d = GetData(plr)
            if d.selected > 0 and d.list[d.selected] then
                local hrp = HRP(plr)
                if hrp then
                    hrp.CFrame = d.list[d.selected]
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    end

    -- اللاعبون الموجودون + الجدد (إصلاح مشكلة اللاعبين الموجودين قبل التشغيل)
    for _, plr in ipairs(Players:GetPlayers()) do
        SetupPlayer(plr)
    end
    Players.PlayerAdded:Connect(SetupPlayer)

    Players.PlayerRemoving:Connect(function(plr)
        Data[plr.UserId] = nil
        LastTP[plr.UserId] = nil
    end)

    print("✅ CP Server Core v2 loaded (server)")
end)

if not ok then
    warn("[CP Server] ❌ خطأ: " .. tostring(err))
end
