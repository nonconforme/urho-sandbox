Scene@ gscene;
Node@ mainEntry;

void Start()
{
    CreateStartupScene();
    CallMainScript();
}

void CreateStartupScene() {
    gscene = Scene("GlobalScene");
    gscene.CreateComponent("Octree");
}

void CallMainScript() {
    Array<String> arguments = GetArguments();
    String startPackUUID = "";

    for (uint i = 0; i < arguments.length; ++i) {
        String argument = arguments[i].ToLower();
        if (argument[0] == '-')
        {
            argument = argument.Substring(1);
            if (argument == "startpackuuid")
            {
                log.Info("Command Line Args : " + arguments[i + 1]);
                startPackUUID = arguments[i + 1];
            }
        }
    }

    if (!startPackUUID.empty) {
        ScriptFile@ mainScriptFile = cache.GetResource("ScriptFile", startPackUUID + "/MainScript.as");
        if (mainScriptFile !is null && mainScriptFile.compiled) {
            mainEntry = gscene.CreateChild("MainEntry");
            ScriptInstance@ gameMainScriptInstance = mainEntry.CreateComponent("ScriptInstance");
            gameMainScriptInstance.CreateObject(mainScriptFile, "MainEntry");
        }
        else {
            log.Error("Could not Call Main Entry Script.");
        }
    }

}
