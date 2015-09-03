//
//

#include "Global/Scripts/Utilities/Sample.as"
#include "Global/Scripts/GameClasses.as"

Scene@ mainScene;
Node@ gameManager;
Node@ prefabManager;
Array<Scene@> gameScenes;

GameInfo@ gameInfo;

Node@ someNode;

void Start()
{
    // OpenConsoleWindow();
    SampleStart();

    CreateStartupScene();
    CallMainScript();
}

void CreateStartupScene() {
    mainScene = Scene("MainScene");

    Node@ testNode = mainScene.CreateChild("TestNode");
    // for (uint i = 0; i < testNode.attributes.length; i++) {
    //     log.Info("Attr Value : " + testNode.attributes[i].ToString());
    // }

    someNode = testNode;

    // bool result = mainScene.SetAttribute("TestAttr", Variant("this-is-a-test-value"));
    // if (!result) {
    //     log.Info("Could not set attribute.");
    // }
    // log.Info("Test Attr : " + mainScene.GetAttribute("TestAttr").ToString());

    gameScenes.Push(mainScene);

    // Enable access to this script file & scene from the console
    script.defaultScene = mainScene;
    script.defaultScriptFile = scriptFile;

    mainScene.CreateComponent("Octree");

    // game manager
    gameManager = mainScene.CreateChild("GameManager");
    ScriptInstance@ gmScriptInstance = gameManager.CreateComponent("ScriptInstance");
    gmScriptInstance.CreateObject(scriptFile, "GameManager");
    GameManager@ gameManager = cast<GameManager>(gmScriptInstance.scriptObject);

    // prefab manager
    ScriptFile@ prefabScriptFile = cache.GetResource("ScriptFile", "Global/Scripts/Prefabs.as");
    if (prefabScriptFile !is null) {
        prefabManager = mainScene.CreateChild("PrefabManager");
        ScriptInstance@ prefabManScriptInstance = prefabManager.CreateComponent("ScriptInstance");
        prefabManScriptInstance.CreateObject(prefabScriptFile, "PrefabManager");
        // PrefabManager@ gameManager = cast<GameManager>(gmScriptInstance.scriptObject);
    }

    log.Info("List of game scenes : " + gameScenes.length);
    log.Info("Scene Name : " + gameScenes[0].name);
    log.Info("Test Attr : " + gameScenes[0].GetAttribute("TestAttr").ToString());

    // gameInfo = GameInfo();
    // gameManager.SetMainScript(gameInfo);
}

void CallMainScript() {
    Array<String> arguments = GetArguments();
    String startPackUUID = "";

    for (uint i = 0; i < arguments.length; ++i) {
        String argument = arguments[i].ToLower();
        // log.Info("Command Line Args : " + argument);

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
            ScriptInstance@ gameMainScriptInstance = gameManager.CreateComponent("ScriptInstance");
            gameMainScriptInstance.CreateObject(mainScriptFile, "MainEntry");
        }
        else {
            log.Error("Could not Call Main Entry Script.");
        }
    }

}

// Create XML patch instructions for screen joystick layout specific to this sample app
String patchInstructions =
        "<patch>" +
        "    <add sel=\"/element/element[./attribute[@name='Name' and @value='Hat0']]\">" +
        "        <attribute name=\"Is Visible\" value=\"false\" />" +
        "    </add>" +
        "</patch>";
