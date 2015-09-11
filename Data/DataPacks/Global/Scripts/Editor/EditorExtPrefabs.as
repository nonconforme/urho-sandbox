
void CreatePrefabMenu() {
    UIElement@ uiMenuBar = ui.root.GetChild("MenuBar", false);
    if (uiMenuBar is null) {
        return;
    }

    {
        Menu@ menu = CreateMenu("Prefabs");
        Window@ popup = menu.popup;
        popup.AddChild(CreateMenuItem("Update Prefabs", @SceneUpdatePrefabs, 'P', QUAL_SHIFT | QUAL_CTRL));

        CreateChildDivider(popup);

        FinalizedPopupMenu(popup);
        uiMenuBar.InsertChild(uiMenuBar.numChildren - 2, menu);
    }
}

bool SceneUpdatePrefabs() {
    Array<Node@> allNodes = scene.GetChildren(true);
    for(uint i = 0; i < allNodes.length; i++) {
        SpawnPrefab(allNodes[i]);
    }

    return true;
}

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
            // prefabNode.temporary = true;
            prefabNode.parent = newnode;
        }
    }
}
