
require "Global/LuaScripts/Utilities/Sample"
require "Global/LuaScripts/GameClasses"

gameScenes        = {}
defaultScene      = nil;
defaultScriptFile = nil;

function Start()
   SampleStart()
   CreateStartupScene()

   CallMainScript()
   -- SubscribeToEvents()
end

function CreateStartupScene()
   mainScene = Scene()
   mainScene['name'] = 'MainScene'
   table.insert(gameScenes, mainScene)

   defaultScene     = mainScene;
   gameManager      = mainScene:CreateChild('GameManager')
   gmScriptInstance = gameManager:CreateScriptObject('GameManager')
end

function CallMainScript()
   local arguments = GetArguments()
   local startPackUUID = nil

   for i, argument in ipairs(arguments) do
       if string.sub(argument, 1, 1) == '-'  then
           argument = string.lower(string.sub(argument, 2))
           if argument == "startpackuuid" then
              startPackUUID = arguments[i + 1]
              PrintLine(arguments[i + 1])
           end
       end
   end

   if startPackUUID then
      require (startPackUUID .. '/MainScript')
      mainScriptInstance = gameManager:CreateScriptObject('MainEntry')
   end
end

function SubscribeToEvents()
    SubscribeToEvent("Update", "HandleUpdate")
end

function HandleUpdate(eventType, eventData)
    local timeStep = eventData["TimeStep"]:GetFloat()
end
