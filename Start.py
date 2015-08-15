import os
import sys
import subprocess
import pdb

URHO_BIN_PLAYER = None
if os.environ.get('URHO_DEBUG') is not None and os.environ['URHO_DEBUG'] == 'true':
    URHO_BIN_PLAYER = 'Urho3DPlayer_d.exe'
else:
    URHO_BIN_PLAYER = 'Urho3DPlayer.exe'

URHO_PATH_BIN = None
if os.environ.get('URHO_PATH_BIN') is not None:
    URHO_PATH_BIN = os.environ['URHO_PATH_BIN']
else:
    sys.exit('Could not locate urho3d URHO_PATH_BIN env variable.')

URHO_PATH_DATA = None
if os.environ.get('URHO_PATH_DATA') is not None:
    URHO_PATH_DATA = os.environ['URHO_PATH_DATA']
else:
    sys.exit('Could not locate urho3d URHO_PATH_DATA env variable.')

URHO3D_PATH_PREFIX = None
if os.environ.get('URHO3D_PATH_PREFIX') is not None:
    URHO3D_PATH_PREFIX = os.environ['URHO3D_PATH_PREFIX']
else:
    sys.exit('Could not locate urho3d URHO3D_PATH_PREFIX env variable.')

def start_game():
    file_dir = os.path.dirname(os.path.realpath(__file__))
    start_cmd = os.path.join(URHO_PATH_BIN, URHO_BIN_PLAYER)

    resource_paths = {
        'Data'      : 'Data',
        'CoreData'  : 'CoreData',
        'DataPacks' : 'DataPacks'
    }

    # set project resource paths
    if sys.argv[2] is not None:
        urho_project = sys.argv[2].lower()

        if urho_project == 'ctrl-s':
            # screen_args = '-x 640 -y 480 -borderless'
            screen_args = '-x 864 -y 486 -borderless'
            prefix_path = '-pp "' + URHO3D_PATH_PREFIX + '"'
            autoload_paths_arg = '-ap "' + URHO3D_PATH_PREFIX + '"'

            resource_paths_arg = '-p '
            for key, value in resource_paths.items():
                resource_paths_arg += value + ';'

            # standard_args = '-w -deferred -noshadows'
            standard_args = '-w -deferred -log debug'
            script_arg = 'StartGame.as'
            start_args = '-startpackuuid bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls'

            start_cmd += (' '
                + script_arg + ' ' 
                + resource_paths_arg + ' ' 
                + autoload_paths_arg + ' '
                + prefix_path + ' ' 
                + standard_args + ' '
                + start_args + ' '
                + screen_args
            )
            print('START COMMAND : ' + start_cmd)

    # subprocess.Popen(start_cmd, shell=True)
    # os.system(start_cmd)
    retcode = subprocess.call(start_cmd)

def start_editor():
    file_dir = os.path.dirname(os.path.realpath(__file__))
    start_cmd = os.path.join(URHO_PATH_BIN, URHO_BIN_PLAYER)

    resource_paths = {
        'Data'      : 'Data',
        'CoreData'  : 'CoreData',
        'DataPacks' : 'DataPacks'
    }

    if sys.argv[2] is not None:
        urho_project = sys.argv[2].lower()

        if urho_project == 'ctrl-s':
            prefix_path = '-pp "' + URHO3D_PATH_PREFIX + '"'
            autoload_paths_arg = '-ap "' + URHO3D_PATH_PREFIX + '"'

            resource_paths_arg = '-p '
            for path in resource_paths:
                resource_paths_arg += path + ';'

            standard_args = '-w -s -deferred'

            script_arg = os.path.join('Scripts', 'Editor.as')
            start_cmd += (' '
                + script_arg + ' '
                + resource_paths_arg + ' ' 
                + autoload_paths_arg + ' '
                + prefix_path + ' ' 
                + standard_args
            )
            print('START COMMAND : ' + start_cmd)

    retcode = subprocess.call(start_cmd)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        start_arg = sys.argv[1][1:len(sys.argv[1])]
        start_cmd = None

        if start_arg == 'game':
            start_cmd = start_game
        elif start_arg == 'editor':
            start_cmd = start_editor

        if start_cmd is None:
            sys.exit('No Valid command argument passed.')
            
        start_cmd()

    else:
        sys.exit('No start command given.')
    


