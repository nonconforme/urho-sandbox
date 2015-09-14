#include "Global/Scripts/Globals.as"

class PlayerStart : ScriptObject {
    void Start() {
    }

    void DelayedStart() {
        if (!GetDefaultSceneVars().Contains("GEditorMode")) {
            StaticModel@ staticModel = node.GetComponent("StaticModel");
            staticModel.enabled = false;
        }
    }
}


// void Start()
// void Stop()
// void DelayedStart()
// void Update(float)
// void PostUpdate(float)
// void FixedUpdate(float)
// void FixedPostUpdate(float)
// void Save(Serializer&)
// void Load(Deserializer&)
// void WriteNetworkUpdate(Serializer&)
// void ReadNetworkUpdate(Deserializer&)
// void ApplyAttributes()
// void TransformChanged()

