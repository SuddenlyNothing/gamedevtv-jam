#!/usr/bin/env python3
import sys
import os
import tempfile
import shutil

EXTENSIONS = {
    "Mac OSX": "app",
    "Windows Desktop": "exe",
    "Linux X11": "x86_64",
}
    
def main():
    # Exports all projects in this executables filepath
    print("\n\nStart exporting")
    os.chdir(os.path.dirname(os.path.realpath(__file__)))
    if find_and_export(os.getcwd()):
        print("End exporting")
    else:
        print("No exports found\n\n")
        sys.exit()

    sys.exit()

def get_export_presets(file: str) -> dict:
    presets = {}
    with open(file, "r") as f:
        for line in f:
            if line.startswith("name="):
                platform = f.readline()[10:-2]
                presets[line[6:-2]] = platform
    return presets

def find_and_export(dir: str) -> bool:
    found_export = False

    # loop through files and find godot export_presets.cfg
    for filename in os.listdir(dir):
        if filename[0] == '.':
            continue
        if os.path.isdir(filename):
            if find_and_export(os.path.join(dir, filename)):
                found_export = True
        elif filename == "export_presets.cfg":
            print(f"\nUploading {dir}\n")
            found_export = True
            # loop through export presets and export projects into a unique directory
            for preset, platform in get_export_presets(os.path.join(dir, filename)).items():
                platform = platform.replace("/", " ")
                print("\n" + platform + " =====================================")
                temp_dir = tempfile.mkdtemp(dir=dir)
                export_dir = tempfile.mkdtemp(dir=temp_dir)

                export_command = f'godot --no-window --quiet --path "{dir}" --export "{preset}" "{{}}"'
                if platform == "HTML5":
                    export_command = export_command.format(os.path.join(export_dir, "index.html"))
                elif platform in EXTENSIONS:
                    export_command = export_command.format(os.path.join(export_dir, platform + "." + EXTENSIONS[platform]))
                else:
                    export_command = export_command.format(os.path.join(export_dir, platform))
                print("\n", export_command, "\n")

                # export project into temp file, zip, and upload
                if os.system(export_command) == 0:
                    # zip projects into tempfile
                    zip_file = os.path.join(temp_dir, platform) + '.zip'
                    # zip_file = platform + '.zip'
                    os.system(f'tar.exe caf "{zip_file}" -C "{export_dir}" *')
                
                    # upload projects to itch
                    upload_command = f'butler push "{zip_file}" nothing-d/dev:{{}}'
                    if platform == "HTML5":
                        upload_command = upload_command.format("html")
                    elif platform == "Windows Desktop":
                        upload_command = upload_command.format("windows")
                    elif platform == "Mac OSX":
                        upload_command = upload_command.format("mac")
                    elif platform == "Linux X11":
                        upload_command = upload_command.format("linux")
                    else:
                        upload_command = upload_command.format("misc")
                    print('\n', upload_command, '\n')
                    os.system(upload_command)
                    
                # delete exports
                shutil.rmtree(temp_dir)
    return found_export

if __name__ == "__main__":
    main()
