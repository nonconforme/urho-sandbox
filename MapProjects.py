import os
import sys
import subprocess

URHO_PATH_DATA = None
if os.environ.get('URHO_PATH_DATA') is not None:
    URHO_PATH_DATA = os.environ['URHO_PATH_DATA']
else:
    sys.exit('Could not locate urho3d URHO_PATH_DATA env variable.')

symlink_dirs = [
    # (os.path.join('Data', 'DataPacks'), 'DataPacks'),
    (os.path.join('Data', 'CoreData'), 'CoreData'),
    (os.path.join('Data', 'Data'), 'Data')
]

if __name__ == '__main__':
    if os.path.isdir(URHO_PATH_DATA) and os.path.exists(URHO_PATH_DATA):
        for item in symlink_dirs:
            if sys.platform == 'win32':
                # os.system(
                #     'mklink /J ' +
                #     (os.path.join(URHO_PATH_DATA, item[1])) + ' ' + (os.path.join('.', item[0]))
                # )

                link_cmd = (
                    'mklink /J ' 
                    + (os.path.join('.', item[0])) + ' ' 
                    + '"' + (os.path.join(URHO_PATH_DATA, item[1])) + '"'
                )

                print('Link Cmd :: ' + link_cmd)
                os.system(link_cmd)
            else:
                pass
