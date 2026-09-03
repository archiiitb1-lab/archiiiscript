_G.hubError=nil
local function hubMain()
-- Pasar Setan HUB AUTO ONLY v6 - Anti-Detect + Robust Collect
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/archiiitb1-lab/archiiiscript/main/loader.lua"))()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

for _,n in ipairs({"PasarSetanHub","TestMiniGui","ExecTestGui"}) do if PG:FindFirstChild(n) then pcall(function() PG:FindFirstChild(n):Destroy() end) end end
for _,v in ipairs(PG:GetChildren()) do if v.Name:find("StatsUI_") then pcall(function() v:Destroy() end) end end
if gethui then for _,v in ipairs(gethui():GetChildren()) do if v.Name:find("PasarSetanHub") or v.Name:find("StatsUI_") then pcall(function() v:Destroy() end) end end end

-- GUI STEALTH
local gui = Instance.new("ScreenGui")
gui.Name = "StatsUI_"..tostring(math.random(10000,99999))
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10
local parentGui = PG
if gethui then pcall(function() parentGui=gethui() end) end
if syn and syn.protect_gui then pcall(function() syn.protect_gui(gui) end) end
if get_hidden_gui then pcall(function() parentGui=get_hidden_gui() end) end
gui.Parent = parentGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 380, 0, 360)
main.Position = UDim2.new(0.5, -190, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(130,90,200)
stroke.Thickness = 2

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,38)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,12)
local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1,0,0,12)
titleFix.Position = UDim2.new(0,0,1,-6)
titleFix.BackgroundColor3 = Color3.fromRGB(30,30,38)
titleFix.BorderSizePixel = 0
titleFix.ZIndex = 0
titleFix.Parent = titleBar

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "ðŸ® Auto Bahan Stealth"
title.TextColor3 = Color3.fromRGB(240,220,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local btnMin = Instance.new("TextButton", titleBar)
btnMin.Size = UDim2.new(0, 32, 0, 28)
btnMin.Position = UDim2.new(1, -72, 0, 5)
btnMin.Text = "â€”"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 14
btnMin.TextColor3 = Color3.new(1,1,1)
btnMin.BackgroundColor3 = Color3.fromRGB(80,80,95)
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0,6)
local btnClose = Instance.new("TextButton", titleBar)
btnClose.Size = UDim2.new(0, 32, 0, 28)
btnClose.Position = UDim2.new(1, -36, 0, 5)
btnClose.Text = "âœ•"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0,6)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

local isMinimized=false
local origSize=main.Size
local origPos=main.Position
local content
local function setMinimized(state)
    isMinimized=state
    if state then btnMin.Text="â–¢" if content then content.Visible=false end TS:Create(main, TweenInfo.new(0.2), {Size=UDim2.new(0,380,0,38)}):Play()
    else btnMin.Text="â€”" if content then content.Visible=true end TS:Create(main, TweenInfo.new(0.2), {Size=origSize, Position=origPos}):Play() end
end
btnMin.MouseButton1Click:Connect(function() setMinimized(not isMinimized) end)
titleBar.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 and i.ClickCount==2 then setMinimized(not isMinimized) end end)

content = Instance.new("Frame", main)
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -46)
content.Position = UDim2.new(0,8,0,42)
content.BackgroundColor3 = Color3.fromRGB(35,35,42)
content.BorderSizePixel = 0
Instance.new("UICorner", content).CornerRadius = UDim.new(0,8)
local lay = Instance.new("UIListLayout", content)
lay.Padding = UDim.new(0,6)
lay.SortOrder = Enum.SortOrder.LayoutOrder
local pad = Instance.new("UIPadding", content)
pad.PaddingTop=UDim.new(0,8) pad.PaddingBottom=UDim.new(0,8) pad.PaddingLeft=UDim.new(0,8) pad.PaddingRight=UDim.new(0,8)

local function addLabel(parent, text, size, color)
    local l=Instance.new("TextLabel", parent)
    l.Size=UDim2.new(1,-8,0,size or 20)
    l.BackgroundTransparency=1
    l.Text=text
    l.TextColor3=color or Color3.fromRGB(230,230,230)
    l.Font=Enum.Font.Gotham
    l.TextSize=13
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextWrapped=true
    l.AutomaticSize=Enum.AutomaticSize.Y
    l.RichText=true
    return l
end
local function addButton(parent, text, cb, col)
    local b=Instance.new("TextButton", parent)
    b.Size=UDim2.new(1,-8,0,32)
    b.Text=text
    b.Font=Enum.Font.GothamBold
    b.TextSize=13
    b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(80,120,200)
    b.AutoButtonColor=true
    Instance.new("UICorner", b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    return b
end

-- AUTO COLLECT V6 - ANTI DETECT + ANTI ADMIN
addLabel(content, "<b>Auto Collect Bahan</b> â€” stealth (no admin remote)", 20, Color3.fromRGB(180,240,180))
local autoForage=false
local forageSpeed=0.22
local collected=0
local useTP=true -- default ON biar tidak gagal jarak server (MaxDistance 6)
local stealthJitter=true

local forageBtn = addButton(content, "ðŸŒ¿ Auto Collect: OFF", function() end, Color3.fromRGB(70,140,70))
local countLabel = addLabel(content, "Collected: 0 | Speed: 0.22s | TP: ON (anti gagal jarak)", 18, Color3.fromRGB(180,220,180))

local ctrlRow = Instance.new("Frame", content)
ctrlRow.Size = UDim2.new(1,-8,0,28)
ctrlRow.BackgroundTransparency=1
local ctrlList = Instance.new("UIListLayout", ctrlRow)
ctrlList.FillDirection=Enum.FillDirection.Horizontal
ctrlList.Padding=UDim.new(0,6)
local function smallBtn(txt,cb,col)
    local b=Instance.new("TextButton", ctrlRow)
    b.Size=UDim2.new(0,68,1,0)
    b.Text=txt
    b.Font=Enum.Font.GothamBold
    b.TextSize=11
    b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=col or Color3.fromRGB(60,60,60)
    Instance.new("UICorner", b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(cb)
    return b
end
local btnSpeedDown = smallBtn("Speed -", function()
    forageSpeed = math.clamp(forageSpeed-0.03, 0.08, 0.6)
    countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
end, Color3.fromRGB(80,80,95))
local btnSpeedUp = smallBtn("Speed +", function()
    forageSpeed = math.clamp(forageSpeed+0.03, 0.08, 0.6)
    countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
end, Color3.fromRGB(80,80,95))
local btnTP = smallBtn("TP: ON", function()
    useTP = not useTP
    btnTP.Text = useTP and "TP: ON" or "TP: OFF"
    btnTP.BackgroundColor3 = useTP and Color3.fromRGB(40,160,60) or Color3.fromRGB(80,80,95)
    countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
end, Color3.fromRGB(40,160,60))
local btnReset = smallBtn("Reset", function() collected=0 countLabel.Text="Collected: 0 | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF") end, Color3.fromRGB(90,60,60))
local btnTest = smallBtn("Test 1", function()
    local sp=WS:FindFirstChild("SpawnBahan")
    if not sp then print("[Test] no SpawnBahan") return end
    local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local nearest, ndist=nil, 1e9
    for _,p in ipairs(sp:GetChildren()) do if p:GetAttribute("ItemId") then
        local d=hrp and (hrp.Position-p.Position).Magnitude or 0
        if d<ndist then nearest,ndist=p,d end
    end end
    if not nearest then print("[Test] no bahan with ItemId") return end
    print("[Test] nearest",nearest.Name, nearest:GetAttribute("ItemId"), "dist",math.floor(ndist))
    local prompt
    for _,d in ipairs(nearest:GetDescendants()) do if d:IsA("ProximityPrompt") then prompt=d break end end
    if not prompt then print("[Test] no prompt") return end
    print("[Test] prompt",prompt:GetFullName(),"Enabled",prompt.Enabled,"Hold",prompt.HoldDuration)
    pcall(function() nearest:SetAttribute("_culled", false) end)
    pcall(function() prompt.Enabled=true end)
    if hrp and ndist>6 then
        print("[Test] TP to bahan...")
        TS:Create(hrp, TweenInfo.new(0.4), {CFrame=nearest.CFrame+Vector3.new(0,3,0)}):Play()
        task.wait(0.45)
    end
    local ok=false
    if fireproximityprompt then ok=pcall(function() fireproximityprompt(prompt) end) print("[Test] fireproximityprompt ->",ok) end
    if not ok then pcall(function() prompt:InputHoldBegin() task.wait(prompt.HoldDuration+0.05) prompt:InputHoldEnd() print("[Test] InputHold done") end) end
    task.wait(0.5)
    print("[Test] after ItemId:", tostring(nearest:GetAttribute("ItemId")), "parent:", nearest.Parent and "exists" or "gone")
end, Color3.fromRGB(120,90,40))

-- helper: get bahan list shuffled
local function getBahanList()
    local sp = WS:FindFirstChild("SpawnBahan")
    if not sp then return {} end
    local list={}
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    for _,part in ipairs(sp:GetChildren()) do
        if part:GetAttribute("ItemId") then
            local prompt
            for _,d in ipairs(part:GetDescendants()) do if d:IsA("ProximityPrompt") then prompt=d break end end
            if prompt then
                local dist = hrp and (hrp.Position - part.Position).Magnitude or 0
                table.insert(list, {part=part, prompt=prompt, id=part:GetAttribute("ItemId"), dist=dist})
            end
        end
    end
    return list
end

forageBtn.MouseButton1Click:Connect(function()
    autoForage = not autoForage
    forageBtn.Text = autoForage and "ðŸŒ¿ Auto Collect: ON (stealth)" or "ðŸŒ¿ Auto Collect: OFF"
    forageBtn.BackgroundColor3 = autoForage and Color3.fromRGB(40,160,60) or Color3.fromRGB(70,140,70)
    if autoForage then
        task.spawn(function()
            local consecutive=0
            while autoForage do
                local list = getBahanList()
                if #list==0 then
                    countLabel.Text="Collected: "..collected.." | Mencari bahan..."
                    task.wait(0.8 + math.random()*0.4)
                    continue
                end
                -- stealth: shuffle + sort nearest 5 only, biar tidak pattern
                -- ambil 8 terdekat lalu shuffle
                table.sort(list, function(a,b) return a.dist < b.dist end)
                local pool={}
                for i=1, math.min(8, #list) do table.insert(pool, list[i]) end
                for i=#pool,2,-1 do local j=math.random(i) pool[i],pool[j]=pool[j],pool[i] end

                local fired=0
                for _,e in ipairs(pool) do
                    if not autoForage then break end
                    local part, prompt = e.part, e.prompt
                    if not part.Parent or not part:GetAttribute("ItemId") then continue end
                    -- anti-detect: jangan spam, cek prompt masih enabled
                    if not prompt.Enabled then
                        pcall(function() prompt.Enabled=true end)
                        task.wait(0.05)
                    end
                    pcall(function() part:SetAttribute("_culled", false) end)

                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    -- TP stealth: tween halus jika jauh, jangan instant (MaxDistance 6)
                    if useTP and hrp and e.dist > 6 then
                            local target = part.CFrame + Vector3.new(0,3,0)
                            local info = TweenInfo.new(0.45 + math.random()*0.15, Enum.EasingStyle.Linear)
                            local okTween = pcall(function()
                                local tween = TS:Create(hrp, info, {CFrame=target})
                                tween:Play()
                                tween.Completed:Wait()
                            end)
                            if not okTween then pcall(function() hrp.CFrame = target end) end
                            task.wait(0.15 + math.random()*0.08)
                            e.dist = 0
                    end

                    -- FIX E v7.1: Humanoid MoveTo + 4 metode
                    local Humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and e.dist > 6 then
                        if Humanoid then
                            pcall(function()
                                Humanoid:MoveTo(part.Position)
                                local t0=tick()
                                repeat task.wait(0.1) until not part:GetAttribute("ItemId") or (hrp.Position - part.Position).Magnitude < 5 or tick()-t0>4
                            end)
                            task.wait(0.12)
                        end
                    end
                    local ok=false
                    local VIM = nil pcall(function() VIM=game:GetService("VirtualInputManager") end)
                    -- metode 1: fireproximityprompt (bypass MaxDistance)
                    -- metode 1: fireproximityprompt + cek ItemId hilang
                    if fireproximityprompt and (not ok or part:GetAttribute("ItemId")) then
                        pcall(function() fireproximityprompt(prompt) end) task.wait(0.32)
                        if not part:GetAttribute("ItemId") then ok=true else ok=false end
                        if not ok then pcall(function() fireproximityprompt(prompt,1) end) task.wait(0.32) if not part:GetAttribute("ItemId") then ok=true end end
                    end
                    if (not ok or part:GetAttribute("ItemId")) then
                        local ok2=pcall(function() prompt:InputHoldBegin() task.wait(prompt.HoldDuration+0.08) prompt:InputHoldEnd() end) task.wait(0.32)
                        if ok2 and not part:GetAttribute("ItemId") then ok=true end
                    end
                    if (not ok or part:GetAttribute("ItemId")) and VIM and hrp then
                        local cam = WS.CurrentCamera
                        if cam then pcall(function() cam.CFrame = CFrame.lookAt(hrp.Position, part.Position) end) end
                        local ok3 = pcall(function()
                            VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                            task.wait(prompt.HoldDuration + 0.08)
                            VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        end)
                        if ok3 then ok=true end
                    end

                    if ok then
                        fired+=1
                        collected+=1
                        consecutive+=1
                        countLabel.Text="Collected: "..collected.." | Last: "..tostring(e.id).." ("..math.floor(e.dist).."m)"
                        -- tunggu server hapus ItemId (berarti kepick)
                        local waited=0
                        while part:GetAttribute("ItemId") and waited<1.2 do task.wait(0.08) waited+=0.08 end
                    end

                    -- anti-cheat: jangan terlalu cepat, random 0.18-0.35 + forageSpeed
                    local delay = forageSpeed + (stealthJitter and (math.random(-20,20)/1000 + math.random()*0.06) or 0)
                    task.wait(delay)

                    -- anti-admin: setelah 12x berturut, jeda panjang 1.5s biar tidak log spam
                    if consecutive>=12 then
                        countLabel.Text="Collected: "..collected.." | Jeda stealth 1.5s..."
                        task.wait(1.5 + math.random()*0.8)
                        consecutive=0
                    end

                    -- jika sudah collect, break dan cari list baru (spawn baru)
                    if fired>=3 then break end
                end
                if fired==0 then task.wait(0.7 + math.random()*0.5) end
            end
        end)
    end
end)

addLabel(content, "Stealth: shuffle 8 terdekat, tween TP 0.5s, jitter, jeda 12x. Tanpa remote admin.", 26, Color3.fromRGB(170,170,170))
addButton(content, "ðŸ“ TP Spawn Random (test)", function()
    local sp=WS:FindFirstChild("SpawnBahan")
    if sp and #sp:GetChildren()>0 then
        local r=sp:GetChildren()[math.random(1,#sp:GetChildren())]
        local hrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and r:IsA("BasePart") then
            TS:Create(hrp, TweenInfo.new(0.5, Enum.EasingStyle.Linear), {CFrame=r.CFrame+Vector3.new(0,4,0)}):Play()
        end
    end
end, Color3.fromRGB(100,80,150))
addLabel(content, "Jika tetap tidak kepick: ON kan TP, cek F9 log, pastikan di VIP & ada bahan (81 spawn).", 24, Color3.fromRGB(150,180,150))
print("[Auto Stealth] Hub ready - anti admin, anti detect")
end
local ok,err=xpcall(hubMain, function(e) return e.."\n"..debug.traceback() end)
if not ok then _G.hubError=err warn(err) print(err) end
