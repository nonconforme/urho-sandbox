// #include "Global/Scripts/Globals.as"
#include "Global/Scripts/Utilities/Sample.as"
#include "Global/Scripts/GameClasses.as"
#include "StartGame.as"

#include "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scripts/CtrlsPlayer.as"

Scene@ levelScene;
Node@ cameraNode;
Node@ levelRoot;

Array<Scene@> loadingScenes;

CtrlsPlayer@ player;
Node@ playerNode;

bool levelLoaded = false;

const String entryLevelRes = "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/Gym_BasicRoom_001.xml";

float yaw;
float pitch;

String isLevelLoaded = "Level is Not Loaded";

class MainEntry : ScriptObject {
    void Start() {
        script.defaultScriptFile = scriptFile;
        script.defaultScene = scene;

        scene.vars["MainScriptNodeId"] = Variant("FUCKING BULLSHIT");
        // scene.vars["GEditorMode"] = false;
        // scene.vars["MainScriptNodeId"] = self.node.name;

        // log.Info("Main node something : " + self.node.name);

        // log.Info(script.defaultScene.vars["MainScriptNodeId"].GetString());

        log.Info("Calling MainEntry Script.");
        log.Info("Scene Name is : " + scene.name);
        log.Info("This is loading the pack for Ctrls.");

        levelScene = Scene("LevelScene");

        SubscribeToEvent("KeyDown", "HandleKeyDown");
        
        cameraNode = Node("GlobalCamera");
        cameraNode.position = cameraNode.position + Vector3(0, 1, 0);
        Camera@ camera = cameraNode.CreateComponent("Camera");
        camera.farClip = 300.0f;
        // renderer.viewports[0] = Viewport(levelScene, camera);
        renderer.viewports[0] = Viewport(levelScene, camera);

        // level node
        levelRoot = Node("LevelRoot");
        // levelRoot.physicsWorld.DrawDebugGeometry(true);

        SubscribeToEvents();

        graphics.SetWindowPosition(0, 0);

        // levelScene.LoadAsyncXML(cache.GetFile(entryLevelRes));
        // levelLoaded = true;
    }

    void HandleKeyDown(StringHash eventType, VariantMap& eventData) {
        int key = eventData["Key"].GetInt();

        // PrintSceneNodeNames();

        if (key == KEY_L) {
            if (!levelLoaded) {
                // levelScene.LoadXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/EntryScene_01.xml"));
                // levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/PrefabLoadTest_01.xml"));
                // levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/PrefabLoadTest_02.xml"));
                // levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Levels/Entry.xml"));
                // scene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Levels/Entry.xml"));

                levelScene.LoadAsyncXML(cache.GetFile(entryLevelRes));
                levelLoaded = true;

                isLevelLoaded = "Level is Loaded";
            }
            else {
                if (!levelScene.asyncLoading) {
                    log.Info("Unloading Scene.");

                    // levelScene.RemoveAllChildren();
                    levelScene.RemoveAllChildren();
                    levelLoaded = false;

                    isLevelLoaded = "Level is not Loaded";
                }
            }

        }
        else if (key == KEY_K) {
            SpawnPlayer();
        }
    }

    void PrintSceneNodeNames() {
        Array<Node@> sceneNodes = scene.GetChildren();

        for (uint i = 0; i < sceneNodes.length; i++) {
            log.Info("Scene Node : " + sceneNodes[i].name);
        }
    }

    void SubscribeToEvents()
    {
        // Subscribe HandleUpdate() function for processing update events
        SubscribeToEvent("Update", "HandleUpdate");
        SubscribeToEvent("AsyncLoadFinished", "HandleAsyncLoadFinished");
        SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
    }

    void HandleUpdate(StringHash eventType, VariantMap& eventData)
    {
        if (levelScene.asyncLoading) {
            log.Info("Loading Level Progress : " + levelScene.asyncProgress);
        }

        // Take the frame time step, which is stored as a float
        float timeStep = eventData["TimeStep"].GetFloat();

        // Move the camera, scale movement with time step
        MoveCamera(timeStep);
    }

    void HandleAsyncLoadFinished(StringHash eventType, VariantMap& eventData) {
        // int numPowerups = gameScene.GetChildrenWithScript("SnowCrate", true).length + gameScene.GetChildrenWithScript("Potion", true).length;
        Scene@ loadedScene = cast<Scene>(eventData["Scene"].GetPtr());
        int numPlayerStarts = loadedScene.GetChildrenWithScript("PlayerStart", true).length;
        log.Info("Number of Player Starts in Scene : " + numPlayerStarts);

        // loadedScene.physicsWorld.DrawDebugGeometry(true);
        // loadedScene.CreateComponent("DebugRenderer");

        levelScene.physicsWorld.gravity = Vector3(0, -65.0, 0);
    }

    void HandlePostRenderUpdate()
    {
        if (levelScene.physicsWorld !is null) {
            // levelScene.physicsWorld.DrawDebugGeometry(true);
        }
    }

    void MoveCamera(float timeStep)
    {
        if (playerNode is null) { 
            FreeCamera(timeStep);
        }
        else { 
            // FreeCamera(timeStep);
            PlayerCamera(timeStep); 
        }
    }

    void FreeCamera(float timeStep) {
        // Do not move if the UI has a focused element (the console)
        if (ui.focusElement !is null)
            return;

        // Movement speed as world units per second
        const float MOVE_SPEED = 20.0f;
        // Mouse sensitivity as degrees per pixel
        const float MOUSE_SENSITIVITY = 0.1f;

        // Use this frame's mouse motion to adjust camera node yaw and pitch. Clamp the pitch between -90 and 90 degrees
        IntVector2 mouseMove = input.mouseMove;
        yaw += MOUSE_SENSITIVITY * mouseMove.x;
        pitch += MOUSE_SENSITIVITY * mouseMove.y;
        pitch = Clamp(pitch, -90.0f, 90.0f);

        // Construct new orientation for the camera scene node from yaw and pitch. Roll is fixed to zero
        cameraNode.rotation = Quaternion(pitch, yaw, 0.0f);

        // Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
        // Use the Translate() function (default local space) to move relative to the node's orientation.
        if (input.keyDown['W'])
            cameraNode.Translate(Vector3(0.0f, 0.0f, 1.0f) * MOVE_SPEED * timeStep);
        if (input.keyDown['S'])
            cameraNode.Translate(Vector3(0.0f, 0.0f, -1.0f) * MOVE_SPEED * timeStep);
        if (input.keyDown['A'])
            cameraNode.Translate(Vector3(-1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);
        if (input.keyDown['D'])
            cameraNode.Translate(Vector3(1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);
    }

    void PlayerCamera(float timeStep) {
        const float MOVE_SPEED = 5.0f;

        // cameraNode.position = playerNode.position + Vector3(0, 3, -10);

        Vector3 playerPos = playerNode.position + Vector3(0, 2.5, -20);
        cameraNode.position = cameraNode.position.Lerp(playerPos, MOVE_SPEED * timeStep);
    }

    void SpawnPlayer() {
        // Ninja@ ninja = cast<Ninja>(ninjaNodes[i].scriptObject);
        String playerPrefabRes = "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Prefabs/Player.xml";
        playerNode = SpawnPrefab(Vector3(0, 50, 6), playerPrefabRes);
        // playerNode.scale = Vector3(0.5, 0.5, 0.5);
    }

    /*
    void Stop() {

    }

    void DelayedStart() {

    }


    void Update(float) {

    }

    void PostUpdate(float) {

    }

    void FixedUpdate(float) {

    }

    void FixedPostUpdate(float) {

    }

    void Save(Serializer&) {

    }

    void Load(Deserializer&) {

    }

    void WriteNetworkUpdate(Serializer&) {

    }

    void ReadNetworkUpdate(Deserializer&) {

    }

    void ApplyAttributes() {

    }

    void TransformChanged() {

    }
    */

}

Node@ SpawnPrefab(Vector3 spawnLoc, String prefabRes) {
    Node@ prefabNode;

    if (!prefabRes.empty) {
        File@ resFile = cache.GetFile(prefabRes);
        if (resFile !is null) {
            prefabNode = levelScene.InstantiateXML(resFile, spawnLoc, Quaternion(0, 0, 0));
        }
    }

    return prefabNode;
}
