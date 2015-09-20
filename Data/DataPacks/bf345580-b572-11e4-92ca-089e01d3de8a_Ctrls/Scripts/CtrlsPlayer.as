#include "Global/Scripts/Player.as"

namespace CtrlsPlayerConstants {
    const int CTRL_UP    = 1;
    const int CTRL_DOWN  = 2;
    const int CTRL_LEFT  = 4;
    const int CTRL_RIGHT = 8;
    const int CTRL_JUMP  = 16;

    const float MOVE_FORCE           = 3.0f;
    const float INAIR_MOVE_FORCE     = 0.02f;
    const float BRAKE_FORCE          = 0.2f;
    const float JUMP_FORCE           = 50.0f;
    const float INAIR_THRESHOLD_TIME = 0.1f;

    const float CAM_MOVE_SPEED = 5.0f;
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

    void SubscribeToEvents() {
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

    Controls controls;
    bool onGround = false;
    bool okToJump = true;
    float inAirTimer = 0.0f;

    CtrlsPlayer() {
        // @controller = CtrlsPlayerController();
    }

    ~CtrlsPlayer() {
        // @controller = null;
    }

    void Start() {


        SubscribeToEvents();
        // controller.Start();
    }

    void DelayedStart() {
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
        // SubscribeToEvent("PostUpdate", "HandlePostUpdate");

        SubscribeToEvent("PlayerEvent_TestVol_Entered", "HandlePlayerEvent_TestVol_Entered");
        SubscribeToEvent("PlayerEvent_TestVol_Exited", "HandlePlayerEvent_TestVol_Exited");
    }

    void HandlePlayerEvent_TestVol_Entered(StringHash eventType, VariantMap& eventData) {
        log.Info("HandlePlayerEvent_TestVol_Entered triggered");
    }

    void HandlePlayerEvent_TestVol_Exited(StringHash eventType, VariantMap& eventData) {
        log.Info("HandlePlayerEvent_TestVol_Exited triggered");
    }

    void HandleUpdate(StringHash eventType, VariantMap& eventData) {
        // Clear previous controls
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

        float timeStep = eventData["TimeStep"].GetFloat();
        MoveCamera(timeStep);
    }

    void MoveCamera(float timeStep) {
        if (globalVars.Contains("GlobalCamera") && cast<Node>(globalVars["GlobalCamera"].GetPtr()) !is null) {
            Node@ cameraNode = cast<Node>(globalVars["GlobalCamera"].GetPtr());
            Vector3 playerPos = node.position + Vector3(0, 2.5, -20);
            cameraNode.position = cameraNode.position.Lerp(playerPos, CtrlsPlayerConstants::CAM_MOVE_SPEED * timeStep);
            cameraNode.rotation = Quaternion(0, 0, 0);
        }
    }

    void HandlePostUpdate(StringHash eventType, VariantMap& eventData) {
    }

    void FixedUpdate(float timeStep) {
        RigidBody@ body = node.GetComponent("RigidBody");
        Vector3 velocity = body.linearVelocity;
        Vector3 planeVelocity(velocity.x, 1.0f, velocity.z);
        Vector3 brakeForce = -planeVelocity * CtrlsPlayerConstants::BRAKE_FORCE;

        Vector3 moveDir(0.0f, 0.0f, 0.0f);

        if (controls.IsDown(CtrlsPlayerConstants::CTRL_LEFT))
            moveDir += Vector3(-1.0f, 0.0f, 0.0f);
        if (controls.IsDown(CtrlsPlayerConstants::CTRL_RIGHT))
            moveDir += Vector3(1.0f, 0.0f, 0.0f);

        // Normalize move vector
        if (moveDir.lengthSquared > 0.0f)
            moveDir.Normalize();

        body.ApplyImpulse(moveDir * CtrlsPlayerConstants::MOVE_FORCE);

        // Jump. Must release jump control inbetween jumps
        if (controls.IsDown(CtrlsPlayerConstants::CTRL_JUMP))
        {
            if (okToJump)
            {
                body.ApplyImpulse(Vector3(0.0f, 1.0f, 0.0f) * CtrlsPlayerConstants::JUMP_FORCE);
                okToJump = false;
            }
        }
        else
            okToJump = true;

        body.ApplyImpulse(brakeForce);
    }
}
