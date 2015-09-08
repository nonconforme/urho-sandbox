#include "Global/Scripts/Globals.as"
#include "Global/Scripts/Utilities/Sample.as"
#include "Global/Scripts/GameClasses.as"
#include "StartGame.as"

Scene@ levelScene;

bool levelLoaded = false;

class MainEntry : ScriptObject {
    void Start() {
        log.Info("Calling MainEntry Script.");
        log.Info("Scene Name is : " + scene.name);
        log.Info("This is loading the pack for Ctrls.");

        levelScene = Scene("LevelScene");

        SubscribeToEvent("KeyDown", "HandleKeyDown");
        
        cameraNode = Node();
        cameraNode.position = cameraNode.position + Vector3(0, 1, 0);
        Camera@ camera = cameraNode.CreateComponent("Camera");
        camera.farClip = 300.0f;
        renderer.viewports[0] = Viewport(levelScene, camera);

        SubscribeToEvents();

        graphics.SetWindowPosition(0, 0);

        levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Levels/Entry.xml"));
        levelLoaded = true;
    }

    void HandleKeyDown(StringHash eventType, VariantMap& eventData) {
        int key = eventData["Key"].GetInt();

        if (key == KEY_L) {
            if (!levelLoaded) {
                // levelScene.LoadXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/EntryScene_01.xml"));
                // levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/PrefabLoadTest_01.xml"));
                // levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Scenes/PrefabLoadTest_02.xml"));
                levelScene.LoadAsyncXML(cache.GetFile("bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Levels/Entry.xml"));
                levelLoaded = true;
            }
            else {
                if (!levelScene.asyncLoading) {
                    log.Info("Unloading Scene.");

                    levelScene.RemoveAllChildren();
                    levelLoaded = false;
                }
            }

        }
    }

    void SubscribeToEvents()
    {
        // Subscribe HandleUpdate() function for processing update events
        SubscribeToEvent("Update", "HandleUpdate");
    }

    void HandleUpdate(StringHash eventType, VariantMap& eventData)
    {
        if (levelScene.asyncLoading) {
            log.Info("Loading Level Progress : " + levelScene.asyncProgress);
        }

        // Take the frame time step, which is stored as a float
        float timeStep = eventData["TimeStep"].GetFloat();

        // Move the camera, scale movement with time step
        // MoveCamera(timeStep);
    }

    void MoveCamera(float timeStep)
    {
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
