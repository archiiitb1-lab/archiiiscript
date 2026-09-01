_G.hubError=nil
local function hubMain()
-- Pasar Setan HUB v2.0 FIXED - Mapper + Fuzzer + Auto + Minimize/Fullscreen
-- PlaceId 108679402300081 | Sindukun v0.2.0
-- Loader: loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"))()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local HS = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

-- cleanup old (both old name & stealth)
for _,n in ipairs({"PasarSetanHub","TestMiniGui","ExecTestGui"}) do if PG:FindFirstChild(n) then pcall(function() PG:FindFirstChild(n):Destroy() end) end end
for _,v in ipairs(PG:GetChildren()) do if v.Name:find("StatsUI_") then pcall(function() v:Destroy() end) end end
if gethui then for _,v in ipairs(gethui():GetChildren()) do if v.Name:find("PasarSetanHub") or v.Name:find("StatsUI_") then pcall(function() v:Destroy() end) end end end

local RemoteRegistry = require(RS:WaitForChild("RemoteRegistry"))
local RemotesFolderWrapper = RemoteRegistry.folder("Remotes")
local RealFolder = RemoteRegistry.wadah("Remotes")
local rawDump = RemoteRegistry.dump()
-- STEALTH: filter admin remotes yang trigger deteksi
local dump={}
for _,info in ipairs(rawDump) do
    local l=info.logis:lower()
    if l:find("admin") or l:find("grant") then
        continue
    end
    table.insert(dump, info)
end
print("[Hub Stealth] Loaded - remotes:", #dump, " (filtered admin) folder:", RealFolder and RealFolder:GetFullName() or "nil")

local function logisOf(inst)
    local ok, v = pcall(function() return RemoteRegistry.logis(inst) end)
    return ok and v or (inst and inst.Name or "nil")
end

-- ===== LOGGER HOOK FIXED =====
local hookActive = false
local oldNamecall
local function enableHook()
    if hookActive then print("[Hook] already active") return end
    if not hookmetamethod or not getnamecallmethod then print("[Hook] hookmetamethod not available") return end
    hookActive = true
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (method == "FireServer" or method == "InvokeServer") and typeof(self)=="Instance" and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
            -- check if it's in our registry (any remote)
            local isOur = false
            pcall(function()
                local p = self.Parent
                if p == RealFolder then isOur=true
                elseif p and p:GetAttribute("RRW") then isOur=true
                elseif logisOf(self) ~= self.Name then isOur=true end
            end)
            if isOur then
                local log = logisOf(self)
                local args = {...}
                local ok, json = pcall(function() return HS:JSONEncode(args) end)
                print(string.format("[REMOTE LOG] %s (%s) %s args:%s", log, self.Name, method, ok and json:sub(1,800) or tostring(args[1]):sub(1,200)))
            end
        end
        return oldNamecall(self, ...)
    end)
    print("[Hook] Enabled - all Registry remotes will be logged")
end

-- ===== GUI STEALTH =====
local gui = Instance.new("ScreenGui")
-- stealth name & protect
local randId = tostring(math.random(10000,99999))
gui.Name = "StatsUI_"..randId
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10
-- hide dari coregui scan
local parentGui = PG
if gethui then pcall(function() parentGui=gethui() end) end
if syn and syn.protect_gui then pcall(function() syn.protect_gui(gui) end) end
if get_hidden_gui then pcall(function() parentGui=get_hidden_gui() end) end
gui.Parent = parentGui
-- cleanup old stealth too
for _,v in ipairs(parentGui:GetChildren()) do if v.Name:find("StatsUI_") and v~=gui then pcall(function() v:Destroy() end) end end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 560, 0, 600)
main.Position = UDim2.new(0.5, -280, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(130,90,200)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Title bar
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
title.Size = UDim2.new(1, -140, 1, 0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "🏮 Hub Stealth • "..#dump.." remotes (admin filtered)"
title.TextColor3 = Color3.fromRGB(240,220,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd

-- Window controls: minimize, fullscreen, close
local btnMin = Instance.new("TextButton", titleBar)
btnMin.Size = UDim2.new(0, 32, 0, 28)
btnMin.Position = UDim2.new(1, -108, 0, 5)
btnMin.Text = "—"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 14
btnMin.TextColor3 = Color3.new(1,1,1)
btnMin.BackgroundColor3 = Color3.fromRGB(80,80,95)
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0,6)

local btnFull = Instance.new("TextButton", titleBar)
btnFull.Size = UDim2.new(0, 32, 0, 28)
btnFull.Position = UDim2.new(1, -72, 0, 5)
btnFull.Text = "□"
btnFull.Font = Enum.Font.GothamBold
btnFull.TextSize = 16
btnFull.TextColor3 = Color3.new(1,1,1)
btnFull.BackgroundColor3 = Color3.fromRGB(80,80,95)
Instance.new("UICorner", btnFull).CornerRadius = UDim.new(0,6)

local btnClose = Instance.new("TextButton", titleBar)
btnClose.Size = UDim2.new(0, 32, 0, 28)
btnClose.Position = UDim2.new(1, -36, 0, 5)
btnClose.Text = "✕"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.TextColor3 = Color3.new(1,1,1)
btnClose.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0,6)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

-- State for minimize/fullscreen
local isMinimized = false
local isFullscreen = false
local origSize = main.Size
local origPos = main.Position
local content, tabBar

local function setMinimized(state)
    isMinimized = state
    if state then
        btnMin.Text = "▢"
        -- hide content and tabBar
        if content then content.Visible = false end
        if tabBar then tabBar.Visible = false end
        TS:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0,560,0,38)}):Play()
    else
        btnMin.Text = "—"
        if content then content.Visible = true end
        if tabBar then tabBar.Visible = true end
        local targetSize = isFullscreen and UDim2.new(0.88,0,0.88,0) or origSize
        local targetPos = isFullscreen and UDim2.new(0.06,0,0.06,0) or origPos
        TS:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = targetSize, Position = targetPos}):Play()
    end
end
local function setFullscreen(state)
    isFullscreen = state
    if isMinimized then setMinimized(false) end
    if state then
        btnFull.Text = "❐"
        btnFull.BackgroundColor3 = Color3.fromRGB(110,90,180)
        TS:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0.88,0,0.88,0), Position = UDim2.new(0.06,0,0.06,0)}):Play()
    else
        btnFull.Text = "□"
        btnFull.BackgroundColor3 = Color3.fromRGB(80,80,95)
        TS:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = origSize, Position = origPos}):Play()
    end
end

btnMin.MouseButton1Click:Connect(function() setMinimized(not isMinimized) end)
btnFull.MouseButton1Click:Connect(function() setFullscreen(not isFullscreen) end)
-- double click title to minimize
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 and input.ClickCount==2 then
        setMinimized(not isMinimized)
    end
end)

-- Tab bar and content
tabBar = Instance.new("Frame", main)
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -16, 0, 34)
tabBar.Position = UDim2.new(0,8,0,46)
tabBar.BackgroundTransparency = 1
local tabList = Instance.new("UIListLayout", tabBar)
tabList.FillDirection = Enum.FillDirection.Horizontal
tabList.Padding = UDim.new(0,6)
tabList.SortOrder = Enum.SortOrder.LayoutOrder

content = Instance.new("Frame", main)
content.Name = "Content"
content.Size = UDim2.new(1, -16, 1, -88)
content.Position = UDim2.new(0,8,0,86)
content.BackgroundColor3 = Color3.fromRGB(35,35,42)
content.BorderSizePixel = 0
Instance.new("UICorner", content).CornerRadius = UDim.new(0,8)
local contentPad = Instance.new("UIPadding", content)
contentPad.PaddingTop = UDim.new(0,2)
contentPad.PaddingBottom = UDim.new(0,2)

local pages = {}
local function createTab(name, order)
    local btn = Instance.new("TextButton", tabBar)
    btn.Name = name
    btn.Size = UDim2.new(0, 98, 1, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(220,220,230)
    btn.BackgroundColor3 = Color3.fromRGB(55,55,65)
    btn.AutoButtonColor = true
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    local page = Instance.new("ScrollingFrame", content)
    page.Name = name.."Page"
    page.Size = UDim2.new(1,0,1,0)
    page.Visible = (order==1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 6
    page.ScrollBarImageColor3 = Color3.fromRGB(130,90,200)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0,8)
    pad.PaddingBottom = UDim.new(0,8)
    pad.PaddingLeft = UDim.new(0,8)
    pad.PaddingRight = UDim.new(0,8)
    local lay = Instance.new("UIListLayout", page)
    lay.Padding = UDim.new(0,6)
    lay.SortOrder = Enum.SortOrder.LayoutOrder
    pages[name] = {btn=btn, page=page}
    btn.MouseButton1Click:Connect(function()
        for k,v in pairs(pages) do
            v.page.Visible = (k==name)
            v.btn.BackgroundColor3 = (k==name) and Color3.fromRGB(110,70,180) or Color3.fromRGB(55,55,65)
        end
    end)
    if order==1 then btn.BackgroundColor3 = Color3.fromRGB(110,70,180) end
    return page
end

local pMapper = createTab("Mapper",1)
local pFuzzer = createTab("Fuzzer",2)
local pAuto = createTab("Auto",3)
local pInfo = createTab("Info",4)

local function addLabel(parent, text, size, color)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -8, 0, size or 20)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(230,230,230)
    l.Font = Enum.Font.Gotham
    l.TextScaled = false
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.RichText = true
    return l
end
local function addButton(parent, text, callback, color)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -8, 0, 32)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = color or Color3.fromRGB(80, 120, 200)
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    local s = Instance.new("UIStroke", b)
    s.Color = Color3.fromRGB(0,0,0)
    s.Transparency = 0.7
    s.Thickness = 1
    b.MouseButton1Click:Connect(callback)
    -- hover
    b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(math.min(255, (color or Color3.fromRGB(80,120,200)).R*255+15), math.min(255,(color or Color3.fromRGB(80,120,200)).G*255+15), math.min(255,(color or Color3.fromRGB(80,120,200)).B*255+15))}):Play() end)
    b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = color or Color3.fromRGB(80,120,200)}):Play() end)
    return b
end

-- MAPPER FIXED
do
    addLabel(pMapper, "Daftar <b>"..#dump.." Remote</b> (logis → obfuscated) • <font color=\"#8cf\">Copy/Test</font>", 22, Color3.fromRGB(180,220,255))
    local searchBox = Instance.new("TextBox", pMapper)
    searchBox.Size = UDim2.new(1,-8,0,30)
    searchBox.PlaceholderText = "🔍 Filter e.g. Panen, Cook, Shop, Babi, Tanam..."
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 13
    searchBox.BackgroundColor3 = Color3.fromRGB(50,50,58)
    searchBox.TextColor3 = Color3.new(1,1,1)
    searchBox.PlaceholderColor3 = Color3.fromRGB(150,150,160)
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)
    local pad = Instance.new("UIPadding", searchBox)
    pad.PaddingLeft = UDim.new(0,8)
    local entries = {}
    for _,info in ipairs(dump) do
        local row = Instance.new("Frame", pMapper)
        row.Size = UDim2.new(1,-8,0,54)
        row.BackgroundColor3 = Color3.fromRGB(45,45,52)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
        local left = Instance.new("TextLabel", row)
        left.Size = UDim2.new(1,-120,1,0)
        left.Position = UDim2.new(0,10,0,0)
        left.BackgroundTransparency = 1
        left.Text = string.format("<b>%s</b> [%s]\n<font color=\"#aaa\">%s</font>", info.logis, info.kelas, info.nama)
        left.RichText = true
        left.TextColor3 = Color3.fromRGB(235,235,235)
        left.Font = Enum.Font.Code
        left.TextSize = 11
        left.TextXAlignment = Enum.TextXAlignment.Left
        left.TextYAlignment = Enum.TextYAlignment.Center
        local copyBtn = Instance.new("TextButton", row)
        copyBtn.Size = UDim2.new(0,50,0,24)
        copyBtn.Position = UDim2.new(1,-112,0,6)
        copyBtn.Text = "Copy"
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 11
        copyBtn.BackgroundColor3 = Color3.fromRGB(70,130,90)
        copyBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,4)
        copyBtn.MouseButton1Click:Connect(function()
            local toCopy = info.nama
            if setclipboard then setclipboard(toCopy) print("[Copy] "..toCopy) elseif toclipboard then toclipboard(toCopy) print("[Copy] "..toCopy) else print(toCopy) end
            copyBtn.Text="Copied!"
            task.wait(0.7) copyBtn.Text="Copy"
        end)
        local testBtn = Instance.new("TextButton", row)
        testBtn.Size = UDim2.new(0,50,0,24)
        testBtn.Position = UDim2.new(1,-58,0,6)
        testBtn.Text = "Test"
        testBtn.Font = Enum.Font.GothamBold
        testBtn.TextSize = 11
        testBtn.BackgroundColor3 = Color3.fromRGB(180,120,40)
        testBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", testBtn).CornerRadius = UDim.new(0,4)
        testBtn.MouseButton1Click:Connect(function()
            local inst = RemoteRegistry.get(info.logis)
            if not inst then print("[Test] not found: "..info.logis) return end
            local ok, res = pcall(function()
                if info.kelas=="RemoteEvent" then inst:FireServer() return "Fired"
                else return HS:JSONEncode(inst:InvokeServer()) end
            end)
            print(string.format("[Test %s] ok=%s res=%s", info.logis, tostring(ok), tostring(res):sub(1,600)))
            testBtn.Text = ok and "OK" or "ERR"
            testBtn.BackgroundColor3 = ok and Color3.fromRGB(60,160,80) or Color3.fromRGB(180,50,50)
            task.wait(0.8) testBtn.Text="Test" testBtn.BackgroundColor3=Color3.fromRGB(180,120,40)
        end)
        local indukLabel = Instance.new("TextLabel", row)
        indukLabel.Size = UDim2.new(0,100,0,14)
        indukLabel.Position = UDim2.new(1,-112,1,-18)
        indukLabel.BackgroundTransparency = 1
        indukLabel.Text = info.induk
        indukLabel.TextColor3 = Color3.fromRGB(140,140,150)
        indukLabel.Font = Enum.Font.Code
        indukLabel.TextSize = 9
        indukLabel.TextXAlignment = Enum.TextXAlignment.Left
        entries[#entries+1] = {row=row, text=(info.logis.." "..info.nama.." "..info.kelas.." "..info.induk):lower()}
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower()
        for _,e in ipairs(entries) do e.row.Visible = (q=="" or e.text:find(q,1,true)~=nil) end
    end)
    addButton(pMapper, "📋 Copy ALL mapping", function()
        local lines={}
        for _,info in ipairs(dump) do lines[#lines+1]= string.format("%s -> %s [%s] (%s)", info.logis, info.nama, info.kelas, info.induk) end
        local txt = table.concat(lines, "\n")
        if setclipboard then setclipboard(txt) elseif toclipboard then toclipboard(txt) end
        print(txt)
    end, Color3.fromRGB(90,90,160))
    addButton(pMapper, "🎧 Toggle Hook Logger (log semua remote)", function()
        if not hookActive then enableHook() else print("[Hook] already active - rejoin to disable") end
    end, Color3.fromRGB(130,80,180))
    addLabel(pMapper, "Hook akan log <b>semua</b> Fire/Invoke dengan JSON args ke F9. Pakai untuk capture Tanam payload asli.", 30, Color3.fromRGB(160,170,190))
end

-- FUZZER FIXED
do
    addLabel(pFuzzer, "Fuzzer: spam semua remote dengan payload aman. Delay 0.12s — VIP only!", 30, Color3.fromRGB(255,220,150))
    local logBox = Instance.new("TextLabel", pFuzzer)
    logBox.Size = UDim2.new(1,-8,0,90)
    logBox.BackgroundColor3 = Color3.fromRGB(20,20,24)
    logBox.TextColor3 = Color3.fromRGB(180,255,180)
    logBox.Font = Enum.Font.Code
    logBox.TextSize = 11
    logBox.TextWrapped = true
    logBox.TextXAlignment = Enum.TextXAlignment.Left
    logBox.TextYAlignment = Enum.TextYAlignment.Top
    logBox.Text = "Log fuzzer di F9 + sini ringkas.\nPoll = aman, Shop/Babi butuh args."
    logBox.ClipsDescendants = true
    Instance.new("UICorner", logBox).CornerRadius = UDim.new(0,6)
    local padL = Instance.new("UIPadding", logBox)
    padL.PaddingTop = UDim.new(0,6) padL.PaddingLeft=UDim.new(0,6) padL.PaddingRight=UDim.new(0,6)
    local isFuzzing=false
    local function fuzz(mode)
        if isFuzzing then print("[Fuzzer] already running") return end
        isFuzzing=true
        print("[Fuzzer] Mode:", mode, " start", #dump)
        logBox.Text = "[Fuzzer] Running "..mode.." ..."
        task.spawn(function()
            local c=0
            for _,info in ipairs(dump) do
                local should=false
                if mode=="ALL" then should=true
                elseif mode=="EVENTS" and info.kelas=="RemoteEvent" then should=true
                elseif mode=="FUNCTIONS" and info.kelas=="RemoteFunction" then should=true
                elseif mode=="SAFE_POLL" and info.logis:lower():find("poll") then should=true end
                if not should then continue end
                c+=1
                local inst = RemoteRegistry.get(info.logis)
                if not inst then continue end
                local ok,res
                if info.kelas=="RemoteEvent" then
                    ok,res = pcall(function() inst:FireServer() end)
                    print(string.format("[Fuzz %03d EV] %-22s %s -> ok=%s", c, info.logis, info.nama, tostring(ok)))
                else
                    ok,res = pcall(function() return inst:InvokeServer() end)
                    local resStr = ""
                    pcall(function() resStr = typeof(res)=="table" and HS:JSONEncode(res) or tostring(res) end)
                    print(string.format("[Fuzz %03d RF] %-22s %s -> ok=%s res=%s", c, info.logis, info.nama, tostring(ok), resStr:sub(1,300)))
                    if not ok then
                        local ok2,res2=pcall(function() return inst:InvokeServer({}) end)
                        local s2 = "" pcall(function() s2 = typeof(res2)=="table" and HS:JSONEncode(res2) or tostring(res2) end)
                        print(string.format("  retry {} -> %s %s", tostring(ok2), s2:sub(1,200)))
                    end
                    if info.logis=="CookStove" then
                        for _,menu in ipairs({"Bakar","Rebus","TumisKamboja","SateKepiting","PisangRebus","KopiKemenyan"}) do
                            local ok2,res2=pcall(function() return inst:InvokeServer(menu) end)
                            local s2="" pcall(function() s2 = typeof(res2)=="table" and HS:JSONEncode(res2) or tostring(res2) end)
                            print(string.format("  Cook %s -> %s %s", menu, tostring(ok2), s2:sub(1,200)))
                            task.wait(0.06)
                        end
                    end
                    if info.logis=="ShopBuy" then
                        local ok2,res2=pcall(function() return inst:InvokeServer("Melati") end)
                        print("  ShopBuy Melati -> "..tostring(ok2).." "..tostring(res2):sub(1,200))
                    end
                end
                logBox.Text = string.format("[Fuzzer] %d/%d last:%s -> %s", c, #dump, info.logis, tostring(ok))
                task.wait(0.12)
            end
            logBox.Text = "[Fuzzer] Done "..c.." tested. Cek F9."
            print("[Fuzzer] Done")
            isFuzzing=false
        end)
    end
    addButton(pFuzzer, "🔥 Fuzz ALL (155)", function() fuzz("ALL") end, Color3.fromRGB(180,60,60))
    addButton(pFuzzer, "📡 Fuzz EVENTS only", function() fuzz("EVENTS") end, Color3.fromRGB(60,140,100))
    addButton(pFuzzer, "📞 Fuzz FUNCTIONS only", function() fuzz("FUNCTIONS") end, Color3.fromRGB(80,110,180))
    addButton(pFuzzer, "🛡️ Fuzz SAFE POLL only", function() fuzz("SAFE_POLL") end, Color3.fromRGB(130,100,50))
    addButton(pFuzzer, "⛔ Stop (tunggu selesai cycle)", function() print("[Fuzzer] Stop requested - tunggu cycle selesai, atau re-execute hub untuk kill") end, Color3.fromRGB(100,100,100))
end

-- AUTO FIXED v3: Auto Collect Bahan robust
do
    addLabel(pAuto, "AUTO MODULES — VIP recommended. Toggle ON/OFF.", 22, Color3.fromRGB(180,240,180))
    -- Auto Collect Bahan v3: sort by distance, un-culled, dual fire method, counter
    local autoForage=false
    local forageSpeed=0.12
    local collected=0
    local useTP=false
    local filterAll=true
    local forageBtn = addButton(pAuto, "🌿 Auto Collect Bahan: OFF", function() end, Color3.fromRGB(70,140,70))
    local countLabel = addLabel(pAuto, "Collected: 0 | Speed: 0.12s | TP: OFF", 20, Color3.fromRGB(180,220,180))
    -- speed & TP controls
    local ctrlRow = Instance.new("Frame", pAuto)
    ctrlRow.Size = UDim2.new(1,-8,0,28)
    ctrlRow.BackgroundTransparency=1
    local ctrlList = Instance.new("UIListLayout", ctrlRow)
    ctrlList.FillDirection=Enum.FillDirection.Horizontal
    ctrlList.Padding=UDim.new(0,6)
    local function smallBtn(txt,cb,col)
        local b=Instance.new("TextButton", ctrlRow)
        b.Size=UDim2.new(0,78,1,0)
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
        forageSpeed = math.clamp(forageSpeed-0.02, 0.04, 0.5)
        countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
    end, Color3.fromRGB(80,80,95))
    local btnSpeedUp = smallBtn("Speed +", function()
        forageSpeed = math.clamp(forageSpeed+0.02, 0.04, 0.5)
        countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
    end, Color3.fromRGB(80,80,95))
    local btnTP = smallBtn("TP: OFF", function()
        useTP = not useTP
        btnTP.Text = useTP and "TP: ON" or "TP: OFF"
        btnTP.BackgroundColor3 = useTP and Color3.fromRGB(40,160,60) or Color3.fromRGB(80,80,95)
        countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF")
    end, Color3.fromRGB(80,80,95))
    local btnReset = smallBtn("Reset", function() collected=0 countLabel.Text="Collected: 0 | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF") end, Color3.fromRGB(90,60,60))
    forageBtn.MouseButton1Click:Connect(function()
        autoForage = not autoForage
        forageBtn.Text = autoForage and "🌿 Auto Collect Bahan: ON" or "🌿 Auto Collect Bahan: OFF"
        forageBtn.BackgroundColor3 = autoForage and Color3.fromRGB(40,160,60) or Color3.fromRGB(70,140,70)
        if autoForage then
            task.spawn(function()
                while autoForage do
                    local sp = WS:FindFirstChild("SpawnBahan")
                    if not sp then task.wait(0.8) continue end
                    -- kumpulkan + sort by distance nearest first
                    local list={}
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    for _,part in ipairs(sp:GetChildren()) do
                        if part:GetAttribute("ItemId") then
                            local dist = hrp and (hrp.Position - part.Position).Magnitude or 0
                            table.insert(list, {part=part, dist=dist})
                        end
                    end
                    table.sort(list, function(a,b) return a.dist < b.dist end)
                    local fired=0
                    for _,e in ipairs(list) do
                        if not autoForage then break end
                        local part=e.part
                        -- force un-culled & visible
                        pcall(function() part:SetAttribute("_culled", false) end)
                        local prompt=nil
                        for _,d in ipairs(part:GetDescendants()) do if d:IsA("ProximityPrompt") then prompt=d break end end
                        if not prompt then continue end
                        if not prompt.Enabled then pcall(function() prompt.Enabled=true end) end
                        -- jika TP ON dan jauh >12, teleport dulu (server cek distance)
                        if useTP and e.dist > 12 and hrp then
                            pcall(function() hrp.CFrame = part.CFrame + Vector3.new(0,3,0) end)
                            task.wait(0.18)
                        end
                        local ok=false
                        if fireproximityprompt then
                            ok = pcall(function() fireproximityprompt(prompt) end)
                        end
                        if not ok then
                            -- fallback InputHold (untuk executor yang butuh hold)
                            pcall(function()
                                prompt:InputHoldBegin()
                                task.wait(prompt.HoldDuration + 0.05)
                                prompt:InputHoldEnd()
                            end)
                            ok=true
                        end
                        if ok then
                            fired+=1
                            collected+=1
                            countLabel.Text="Collected: "..collected.." | Speed: "..string.format("%.2f",forageSpeed).."s | TP: "..(useTP and "ON" or "OFF").." | Last: "..tostring(part:GetAttribute("ItemId"))
                        end
                        -- stealth jitter: randomize delay biar tidak terdeteksi pattern
                        task.wait(forageSpeed + math.random(-15,15)/1000 + math.random()*0.02)
                    end
                    if fired==0 then task.wait(0.6 + math.random()*0.3) end
                end
            end)
        end
    end)
    addLabel(pAuto, "v3 Fix: sort nearest, un-culled, dual fire (fireproximityprompt + InputHold), counter, speed ±, TP toggle untuk bypass jarak server.", 36, Color3.fromRGB(170,170,170))

    -- Auto Harvest FIXED: try multiple payloads, log result
    local autoHarvest=false
    local PanenRemote = RemoteRegistry.get("Panen")
    local harvestBtn = addButton(pAuto, "🌾 Auto Panen: OFF", function() end, Color3.fromRGB(160,140,40))
    harvestBtn.MouseButton1Click:Connect(function()
        autoHarvest = not autoHarvest
        harvestBtn.Text = autoHarvest and "🌾 Auto Panen: ON" or "🌾 Auto Panen: OFF"
        harvestBtn.BackgroundColor3 = autoHarvest and Color3.fromRGB(200,180,30) or Color3.fromRGB(160,140,40)
        if autoHarvest then task.spawn(function()
            while autoHarvest do
                local lahan = WS:FindFirstChild("LahanPlot")
                local found=0
                if lahan then
                    for _,plot in ipairs(lahan:GetChildren()) do
                        for _,desc in ipairs(plot:GetDescendants()) do
                            if desc:IsA("BasePart") and desc:GetAttribute("Ready") and not desc:GetAttribute("Harvested") then
                                found+=1
                                -- try Fire with instance, with parent model, with plot name
                                local ok1 = pcall(function() PanenRemote:FireServer(desc) end)
                                print(string.format("[AutoPanen] %s Ready try desc -> %s", desc:GetFullName(), tostring(ok1)))
                                task.wait(0.05)
                                local model = desc.Parent
                                if model and model ~= plot then
                                    local ok2 = pcall(function() PanenRemote:FireServer(model) end)
                                    print("[AutoPanen] try model -> "..tostring(ok2))
                                    task.wait(0.05)
                                end
                                if found>6 then break end
                            end
                        end
                    end
                end
                if found==0 then
                    -- no Ready found, idle
                end
                task.wait(0.7)
            end
        end) end
    end)
    addLabel(pAuto, "Fix: scan LahanPlot Ready+Havested check, coba Fire(desc) & Fire(model), log ok.", 28, Color3.fromRGB(170,170,170))

    -- Auto Siram FIXED: auto equip tool + spam
    local autoSiram=false
    local SiramRemote = RemoteRegistry.get("Siram")
    local siramBtn = addButton(pAuto, "💧 Auto Siram: OFF", function() end, Color3.fromRGB(60,120,160))
    siramBtn.MouseButton1Click:Connect(function()
        autoSiram = not autoSiram
        siramBtn.Text = autoSiram and "💧 Auto Siram: ON" or "💧 Auto Siram: OFF"
        siramBtn.BackgroundColor3 = autoSiram and Color3.fromRGB(30,140,200) or Color3.fromRGB(60,120,160)
        if autoSiram then task.spawn(function()
            while autoSiram do
                -- try equip Penyiram if not equipped
                if LP.Character and not LP.Character:FindFirstChild("PenyiramTanaman") then
                    local tool = LP.Backpack:FindFirstChild("PenyiramTanaman") or LP:FindFirstChild("PenyiramTanaman",true)
                    if tool and tool:IsA("Tool") then
                        pcall(function() tool.Parent = LP.Character end)
                    end
                end
                pcall(function() SiramRemote:FireServer() end)
                task.wait(0.2)
            end
        end) end
    end)
    addLabel(pAuto, "Fix: auto-equip PenyiramTanaman dari Backpack sebelum spam 0.2s.", 28, Color3.fromRGB(170,170,170))

    -- Auto Cook FIXED: handle queue full, show result
    local autoCook=false
    local cookMenu="Bakar"
    local CookStove = RemoteRegistry.get("CookStove")
    local CookQueueState = RemoteRegistry.folder("Remotes"):FindFirstChild("CookQueueState") and RemoteRegistry.get("CookQueueState") or nil
    local cookBtn = addButton(pAuto, "🍳 Auto Cook (Bakar): OFF", function() end, Color3.fromRGB(180,90,40))
    local menuIds = {"Bakar","Rebus","TumisKamboja","SateKepiting","PisangRebus","KopiKemenyan"}
    local menuNames = {"Bakar-SateGagak (1 Daging)","Rebus-Jamur (1 Jamur)","Tumis Kamboja (1 Kamboja)","SateKepiting (3 Kepiting+1 Dupa)","Pisang Rebus (1 Pisang)","Kopi Kemenyan (1 Bubuk+1 Kemenyan)"}
    cookBtn.MouseButton1Click:Connect(function()
        autoCook = not autoCook
        cookBtn.Text = autoCook and ("🍳 Auto Cook ("..cookMenu.."): ON") or ("🍳 Auto Cook ("..cookMenu.."): OFF")
        cookBtn.BackgroundColor3 = autoCook and Color3.fromRGB(220,110,40) or Color3.fromRGB(180,90,40)
        if autoCook then task.spawn(function()
            while autoCook do
                local ok,res = pcall(function() return CookStove:InvokeServer(cookMenu) end)
                local resStr="" pcall(function() resStr = typeof(res)=="table" and HS:JSONEncode(res) or tostring(res) end)
                print(string.format("[AutoCook] %s -> ok=%s res=%s", cookMenu, tostring(ok), resStr:sub(1,300)))
                if not ok or (typeof(res)=="table" and res.ok==false) then
                    -- maybe queue full, wait longer
                    task.wait(2.5)
                else
                    task.wait(1.2)
                end
            end
        end) end
    end)
    addLabel(pAuto, "Pilih resep (id dikirim ke CookStove:InvokeServer(id)):", 18, Color3.fromRGB(200,200,200))
    local menuBtns={}
    for i,id in ipairs(menuIds) do
        local b = Instance.new("TextButton", pAuto)
        b.Size = UDim2.new(1,-8,0,26)
        b.Text = menuNames[i].."  ["..id.."]"
        b.Font = Enum.Font.Gotham
        b.TextSize = 11
        b.TextColor3 = Color3.new(1,1,1)
        b.BackgroundColor3 = (id==cookMenu) and Color3.fromRGB(110,70,30) or Color3.fromRGB(60,60,60)
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
        b.MouseButton1Click:Connect(function()
            cookMenu = id
            cookBtn.Text = (autoCook and "🍳 Auto Cook ("..cookMenu.."): ON" or "🍳 Auto Cook ("..cookMenu.."): OFF")
            for _,other in ipairs(menuBtns) do other.BackgroundColor3 = Color3.fromRGB(60,60,60) end
            b.BackgroundColor3 = Color3.fromRGB(110,70,30)
            print("[AutoCook] selected "..id)
        end)
        table.insert(menuBtns, b)
    end
    -- TP helpers fixed
    addButton(pAuto, "📍 TP ke SpawnBahan random", function()
        local sp=WS:FindFirstChild("SpawnBahan")
        if sp and #sp:GetChildren()>0 then
            local r = sp:GetChildren()[math.random(1,#sp:GetChildren())]
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp and r:IsA("BasePart") then hrp.CFrame = r.CFrame + Vector3.new(0,4,0) print("[TP] Spawn "..r.Name) end
        end
    end, Color3.fromRGB(100,80,150))
    addButton(pAuto, "🏠 TP ke LahanPlot pertama", function()
        local lahan=WS:FindFirstChild("LahanPlot")
        if lahan then
            for _,p in ipairs(lahan:GetChildren()) do
                local target = p:FindFirstChild("Label",true)
                if not target or not target:IsA("BasePart") then
                    for _,d in ipairs(p:GetDescendants()) do if d:IsA("BasePart") then target=d break end end
                end
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if target and hrp then hrp.CFrame = target.CFrame + Vector3.new(0,6,0) print("[TP] Plot "..p.Name) break end
            end
        end
    end, Color3.fromRGB(100,80,150))
    addButton(pAuto, "🧹 Clear auto flags (stop all)", function()
        -- user can re-toggle, but give quick stop
        print("[Auto] Manually toggle OFF each button to stop. This is reminder.")
    end, Color3.fromRGB(90,90,90))
end

-- INFO
do
    addLabel(pInfo, "Pasar Setan v2 Config Snapshot", 22, Color3.fromRGB(180,220,255))
    local txt = [[
<b>Game:</b> Sindukun v0.2.0 | Koin & Lv leaderstats
<b>Forage:</b> 81 spawn 30s | <b>Plant:</b> 4 jenis 300-840s
<b>Cook:</b> 6 resep MaxQueue3 | <b>Ghost:</b> Max20 Buy90%
<b>Babi:</b> Kandang3000 Induk5000 | Kapasitas Rak3 Nampan5
<b>Level:</b> Max120 Exp8 | <b>Trade:</b> Lv10 Market3
<b>Remotes:</b> 155 via RemoteRegistry | <b>AC:</b> none client, server only
]]
    addLabel(pInfo, txt, 110, Color3.fromRGB(220,220,220))
    addButton(pInfo, "📦 Print GameConfig", function()
        local GC=require(RS.GameConfig)
        for k,v in pairs(GC) do print(k, typeof(v)=="table" and "table" or tostring(v)) end
    end, Color3.fromRGB(70,100,140))
    addButton(pInfo, "🌱 Print PlantCatalog", function()
        local PC=require(RS.PlantCatalog)
        for k,v in pairs(PC.Plants) do print(k, "grow",v.growTime, "harvest",v.harvestAmount, "lv",v.minLevel) end
    end, Color3.fromRGB(70,120,100))
    addButton(pInfo, "👻 Print Ghost Types", function()
        local GC=require(RS.GameConfig)
        for k,v in pairs(GC.Ghost.Types) do print(k, "fav:",v.favorite, "weight:",v.weight) end
    end, Color3.fromRGB(120,80,80))
    addLabel(pInfo, "Loader: <font color=\"#8cf\"><b>loadstring(game:HttpGet(\"https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua\"))()</b></font>\nFallback local: <b>http://127.0.0.1:8000/loader.lua</b>", 50, Color3.fromRGB(150,200,255))
end

print("[PasarSetan_Hub v2] GUI ready. Minimize —, Fullscreen □, Close ✕ | Tabs: Mapper Fuzzer Auto Info")
print("[Tips] Hook untuk capture Tanam — enable hook, tanam manual, lihat F9.")
end
local ok, err = xpcall(hubMain, function(e) return e.."\n"..debug.traceback() end)
if not ok then _G.hubError=err warn("[Hub v2 Error] "..err) print(err) end
