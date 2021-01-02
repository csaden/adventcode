def read_file(file_name):
    with open(file_name) as fp:
        lines = fp.readlines()
        return lines
