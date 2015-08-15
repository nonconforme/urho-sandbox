#include "Global/Scripts/Utilities/Sample.as"

void CtrlsGame_Main()
{
    log.Info("Start the Ctrls Game....WOOT!");
}

// Create XML patch instructions for screen joystick layout specific to this sample app
String patchInstructions =
        "<patch>" +
        "    <add sel=\"/element/element[./attribute[@name='Name' and @value='Hat0']]\">" +
        "        <attribute name=\"Is Visible\" value=\"false\" />" +
        "    </add>" +
        "</patch>";
