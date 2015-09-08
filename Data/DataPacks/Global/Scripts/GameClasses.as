
class GameInfo {
    String someName;
}

class GameManager : ScriptObject {
    void Start() {
        log.Info("Starting the Game Manager.");
        log.Info("Scene Name is : " + scene.name);
    }

    void Stop() {
        log.Info("Stopping the Game Manager.");
    }

    void SetMainScript(GameInfo@ gameInfo) {
        log.Info("Something from main script : " + gameInfo.someName);
    }

    void AddScene(Scene@ scene) {

    }

    void RemoveScene(String sceneName) {
    }

    void RemoveScene(Scene@ scene) {

    }

    // void Update(float timeStep) {
    //     log.Info("Updating the Game Manager : " + timeStep);
    // }
}
