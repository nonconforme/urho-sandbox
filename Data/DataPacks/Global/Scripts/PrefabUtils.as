Node@ SpawnPrefab(Vector3 spawnLoc, String prefabRes, Scene@ spawnScene) {
    Node@ prefabNode;

    if (!prefabRes.empty) {
        File@ resFile = cache.GetFile(prefabRes);
        if (resFile !is null) {
            prefabNode = spawnScene.InstantiateXML(resFile, spawnLoc, Quaternion(0, 0, 0));
        }
    }

    return prefabNode;
}
