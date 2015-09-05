const StringHash PREFAB_RES("PrefabResource");
const StringHash PREFAB_GROUP("PrefabGroup");
// const String PREFAB_RES = "PrefabResource";

class PrefabSpawner : ScriptObject {
    void Start() {
        // log.Info("Start Prefab Spawner");
        SubscribeToEvent(node, "UpdatePrefabs", "HandleUpdatePrefabs");
    }

    void Stop() {
    }

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

                // Array<Node@> groupChildren = children[i].GetChildren();
                // for (uint x = 0; x < groupChildren.length; ++x) {
                //     SpawnPrefab(groupChildren[x]);
                // }
            }

            SpawnPrefab(children[i]);
        }
    }

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
}

class PrefabManager : ScriptObject {
    Array<Node@> addedNodes;

    void Start() {
        log.Info("Start prefab manager");

        // SubscribeToEvent(node, "NodeAdded", "HandleNodeAdded");
        // SubscribeToEvent("NodeRemoved", "HandleNodeRemoved");

        DelayedExecute(0.5, true, "void CheckChildren()");
    }

    void Stop() {
    }

    void CheckChildren() {
        Array<Node@> children = node.GetChildren();

        for (uint i = 0; i < children.length; ++i) {
            SpawnPrefab(children[i]);
        }
    }

    // void Update(float timeStep) {
    //     if (!addedNodes.empty) {
    //         for (uint i = 0; i < addedNodes.length; ++i) {
    //             if (addedNodes[i].vars.Contains(PREFAB_RES)) {
    //                 SpawnPrefab(addedNodes[i]);
    //             }

    //             addedNodes.Erase(i);
    //         }            
    //     }
    // }

    // void HandleNodeAdded(StringHash eventType, VariantMap& eventData) {
    //     Node@ addedNode = eventData["Node"].GetPtr();
    //     addedNodes.Push(addedNode);

    //     log.Info("Added node to scene : " + addedNode.typeName + " : " + addedNode.id);
    // }

    // void HandleNodeRemoved(StringHash eventType, VariantMap& eventData) {
    // }

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
}

class PrefabInstance : ScriptObject {
    String prefabResource;

    // void Start() { }
    // void Stop() { }

    // void ApplyAttributes() {
    //     SpawnPrefab();
    // }

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
