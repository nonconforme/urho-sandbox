import os
import sys
import subprocess
import pdb

URHO_BIN_PLAYER = None
if os.environ.get('URHO_DEBUG') is not None and os.environ['URHO_DEBUG'] == 'true':
    URHO_BIN_PLAYER = 'Urho3DPlayer_d'
else:
    URHO_BIN_PLAYER = 'Urho3DPlayer'

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

def start(mode):
    if mode == 'game':
        script_arg    = ['StartGame.as']
        # script_arg    = ['StartGame.lua']
        # standard_args = ['-w', '-deferred', '-log', 'debug']
        # standard_args = ['-w', '-deferred']
        standard_args = ['-w']
        start_args    = ['-startpackuuid', 'bf345580-b572-11e4-92ca-089e01d3de8a_Ctrls']
        screen_args   = ['-x', '864', '-y', '486', '-borderless']
    else:
        script_arg    = ['StartEditor.as']
        # script_arg    = [os.path.join('Scripts', 'Editor.as')]
        # standard_args = ['-w', '-s', '-deferred']
        standard_args = ['-w', '-s']
        start_args    = []
        screen_args   = []

    file_dir = os.path.dirname(os.path.realpath(__file__))
    start_cmd = [URHO_BIN_PLAYER]

    resource_paths = {
        'Data'      : 'Data',
        'CoreData'  : 'CoreData',
        'DataPacks' : 'DataPacks'
    }

    # set project resource paths
    if sys.argv[2] is not None:
        urho_project = sys.argv[2].lower()

        if urho_project == 'ctrl-s':
            prefix_path        = ['-pp', './Data']
            autoload_paths_arg = ['-ap', './Data']

            resource_paths_arg = ['-p']
            resPathResult = ''
            for key, value in resource_paths.items():
                resPathResult += value + ';'
            resource_paths_arg.append(resPathResult)

            start_cmd += script_arg
            start_cmd += prefix_path
            start_cmd += autoload_paths_arg
            start_cmd += resource_paths_arg
            start_cmd += standard_args
            start_cmd += start_args
            start_cmd += screen_args

            print('START COMMAND : ')
            print(start_cmd)

    retcode = subprocess.call(start_cmd)

def start_game():
    start('game')

def start_editor():
    start('editor')

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
    


