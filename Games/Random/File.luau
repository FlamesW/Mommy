-- // Example Game
local Game: DataModel = game;
-- if not (Game:IsLoaded()) then Game.Loaded:Wait() end

local globalEnv = (getgenv and getgenv() or _G) :: any;
local loadstring, read_file, is_file = loadstring, readfile, isfile;
-- globalEnv["@Loaded"] = true;

if not globalEnv["@Loaded"] then return end

-- // @IronBrew1 Obfuscator
if not IB_OBFUSCATED then
    IB_NO_VIRTUALIZE = function(Function) return Function end
    IB_ENCSTR = function(String) return String end
    IB_INLINE = function(Function) return Function end
    IB_CRASH = function() end
    IB_LINE = 1
end

local File = "Random Game";
local Load_Module = globalEnv["@Load_Module"]

local Function_Manager = (Load_Module and Load_Module())
    or (is_file("@File_Caches/Module.luau") and loadstring(read_file("@File_Caches/Module.luau"))())
    or loadstring(Game:HttpGet("https://raw.githubusercontent.com/FlamesW/FunctionManager/home/Source/Main.luau"))();

local Script = Function_Manager.Launch({}):Build("@Settings/Game", File)

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
