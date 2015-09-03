
-- ======================================================
-- GameInfo script object class
GameInfo = ScriptObject()

function GameInfo:Start()
   self.gameName = 'GameName'

   PrintLine('Something')
end


-- ======================================================
-- GameManager script object class
GameManager = ScriptObject()

function GameManager:Start()
   self.gameScenes = {}

   PrintLine('Starting the Game Manager.')
   PrintLine('Scene Name is : ' .. defaultScene.name)
   
   subScene = Scene()
   subScene['name'] = 'SomeSubScene'
   PrintLine("Sub Scene Name is : " .. subScene.name);
end

function GameManager:Stop()
end

function GameManager:SetMainScript(gameInfo)
end

function GameManager:AddScene(scene)
end

function GameManager:RemoveScene(scene)
end

function GameManager:FindScene(scene)
end

function GameManager:Update(timeStep)
end

-- class GameInfo {
--     String someName;
-- }

-- class GameManager : ScriptObject {
--     Array<Scene@> gameScenes;

--     void Start() {
--         log.Info("Starting the Game Manager.");
--         log.Info("Scene Name is : " + scene.name);

--         Scene@ subScene = Scene("SomeSubScene");
--         log.Info("Sub Scene Name is : " + scene.name);
--     }

--     void Stop() {
--         log.Info("Stopping the Game Manager.");
--     }

--     void SetMainScript(GameInfo@ gameInfo) {
--         log.Info("Something from main script : " + gameInfo.someName);
--     }

--     void AddScene(Scene@ scene) {

--     }

--     void RemoveScene(String sceneName) {
--     }

--     void RemoveScene(Scene@ scene) {

--     }

--     Scene@ FindScene(String sceneName) {
--         return null;
--     }

--     // void Update(float timeStep) {
--     //     log.Info("Updating the Game Manager : " + timeStep);
--     // }
-- }


-- ======================================================
Rotator = ScriptObject()

function Rotator:Start()
   self.rotationSpeed = {0.0, 300.0, 0.0}
   PrintLine('Something')
end

function Rotator:Update(timeStep)
   local x = self.rotationSpeed[1] * timeStep
   local y = self.rotationSpeed[2] * timeStep
   local z = self.rotationSpeed[3] * timeStep
   self.node:Rotate(Quaternion(x, y, z))
end
