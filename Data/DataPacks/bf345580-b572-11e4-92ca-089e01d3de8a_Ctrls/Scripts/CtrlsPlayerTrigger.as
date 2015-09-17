class CtrlsPlayerTrigger : ScriptObject {
    String onEnterEventName;
    String onExitEventName;

    void Start() {
        RigidBody@ body = node.CreateComponent("RigidBody");
        body.trigger = true;

        SubscribeToEvents();
    }

    void DelayedStart() {
    }

    void ApplyAttributes() {
    }

    void SubscribeToEvents() {
        SubscribeToEvent(node, "NodeCollisionStart", "HandleNodeCollisionStart");
        SubscribeToEvent(node, "NodeCollisionEnd", "HandleNodeCollisionEnd");
    }

    void HandleNodeCollisionStart(StringHash eventType, VariantMap& eventData) {
        SendEnterEvent();
    }

    void HandleNodeCollisionEnd(StringHash eventType, VariantMap& eventData) {
        SendExitEvent();
    }

    void SendEnterEvent() {
        if (onEnterEventName.empty) { return; }
        SendEvent(onEnterEventName);
    }

    void SendExitEvent() {
        if (onExitEventName.empty) { return; }
        SendEvent(onExitEventName);
    }
}
