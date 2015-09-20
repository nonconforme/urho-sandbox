#include "Global/Scripts/Application.as"
#include "Global/Scripts/GameClasses.as"
#include "Global/Scripts/PrefabUtils.as"
#include "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scripts/CtrlsPlayer.as"

const String entryLevelRes = "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/Gym_BasicRoom_001.xml";

class MainEntry : ScriptObject {
    Node@ gameManagerNode;
    GameManager@ gameManager;

    Scene@ levelScene;
    Node@ cameraNode;

    Node@ playerNode;
    CtrlsPlayer@ player;

    Application@ app;

    bool levelLoaded = false;
    float yaw;
    float pitch;

    void Start() {
        script.defaultScriptFile = scriptFile;
        script.defaultScene = scene;

        @app = Application();
        app.SetWindowTitleAndIcon();
        app.CreateConsoleAndDebugHud();

        CreateScene();
        SubscribeToEvents();

        graphics.SetWindowPosition(0, 0);
    }

    void CreateScene() {
        // game manager
        gameManagerNode = scene.CreateChild("GameManager");
        ScriptInstance@ gmScriptInstance = gameManagerNode.CreateComponent("ScriptInstance");
        gmScriptInstance.CreateObject(scriptFile, "GameManager");
        @gameManager = cast<GameManager>(gmScriptInstance.scriptObject);

        levelScene = Scene("LevelScene");

        cameraNode = scene.CreateChild("GlobalCamera");
        cameraNode.position = cameraNode.position + Vector3(0, 1, 0);
        Camera@ camera = cameraNode.CreateComponent("Camera");
        camera.farClip = 300.0f;
        renderer.viewports[0] = Viewport(levelScene, camera);
    }

    void HandleKeyDown(StringHash eventType, VariantMap& eventData) {
        int key = eventData["Key"].GetInt();

        if (key == KEY_L) {
            if (!levelLoaded) {
                levelScene.LoadAsyncXML(cache.GetFile(entryLevelRes));
                levelLoaded = true;
            }
            else {
                if (!levelScene.asyncLoading) {
                    levelScene.RemoveAllChildren();
                    levelLoaded = false;
                }
            }

        }
        else if (key == KEY_K) {
            SpawnPlayer();
        }
    }

    void SubscribeToEvents() {
        SubscribeToEvent("Update", "HandleUpdate");
        SubscribeToEvent("KeyDown", "HandleKeyDown");
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
        Scene@ loadedScene = cast<Scene>(eventData["Scene"].GetPtr());
        int numPlayerStarts = loadedScene.GetChildrenWithScript("PlayerStart", true).length;
        log.Info("Number of Player Starts in Scene : " + numPlayerStarts);

        levelScene.physicsWorld.gravity = Vector3(0, -65.0, 0);
    }

    void HandlePostRenderUpdate() {
        if (levelScene.physicsWorld !is null) {
            levelScene.physicsWorld.DrawDebugGeometry(true);
        }
    }

    void MoveCamera(float timeStep) {
        if (playerNode is null) { 
            FreeCamera(timeStep);
        }
        else { 
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

        Vector3 playerPos = playerNode.position + Vector3(0, 2.5, -20);
        cameraNode.position = cameraNode.position.Lerp(playerPos, MOVE_SPEED * timeStep);
    }

    void SpawnPlayer() {
        String playerPrefabRes = "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Prefabs/Player.xml";
        playerNode = SpawnPrefab(Vector3(0, 50, 6), playerPrefabRes, levelScene);
        @player = cast<CtrlsPlayer>(playerNode.scriptObject);
    }

    /*
    void Stop() { }
    void DelayedStart() { }
    void Update(float) { }
    void PostUpdate(float) { }
    void FixedUpdate(float) { }
    void FixedPostUpdate(float) { }
    void Save(Serializer&) { }
    void Load(Deserializer&) { }
    void WriteNetworkUpdate(Serializer&) { }
    void ReadNetworkUpdate(Deserializer&) { }
    void ApplyAttributes() { }
    void TransformChanged() { }
    */
}
