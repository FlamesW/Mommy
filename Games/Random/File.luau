-- // Example Game
local Game, loadstring = game, loadstring;
local globalEnv = (getgenv and getgenv() or _G) :: any;
local File = "RandomGame"

local Load_Module = globalEnv["@Load_Module"]
globalEnv["@Settings"].Game = File

local Function_Manager = Load_Module and Load_Module()
    or loadstring(Game:HttpGet("https://raw.githubusercontent.com/FlamesW/FunctionManager/home/Source/Main.luau"))()
local Script = Function_Manager.Launch({})

-- // @IronBrew1 Obfuscator
if not IB_OBFUSCATED then
    IB_NO_VIRTUALIZE = function(Function) return Function end
    IB_ENCSTR = function(String) return String end
    IB_INLINE = function(Function) return Function end
    IB_CRASH = function() end
    IB_LINE = 1
end

-- // Functions here

IB_NO_VIRTUALIZE(function()
    Script:Inject(
        "https://raw.githubusercontent.com/FlamesW/Mommy/home/Assets/Dashboard.luau",
        {
            Script = Script,
        },
        ("Mother/Assets/Dashboard.luau")
    )
end)()

-- // Elements here


IB_NO_VIRTUALIZE(function()
    Create_Interface()
end)()
