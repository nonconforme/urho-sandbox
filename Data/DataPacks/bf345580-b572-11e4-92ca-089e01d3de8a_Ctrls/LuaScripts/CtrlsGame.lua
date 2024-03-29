-- Ctrl-S Game
-- 
-- 
-- 
-- 


_datapackUUID_Ctrls = 'bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls/'
_datapackUUID_Scratch = 'cce19b62-b56e-11e4-87b4-089e01d3de8a_Scratch/'

require "LuaScripts/Utilities/Sample"
require "debug"
require (_datapackUUID_Ctrls .. "/LuaScripts/Utilities/Debugger")

function Start()
   OpenConsoleWindow()
   -- print('debug output.')
   -- Debugger.trace()

   -- Execute the common startup for samples
   SampleStart()

   -- debug.traceback()
   
   -- Create static scene content
   CreateScene()

    -- Setup the viewport for displaying the scene
    SetupViewport()
   
   -- Subscribe to necessary events
   SubscribeToEvents()
end

function CreateScene()
    scene_ = Scene()

    -- Create octree, use default volume (-1000, -1000, -1000) to (1000, 1000, 1000)
    -- Also create a DebugRenderer component so that we can draw debug geometry
    scene_:CreateComponent("Octree")
    scene_:CreateComponent("DebugRenderer")

    -- Create scene node & StaticModel component for showing a static plane
    local planeNode = scene_:CreateChild("Plane")
    planeNode.scale = Vector3(100.0, 1.0, 100.0)
    local planeObject = planeNode:CreateComponent("StaticModel")
    planeObject.model = cache:GetResource("Model", "Models/Plane.mdl")
    planeObject.material = cache:GetResource("Material", "Materials/StoneTiled.xml")

    -- Create a Zone component for ambient lighting & fog control
    local zoneNode = scene_:CreateChild("Zone")
    local zone = zoneNode:CreateComponent("Zone")
    zone.boundingBox = BoundingBox(-1000.0, 1000.0)
    zone.ambientColor = Color(0.15, 0.15, 0.15)
    zone.fogColor = Color(0.5, 0.5, 0.7)
    zone.fogStart = 100.0
    zone.fogEnd = 300.0

    -- Create a directional light to the world. Enable cascaded shadows on it
    local lightNode = scene_:CreateChild("DirectionalLight")
    lightNode.direction = Vector3(0.6, -1.0, 0.8)
    local light = lightNode:CreateComponent("Light")
    light.lightType = LIGHT_DIRECTIONAL
    light.castShadows = true
    light.shadowBias = BiasParameters(0.00025, 0.5)
    -- Set cascade splits at 10, 50 and 200 world units, fade shadows out at 80% of maximum shadow distance
    light.shadowCascade = CascadeParameters(10.0, 50.0, 200.0, 0.0, 0.8)

    -- Create the test animated model
    local modelNode = scene_:CreateChild("TestChar_01")
    modelNode.position = Vector3(10, 0, 10)
    modelNode.rotation = Quaternion(0, 0, 0)
    local modelObject = modelNode:CreateComponent("AnimatedModel")
    
    modelObject.model = cache:GetResource("Model", _datapackUUID_Scratch .. "/Characters/TestChar_01/Models/TestChar_01.mdl")
    modelObject.material = cache:GetResource("Material", _datapackUUID_Scratch .. "/Characters/TestChar_01/Materials/Material.xml")

    -- modelObject.model = cache:GetResource("Model", "Scratch/Characters/TestChar_01/Models/TestChar_01.mdl")
    -- modelObject.material = cache:GetResource("Material", "Scratch/Characters/TestChar_01/Materials/Material.xml")
    modelObject.castShadows = true

    -- Add animation to model
    local testAnimation = cache:GetResource("Animation", _datapackUUID_Scratch .. "/Characters/TestChar_01/Models/Action.000.ani")
    -- local testAnimation = cache:GetResource("Animation", "Scratch/Characters/TestChar_01/Models/Action.000.ani")
    local state = modelObject:AddAnimationState(testAnimation)
    -- Enable full blending weight and looping
    state.weight = 1.0
    state.looped = true

    local object = modelNode:CreateScriptObject("Animator")

    -- Create the camera. Limit far clip distance to match the fog
    cameraNode = scene_:CreateChild("Camera")
    local camera = cameraNode:CreateComponent("Camera")
    camera.farClip = 300.0

    -- Set an initial position for the camera scene node above the plane
    cameraNode.position = Vector3(0.0, 5.0, 0.0)

    -- Load test scene file
    
    xmlFile = cache:GetFile(_datapackUUID_Scratch .. "/Scenes/SubScene_TestScene_01.xml")
    -- xmlFile = cache:GetFile("Scratch/Scenes/SubScene_TestScene_01.xml")
    local subSceneNode = scene_:InstantiateXML(xmlFile, Vector3(0, 0, 0), Quaternion(0, 0, 0), LOCAL)
end

function SetupViewport()
    -- Set up a viewport to the Renderer subsystem so that the 3D scene can be seen
    local viewport = Viewport:new(scene_, cameraNode:GetComponent("Camera"))
    renderer:SetViewport(0, viewport)
end

function SubscribeToEvents()
    -- Subscribe HandleUpdate() function for processing update events
    SubscribeToEvent("Update", "HandleUpdate")

    -- Subscribe HandlePostRenderUpdate() function for processing the post-render update event, sent after Renderer subsystem is
    -- done with defining the draw calls for the viewports (but before actually executing them.) We will request debug geometry
    -- rendering during that event
    SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate")
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
    yaw = yaw + MOUSE_SENSITIVITY * mouseMove.x
    pitch = pitch + MOUSE_SENSITIVITY * mouseMove.y
    pitch = Clamp(pitch, -90.0, 90.0)

    -- Construct new orientation for the camera scene node from yaw and pitch. Roll is fixed to zero
    cameraNode.rotation = Quaternion(pitch, yaw, 0.0)

    -- Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
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
    -- Toggle debug geometry with space
    if input:GetKeyPress(KEY_SPACE) then
        drawDebug = not drawDebug
    end
end

function HandleUpdate(eventType, eventData)
    -- Take the frame time step, which is stored as a float
    local timeStep = eventData:GetFloat("TimeStep")

    -- Move the camera, scale movement with time step
    MoveCamera(timeStep)
end

function HandlePostRenderUpdate(eventType, eventData)
    -- If draw debug mode is enabled, draw viewport debug geometry, which will show eg. drawable bounding boxes and skeleton
    -- bones. Note that debug geometry has to be separately requested each frame. Disable depth test so that we can see the
    -- bones properly
    -- if drawDebug then
    --     renderer:DrawDebugGeometry(false)
    -- end
end

-- Animator script object class
Animator = ScriptObject()

function Animator:Start()

end

function Animator:Update(timeStep)
    local node = self:GetNode()

    -- Get the model's first (only) animation state and advance its time
    local model = node:GetComponent("AnimatedModel")
    local state = model:GetAnimationState(0)
    if state ~= nil then
        state:AddTime(timeStep)
    end
end
