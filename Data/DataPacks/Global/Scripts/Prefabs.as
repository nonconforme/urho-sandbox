class PrefabManager : ScriptObject {
    void Start() {
        log.Info("Start prefab manager");

        // SubscribeToEvent(node.scene, "NodeAdded", "HandleNodeAdded");
        SubscribeToEvent("NodeAdded", "HandleNodeAdded");
        // SubscribeToEvent("NodeAdded", "HandleUpdate");
    }

    void Stop() {
    }

    void HandleNodeAdded(StringHash eventType, VariantMap& eventData)
    {
        Node@ newnode = eventData["Node"].GetPtr();
        log.Info("Node added to scene : " + newnode.name);
    }
}

class PrefabInstance : ScriptObject {
    String prefabResource;

    // void Start() { }
    // void Stop() { }

    void ApplyAttributes() {
        SpawnPrefab();
    }

    void SpawnPrefab() {
        node.RemoveAllChildren();

        if (!prefabResource.empty) {
            File@ resFile = cache.GetFile(prefabResource);
            if (resFile !is null) {
                Node@ prefabNode = node.scene.InstantiateXML(resFile, node.position, node.rotation);
                prefabNode.temporary = true;
                prefabNode.parent = node;
            }
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
