-- Diagnostic - jalankan ini dulu jika loader tidak tampil
-- Execute: loadstring(game:HttpGet("https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/diagnostic.lua"))()
-- Atau paste langsung di executor

local lp = game.Players.LocalPlayer
local urls={
    "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua",
    "https://cdn.jsdelivr.net/gh/joustingmatch/Ouroboros@main/loader.lua",
    "http://127.0.0.1:8000/loader.lua"
}

local function testHttp(url)
    print("Testing: "..url)
    local a,b = pcall(function() return game:HttpGet(url) end)
    print("  game:HttpGet -> ok=",a," len=",a and #b or 0," snippet=",a and b:sub(1,80) or b)
    local req = (syn and syn.request) or (http and http.request) or request or http_request
    if req then
        local ok,res=pcall(function() return req({Url=url, Method="GET"}) end)
        local body = ok and (res.Body or res.body) or res
        print("  syn.request -> ok=",ok," len=",body and #tostring(body) or 0)
    else
        print("  no syn.request/http.request found")
    end
end

for _,u in ipairs(urls) do testHttp(u) task.wait(0.5) end

-- GUI test
local ok,err=pcall(function()
    local g=Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
    g.Name="DiagGui"
    local f=Instance.new("Frame", g)
    f.Size=UDim2.new(0,300,0,100)
    f.Position=UDim2.new(0.5,-150,0.5,-50)
    f.BackgroundColor3=Color3.fromRGB(0,200,100)
    local l=Instance.new("TextLabel", f)
    l.Size=UDim2.new(1,0,1,0)
    l.Text="DIAGNOSTIC OK - GUI works\nCek F9 untuk Http test"
    l.TextScaled=true
end)
print("GUI test ok=",ok, err)
