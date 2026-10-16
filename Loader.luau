-- // @Mommyware Loader | [#2b34t8z]
local Game: DataModel, typeof = game, typeof
if not (Game:IsLoaded()) then Game.Loaded:Wait() end

if typeof(_IsLoadedFM) == "function" and _IsLoadedFM() then return warn("[Mommy]: Script Already loaded!") end

local globalEnv = (getgenv and getgenv() or _G) :: any
local write_file, read_file, is_file, is_folder, make_folder = writefile, readfile, isfile, isfolder, makefolder

local table_insert, table_concat = table.insert, table.concat
local string_gmatch, string_char, string_byte = string.gmatch, string.char, string.byte
local task_spawn, os_clock, loadstring, tostring, warn = task.spawn, os.clock, loadstring, tostring, warn

local In_Development = false

globalEnv.Cache = globalEnv.Cache or function(ID, Build, ...)
    if globalEnv[ID] == nil then
        globalEnv[ID] = (typeof(Build) == "function") and Build(...) or Build
    end
    return globalEnv[ID]
end

globalEnv.Cache("@Settings", {
    Logo = "rbxassetid://129855843582244",
    Project = "MommyW6",

    Files = {
        ["Murder Mystery 2"] = { File = "MM2/File.luau", Universe = 66654135, UUID = 142823291 },
        ["Random Game"] = { File = "Random/File.luau", Universe = 9271746647, UUID = 123974602339071 },
    },
})

local Repo = "https://raw.githubusercontent.com/FlamesW/Mommy/home/Games/"
local Settings = globalEnv["@Settings"]
local Files = Settings.Files

local Debug = (globalEnv.Debug_Mode or false)

local function Log(...)
    warn("[Mommy]:", ...)
end

if In_Development then Game:Shutdown() end
if Debug then Log("Debug:Enabled()") end

local function Create_Folder(Path)
    if is_folder(Path) then return end

    local Segments = {}
    for Part in string_gmatch(Path, "[^/]+") do
        table_insert(Segments, Part)
    end

    for i = 1, #Segments do
        local Sub = table_concat(Segments, "/", 1, i)
        if not is_folder(Sub) then make_folder(Sub) end
    end
end

local function Get(URL)
    return Game:HttpGet(URL .. "?nocache=" .. tostring(os_clock()))
end

local function Try(URL)
    local ok, res = pcall(Get, URL)
    return ok and res or nil
end

globalEnv.Cache("@Load_Module", function()
    return function()
        local Source = "https://github.com/FlamesW/FunctionManager/releases/latest/download/Module.luau"
        local Repo = "https://raw.githubusercontent.com/FlamesW/FunctionManager"

        local File = "@File_Caches/Module.luau"
        Create_Folder("@File_Caches")

        local function Execute(Content)
            local Chunk, Err = loadstring(Content)
            if not Chunk then
                warn("[FunctionManager]: Failed to compile module:\n" .. tostring(Err))
                return nil
            end

            if Debug then
                local ok, res = pcall(Chunk)
                if not ok then
                    warn("[FunctionManager]: Failed to execute module:\n" .. tostring(res))
                    return nil
                end
                return res
            end
            return Chunk()
        end

        if is_file(File) then
            local Content = read_file(File)

            if Content then
                local Current = Content:match('Build%s*=%s*"@([%d%.]+)"')
                local Remote  = Debug and Try(Repo .. "/home/%40Version.cfg") or Get(Repo .. "/home/%40Version.cfg")
                local Latest  = Remote and Remote:match("@([%d%.]+)")

                if Latest and Current and Latest ~= Current then
                    local Fresh = Get(Source)
                    write_file(File, Fresh)
                    return Execute(Fresh)
                end

                return Execute(Content)
            end
        end

        local Content = Get(Source)
        write_file(File, Content)
        return Execute(Content)
    end
end)

-- // @Shift
local Key = 21

local function Simple_Encode(Data)
    local Out = {}
    for i = 1, #Data do
        Out[i] = string_char((string_byte(Data, i) + Key) % 256)
    end
    return table_concat(Out)
end

local function Simple_Decode(Data)
    local Out = {}
    for i = 1, #Data do
        Out[i] = string_char((string_byte(Data, i) - Key) % 256)
    end
    return table_concat(Out)
end

globalEnv.Cache("@Load_Game", function()
    return function(File, Cache_Path, Name)
        local Source

        if is_file(Cache_Path) then
            Source = Simple_Decode(read_file(Cache_Path))

            task_spawn(function()
                local Remote = Debug and Try(File) or Get(File)
                if Remote and Remote ~= Source then
                    write_file(Cache_Path, Simple_Encode(Remote))
                end
            end)
        else
            Source = Get(File)
            write_file(Cache_Path, Simple_Encode(Source))
        end

        local fn, Err = loadstring(Source)
        if not fn then
            Log("Compile error:", Err)
            return nil
        end

        Log("Loaded:", Name)
        globalEnv["@Loaded"] = true

        if Debug then
            local ok, res = pcall(fn)
            if not ok then Log("Runtime error:", res) end
            return res
        end
        return fn()
    end
end)

local Supported, Info
for File, Entry in pairs(Files) do
    if Entry.Universe == Game.GameId then
        Supported, Info = File, Entry
        break
    end
end

if not Supported then return Log("Unsupported Game") end

task_spawn(function() Create_Folder("Mother/Assets/Caches")
    globalEnv["@Load_Game"](Repo .. Info.File, "Mother/Assets/Caches/" .. Supported:gsub("%s+", "") .. ".File", Supported)
end)
