class TestScriptComponent_01 : ScriptObject
{
    void Start() {
        log.Info("Started script instance.");
        SpawnPrefab();
    }

    void Stop() {

    }

    void Update(float timeStep) {

    }

    void SpawnPrefab() {
        File@ resFile = cache.GetFile( node.vars["Resource"].GetString() );
        Node@ prefabNode = node.scene.InstantiateXML(resFile, node.position, node.rotation);
        prefabNode.temporary = true;
        prefabNode.parent = node;
    }

    void RemovePrefab() {
    }
}

class ScriptObjAttributes_01 : ScriptObject {
    Array<String> refabResourceNames = {
        "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Prefabs/GridSection.000.xml",
        "bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/Prefabs/GridSection.001.xml"
    };

    bool finishedInit = false;

    void Start() {
    }

    void Stop() {
        finishedInit = false;
    }

    void Update(float timeStep) {
        if (!finishedInit) {
            Init();
        }
    }

    void Init() {
        finishedInit = true;

        Node@[] children = node.GetChildren();
        for(uint i = 0; i < children.length; ++i)
        {
            if (children[i].vars.Contains("SectionIndex")) {
                int prefabIndex = Abs(children[i].vars["SectionIndex"].GetInt()) % refabResourceNames.length;
                log.Info("Selected Index : " + prefabIndex);
                SpawnPrefab(children[i], prefabIndex);
            }
        }
    }

    void SpawnPrefab(Node@ node, uint index) {
        Node@ prefabNode = node.scene.InstantiateXML(cache.GetFile(refabResourceNames[index]), node.position, node.rotation);
        if (prefabNode !is null) {
            prefabNode.temporary = true;
            prefabNode.parent = node;
        }
    }

}
