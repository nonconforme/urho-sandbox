
class Application {

    Application() {
        SubscribeToEvent("KeyDown", "HandleKeyDown");
    }

    ~Application() {
        UnsubscribeFromAllEvents();
    }

    void SetWindowTitleAndIcon() {
        Image@ icon = cache.GetResource("Image", "Textures/UrhoIcon.png");
        graphics.windowIcon = icon;
        graphics.windowTitle = "Urho3D Sample";
    }

    void CreateConsoleAndDebugHud() {
        // Get default style
        XMLFile@ xmlFile = cache.GetResource("XMLFile", "UI/DefaultStyle.xml");
        if (xmlFile is null)
            return;

        // Create console
        Console@ console = engine.CreateConsole();
        console.defaultStyle = xmlFile;
        console.background.opacity = 0.8f;

        // Create debug HUD
        DebugHud@ debugHud = engine.CreateDebugHud();
        debugHud.defaultStyle = xmlFile;
    }

    void HandleKeyDown(StringHash eventType, VariantMap& eventData) {
        int key = eventData["Key"].GetInt();

        // Close console (if open) or exit when ESC is pressed
        if (key == KEY_ESC)
        {
            if (!console.visible)
                engine.Exit();
            else
                console.visible = false;
        }

        // Toggle console with F1
        else if (key == KEY_F1)
            console.Toggle();

        // Toggle debug HUD with F2
        else if (key == KEY_F2)
            debugHud.ToggleAll();

        // Common rendering quality controls, only when UI has no focused element
        if (ui.focusElement is null)
        {
            // Texture quality
            if (key == '1')
            {
                int quality = renderer.textureQuality;
                ++quality;
                if (quality > QUALITY_HIGH)
                    quality = QUALITY_LOW;
                renderer.textureQuality = quality;
            }

            // Material quality
            else if (key == '2')
            {
                int quality = renderer.materialQuality;
                ++quality;
                if (quality > QUALITY_HIGH)
                    quality = QUALITY_LOW;
                renderer.materialQuality = quality;
            }

            // Specular lighting
            else if (key == '3')
                renderer.specularLighting = !renderer.specularLighting;

            // Shadow rendering
            else if (key == '4')
                renderer.drawShadows = !renderer.drawShadows;

            // Shadow map resolution
            else if (key == '5')
            {
                int shadowMapSize = renderer.shadowMapSize;
                shadowMapSize *= 2;
                if (shadowMapSize > 2048)
                    shadowMapSize = 512;
                renderer.shadowMapSize = shadowMapSize;
            }

            // Shadow depth and filtering quality
            else if (key == '6')
            {
                int quality = renderer.shadowQuality;
                ++quality;
                if (quality > SHADOWQUALITY_HIGH_24BIT)
                    quality = SHADOWQUALITY_LOW_16BIT;
                renderer.shadowQuality = quality;
            }

            // Occlusion culling
            else if (key == '7')
            {
                bool occlusion = renderer.maxOccluderTriangles > 0;
                occlusion = !occlusion;
                renderer.maxOccluderTriangles = occlusion ? 5000 : 0;
            }

            // Instancing
            else if (key == '8')
                renderer.dynamicInstancing = !renderer.dynamicInstancing;

            // Take screenshot
            else if (key == '9')
            {
                Image@ screenshot = Image();
                graphics.TakeScreenShot(screenshot);
                // Here we save in the Data folder with date and time appended
                screenshot.SavePNG(fileSystem.programDir + "Data/Screenshot_" +
                    time.timeStamp.Replaced(':', '_').Replaced('.', '_').Replaced(' ', '_') + ".png");
            }
        }
    }
}
