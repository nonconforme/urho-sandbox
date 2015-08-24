
-- ======================================================
function CreateScene()
    scene_ = defaultScene
    scene_:CreateComponent("Octree")

    local planeNode = scene_:CreateChild("Plane")
    planeNode.scale = Vector3(100.0, 1.0, 100.0)
    local planeObject = planeNode:CreateComponent("StaticModel")
    planeObject.model = cache:GetResource("Model", "Models/Plane.mdl")

    local lightNode = scene_:CreateChild("DirectionalLight")
    lightNode.direction = Vector3(0.6, -1.0, 0.8)
    local light = lightNode:CreateComponent("Light")
    light.lightType = LIGHT_DIRECTIONAL

    local NUM_OBJECTS = 200
    for i = 1, NUM_OBJECTS do
        local mushroomNode = scene_:CreateChild("Mushroom")
        mushroomNode.position = Vector3(Random(90.0) - 45.0, 0.0, Random(90.0) - 45.0)
        mushroomNode.rotation = Quaternion(0.0, Random(360.0), 0.0)
        mushroomNode:SetScale(0.5 + Random(2.0))
        local mushroomObject = mushroomNode:CreateComponent("StaticModel")
        mushroomObject.model = cache:GetResource("Model", "Models/Mushroom.mdl")
    end

    cameraNode = scene_:CreateChild("Camera")
    cameraNode:CreateComponent("Camera")
    cameraNode.position = Vector3(0.0, 5.0, 0.0)
end

function SetupViewport()
    local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"))
    renderer:SetViewport(0, viewport)
end

function MoveCamera(timeStep)
    -- Do not move if the UI has a focused element (the console)
    if ui.focusElement ~= nil then
        return
    end

    -- Movement speed as world units per second
    local MOVE_SPEED = 20.0
    -- Mouse sensitivity as degrees per pixel
    local MOUSE_SENSITIVITY = 0.1

    -- Use this frame's mouse motion to adjust camera node yaw and pitch. Clamp the pitch between -90 and 90 degrees
    local mouseMove = input.mouseMove
    yaw = yaw +MOUSE_SENSITIVITY * mouseMove.x
    pitch = pitch + MOUSE_SENSITIVITY * mouseMove.y
    pitch = Clamp(pitch, -90.0, 90.0)

    -- Construct new orientation for the camera scene node from yaw and pitch. Roll is fixed to zero
    cameraNode.rotation = Quaternion(pitch, yaw, 0.0)

    -- Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
    -- Use the Translate() function (default local space) to move relative to the node's orientation.
    if input:GetKeyDown(KEY_W) then
        cameraNode:Translate(Vector3(0.0, 0.0, 1.0) * MOVE_SPEED * timeStep)
    end
    if input:GetKeyDown(KEY_S) then
        cameraNode:Translate(Vector3(0.0, 0.0, -1.0) * MOVE_SPEED * timeStep)
    end
    if input:GetKeyDown(KEY_A) then
        cameraNode:Translate(Vector3(-1.0, 0.0, 0.0) * MOVE_SPEED * timeStep)
    end
    if input:GetKeyDown(KEY_D) then
        cameraNode:Translate(Vector3(1.0, 0.0, 0.0) * MOVE_SPEED * timeStep)
    end
end

function SubscribeToEvents()
    SubscribeToEvent("Update", "HandleUpdate")
end

function HandleUpdate(eventType, eventData)
    local timeStep = eventData["TimeStep"]:GetFloat()
    MoveCamera(timeStep)
end


-- ======================================================
-- MainEntry script object class
MainEntry = ScriptObject()

function MainEntry:Start()
   PrintLine('Calling MainEntry Script.')
   PrintLine('This is loading the pack for Ctrls.')

   graphics:SetWindowPosition(0, 0);

   CreateScene()
   SetupViewport()
   SubscribeToEvents()
end

function MainEntry:HandleKeyDown()
end

function MainEntry:SubscribeToEvents()
end

function MainEntry:HandleUpdate(eventType, eventData)
end

function MainEntry:MoveCamera(timeStep)
end

function MainEntry:Stop()
end

function MainEntry:DelayedStart()
end

function MainEntry:Update(timeStep)
end

function MainEntry:PostUpdate(timeStep)
end

function MainEntry:FixedUpdate(timeStep)
end

function MainEntry:FixedPostUpdate(timeStep)
end

function MainEntry:Save(serializer)
end

function MainEntry:Load(deserializer)
end

function MainEntry:WriteNetworkUpdate(serializer)
end

function MainEntry:ReadNetworkUpdate(deserializer)
end

function MainEntry:ApplyAttributes()
end

function MainEntry:TransformChanged()
end
