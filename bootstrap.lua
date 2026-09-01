-- Ouroboros Bootstrap - robust HttpGet for all executors
-- Place this at https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua
-- OR use as one-liner bootstrap if hub is separate:
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/bootstrap.lua"))()

local urls = {
    "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua",
    "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/main.lua",
    "https://cdn.jsdelivr.net/gh/joustingmatch/Ouroboros@main/loader.lua",
    "http://127.0.0.1:8000/loader.lua",
}

local function httpGet(url)
    -- try game:HttpGet (most common)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res and #res > 1000 and not res:find("404: Not Found") and not res:find("<html") then return res end
    -- try syn/request/http_request
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if req then
        ok, res = pcall(function() return req({Url=url, Method="GET"}) end)
        if ok and res then
            local body = res.Body or res.body or res
            if type(body)=="string" and #body>1000 then return body end
        end
    end
    -- try HttpService
    ok, res = pcall(function() return game:GetService("HttpService"):GetAsync(url) end)
    if ok and res and #res>1000 then return res end
    return nil
end

local content=nil
local lastUrl=""
for _,u in ipairs(urls) do
    lastUrl=u
    content = httpGet(u)
    if content then
        print("[Ouroboros] Got "..#content.." bytes from "..u)
        break
    else
        warn("[Ouroboros] Failed "..u)
    end
end

if not content then
    -- show error GUI
    local lp = game.Players.LocalPlayer
    local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    gui.Name="OuroborosError"
    local f=Instance.new("Frame", gui)
    f.Size=UDim2.new(0,400,0,160)
    f.Position=UDim2.new(0.5,-200,0.5,-80)
    f.BackgroundColor3=Color3.fromRGB(30,30,30)
    Instance.new("UICorner", f)
    local l=Instance.new("TextLabel", f)
    l.Size=UDim2.new(1,-20,1,-20)
    l.Position=UDim2.new(0,10,0,10)
    l.BackgroundTransparency=1
    l.TextColor3=Color3.new(1,0.3,0.3)
    l.TextWrapped=true
    l.Font=Enum.Font.GothamBold
    l.TextSize=13
    l.Text="Ouroboros gagal load!\nUrl: "..lastUrl.."\n\n1. Pastikan repo PUBLIC & file di main/loader.lua\n2. Enable Http Request di executor\n3. Coba fallback:\nloadstring(game:HttpGet(\"https://cdn.jsdelivr.net/gh/joustingmatch/Ouroboros@main/loader.lua\"))()\n\nCek F9 console untuk detail."
    error("[Ouroboros] All urls failed")
    return
end

local ok, err = pcall(function() loadstring(content)() end)
if not ok then
    warn("[Ouroboros] loadstring failed: "..tostring(err))
    print(err)
end
