def read_file(file_name):
    with open(file_name) as fp:
        return [line.rstrip() for line in fp]
