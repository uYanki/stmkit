import xml.dom.minidom
from xml.dom.minidom import parse
import os
import xml
import xml.etree.ElementTree as ET

target_paths = [".\\examples", ".\\targets"]
platform_path = ".\\platform"

drvlibs = []

for target_path in os.scandir(platform_path):
    if target_path.is_dir():
        drvlibs.append(target_path.name)


# for target_path in target_paths:
#     for dir_path, dir_names, file_names in os.walk(target_path):
#         for file_name in file_names:
#             if file_name.endswith(".uvprojx"):
#                 file_path = os.path.join(dir_path, file_name)
#                 print(file_path)


xml_path = r'.\targets\servo\emb\_at32f413c\project\mdk_v5\demo.uvprojx'
tree = ET.ElementTree(file=xml_path)


def retarget_relpath(res_filepath, proj_dirpath):

    rel_path = ""

    for times in range(5):

        file_path = os.path.join(proj_dirpath, rel_path + res_filepath)
        file_path = os.path.normpath(file_path)

        if file_path.startswith("platform"):
            dst_path = os.path.relpath(file_path, start=proj_dirpath)
            # print(times, dst_path)
            return dst_path
        else:
            rel_path += "../"

    return None


pair = []

for elem in tree.iter(tag='IncludePath'):
    if elem.text != None:
        newpaths = []
        for path in elem.text.split(";"):
            if path == None:
                continue
            found = False
            for drvlib in drvlibs:
                if drvlib in path:
                    newpath = retarget_relpath(path, os.path.dirname(xml_path))
                    if newpath != None:
                        newpaths.append(newpath)
                        found = True
                    break
            if found == False:
                newpaths.append(path)
        elem.text = ';'.join(newpaths)

for elem in tree.iter(tag='FilePath'):
    if elem.text != None:
        res_filepath = elem.text
        for drvlib in drvlibs:
            if drvlib in res_filepath:
                newpath = retarget_relpath(
                    res_filepath, os.path.dirname(xml_path))
                if newpath != None:
                    elem.text = newpath
                break

# <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
tree.write(xml_path)

with open(xml_path, 'r+') as f:
    ctx = f.readlines()
    f.seek(0)
    f.writelines(
        """<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n""")
    f.writelines(ctx)
