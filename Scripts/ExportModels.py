import os
import sys
import subprocess

URHO_PATH = None
if os.environ.get('URHO_PATH') is not None:
    URHO_PATH = os.environ['URHO_PATH']
else:
    sys.exit('Could not locate urho3d root path env variable.')

def test_export_model():
    # D:\urhoprojects\Urho3D-1.32.0-Windows-64bit-STATIC\share\Urho3D\Bin
    urho_bin_path = URHO_PATH + '\\share\\Urho3D\\Bin'
    urho_bin_cmd = '\\AssetImporter'
    source_path = '..\\datasource\\scratch\\characters\\test_char_01\\test_char_01.dae'
    target_path = '..\\data\\scratch\\characters\\test_char_01\\test_char_01.mdl'
    # result = subprocess.call(['start', urho_bin_path + urho_bin_cmd, 'dump', source_path, target_path], shell=True)
    # result = subprocess.Popen(['start', urho_bin_path + urho_bin_cmd, 'dump', source_path, target_path], shell=True).wait()
    os.system(urho_bin_path + urho_bin_cmd + ' model ' + source_path + ' ' +  target_path)

if __name__ == '__main__':
    test_export_model()

