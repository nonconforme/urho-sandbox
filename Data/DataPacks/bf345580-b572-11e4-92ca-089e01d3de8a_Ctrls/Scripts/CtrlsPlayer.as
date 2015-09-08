#include "Global/Scripts/Player.as"

namespace CtrlsPlayerConstants {
    const int CTRL_UP    = 1;
    const int CTRL_DOWN  = 2;
    const int CTRL_LEFT  = 4;
    const int CTRL_RIGHT = 8;
    const int CTRL_JUMP  = 16;

    const float MOVE_FORCE           = 3.8f;
    const float INAIR_MOVE_FORCE     = 0.02f;
    const float BRAKE_FORCE          = 0.2f;
    const float JUMP_FORCE           = 7.0f;
    const float INAIR_THRESHOLD_TIME = 0.1f;
}

class CtrlsPlayerController : PlayerController {

    WeakHandle currentTarget;

    CtrlsPlayerController() {
        // log.Info("Constructing controller.");
    }

    ~CtrlsPlayerController() {
        // log.Info("Destructing controller.");
    }

    void Start() {
        SubscribeToEvents();
    }

    void Stop() {
        UnsubscribeFromAllEvents();
    }

    void SubscribeToEvents()
    {
        SubscribeToEvent("Update", "HandleUpdate");
        SubscribeToEvent("PostUpdate", "HandlePostUpdate");
    }

    void HandleUpdate(StringHash eventType, VariantMap& eventData) {

    }

    void HandlePostUpdate(StringHash eventType, VariantMap& eventData) {
    }
}

class CtrlsPlayer : Player {
    // CtrlsPlayerController@ controller;

    // Character controls.
    Controls controls;
    // Grounded flag for movement.
    bool onGround = false;
    // Jump flag.
    bool okToJump = true;
    // In air timer. Due to possible physics inaccuracy, character can be off ground for max. 1/10 second and still be allowed to move.
    float inAirTimer = 0.0f;

    Node@ cameraNode;

    CtrlsPlayer() {
        // @controller = CtrlsPlayerController();
    }

    ~CtrlsPlayer() {
        // @controller = null;
    }

    void Start() {
        // log.Info("Starting CtrlsPlayer : " + self.id);

        SubscribeToEvents();
        // controller.Start();
    }

    void DelayedStart() {
        Array<Node@> sceneChildren = scene.GetChildren();
        for (uint i = 0; i < sceneChildren.length; ++i) {
            log.Info("Node in scene : " + sceneChildren[i].name);
        }

        // Array<Node@> cameraNodes = scene.GetChildrenWithComponent("Camera");
        // if (cameraNodes.length > 0) {
        //     log.Info("Found the main camera.");
        //     cameraNode = cameraNodes[0];
        // }
        // else {
        //     log.Info("Did not find the main camera.");
        // }
    }

    void Stop() {
        UnsubscribeFromAllEvents();
        // controller.Stop();
    }

    void SubscribeToEvents()
    {
        // Subscribe to Update event for setting the character controls before physics simulation
        SubscribeToEvent("Update", "HandleUpdate");

        // Subscribe to PostUpdate event for updating the camera position after physics simulation
        SubscribeToEvent("PostUpdate", "HandlePostUpdate");
    }

    void HandleUpdate(StringHash eventType, VariantMap& eventData) {
        // Clear previous controls
        // controls.Set(
        //              CtrlsPlayerConstants::CTRL_LEFT |
        //              CtrlsPlayerConstants::CTRL_RIGHT |
        //              CtrlsPlayerConstants::CTRL_JUMP,
        //              false);

        // controls.Set(CtrlsPlayerConstants::CTRL_UP    , input.keyDown['W']);
        // controls.Set(CtrlsPlayerConstants::CTRL_DOWN  , input.keyDown['S']);
        // controls.Set(CtrlsPlayerConstants::CTRL_LEFT  , input.keyDown['A']);
        // controls.Set(CtrlsPlayerConstants::CTRL_RIGHT , input.keyDown['D']);
        // controls.Set(CtrlsPlayerConstants::CTRL_JUMP  , input.keyDown[KEY_SPACE]);

        // float timeStep = eventData["TimeStep"].GetFloat();
        // MoveCamera(timeStep);
    }

    void MoveCamera(float timeStep) {
        // if (cameraNode is null) {
        //     return;
        // }

        // cameraNode.position = node.position + Vector3(0, 0, -10);
    }

    void HandlePostUpdate(StringHash eventType, VariantMap& eventData) {
    }

    void FixedUpdate(float timeStep) {
        Vector3 moveDir(0.0f, 0.0f, 0.0f);

        controls.Set(
                     CtrlsPlayerConstants::CTRL_LEFT |
                     CtrlsPlayerConstants::CTRL_RIGHT |
                     CtrlsPlayerConstants::CTRL_JUMP,
                     false);

        controls.Set(CtrlsPlayerConstants::CTRL_UP    , input.keyDown['W']);
        controls.Set(CtrlsPlayerConstants::CTRL_DOWN  , input.keyDown['S']);
        controls.Set(CtrlsPlayerConstants::CTRL_LEFT  , input.keyDown['A']);
        controls.Set(CtrlsPlayerConstants::CTRL_RIGHT , input.keyDown['D']);
        controls.Set(CtrlsPlayerConstants::CTRL_JUMP  , input.keyDown[KEY_SPACE]);


        RigidBody@ body = node.GetComponent("RigidBody");

        // if (controls.IsDown(CTRL_FORWARD))
        //     moveDir += Vector3(0.0f, 0.0f, 1.0f);
        // if (controls.IsDown(CTRL_BACK))
        //     moveDir += Vector3(0.0f, 0.0f, -1.0f);
        if (controls.IsDown(CtrlsPlayerConstants::CTRL_LEFT))
            moveDir += Vector3(-1.0f, 0.0f, 0.0f);
        if (controls.IsDown(CtrlsPlayerConstants::CTRL_RIGHT))
            moveDir += Vector3(1.0f, 0.0f, 0.0f);

        // Normalize move vector
        if (moveDir.lengthSquared > 0.0f)
            moveDir.Normalize();

        body.ApplyImpulse(moveDir * CtrlsPlayerConstants::MOVE_FORCE);
    }
}

class CtrlsPlayerStart : PlayerStart {

}