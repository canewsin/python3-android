def listDir(dirname):
    import glob
    return glob.glob(dirname + '/*/')


def check(dir):
    for name in listDir(dir):
        import os
        result = os.path.isdir(name)
        if result:
            k = name.rfind("\\")
            nameM = name[:k]
            if nameM.endswith("__pycache__") or nameM.endswith("test") or nameM.endswith("tests"):
                print(nameM)
                import shutil
                shutil.rmtree(name)
                pass
            else:
                check(name)
                pass
            pass
        pass


def main():
    import os
    check(os.path.dirname(os.path.realpath(__file__)))


if __name__ == '__main__':
    main()

