const StringHash PREFAB_RES("PrefabResource");
const StringHash PREFAB_GROUP("PrefabGroup");

void SpawnPrefab(Node@ newnode) {
    if (!newnode.vars.Contains(PREFAB_RES)) {
        return;
    }

    String prefabResource = newnode.vars[PREFAB_RES].GetString();
    if (!prefabResource.empty) {
        newnode.RemoveAllChildren();

        File@ resFile = cache.GetFile(prefabResource);
        if (resFile !is null) {
            Node@ prefabNode = newnode.scene.InstantiateXML(resFile, newnode.position, newnode.rotation);
            prefabNode.temporary = true;
            prefabNode.parent = newnode;
        }
    }
}

class PrefabSpawner : ScriptObject {
    void Start() {
        SubscribeToEvent(node, "UpdatePrefabs", "HandleUpdatePrefabs");
    }

    void Stop() { }

    void ApplyAttributes() {
        CheckForPrefabs(node);
    }

    void HandleUpdatePrefabs(StringHash eventType, VariantMap& eventData) {
        CheckForPrefabs(node);
    }

    void CheckForPrefabs(Node@ node) {
        if (node is null) { return; }

        Array<Node@> children = node.GetChildren();

        for (uint i = 0; i < children.length; ++i) {
            if (children[i].vars.Contains(PREFAB_GROUP) && children[i].vars[PREFAB_GROUP].GetBool()) {
                CheckForPrefabs(children[i]);
            }

            SpawnPrefab(children[i]);
        }
    }
}

class PrefabInstance : ScriptObject {
    void ApplyAttributes() {
        SpawnPrefab(node);
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
