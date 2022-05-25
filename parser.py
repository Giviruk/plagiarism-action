import seaborn as sns; sns.set_theme()
import matplotlib.pyplot as plt
import numpy


class File:
    def __init__(self, file_path):
        splitted = file_path.replace('./', '', 1).split('/')
        self.author = splitted[0]
        self.file_name = splitted[1]


class Authors_Key:
    def __init__(self, first_name, second_name):
        self.first_name = first_name
        self.second_name = second_name

    def __hash__(self):
        return hash((self.first_name, self.second_name))

    def __eq__(self, other):
        return (self.first_name, self.second_name) == (other.first_name, other.second_name)

    def __ne__(self, other):
        return not (self == other)

    def __str__(self):
        return f"({self.first_name}; {self.second_name})"


def parse_plagiarism_result(path):
    report_dict = {}

    with open(path, 'r') as result_file:
        lines = result_file.readlines()
        for line in lines:
            splited = line.replace('\n', '').split(';')
            first_file, second_file, percentage = File(splited[0]), File(splited[1]), splited[2]

            if first_file.author == second_file.author:
                continue

            names = [first_file.author, second_file.author]
            names.sort()
            key = Authors_Key(names[0], names[1])
            value = int(percentage.replace('%', '')) / 100

            if report_dict.get(key) is None:
                report_dict[key] = value
            else:
                if report_dict.get(key) < value:
                    report_dict[key] = value

    return report_dict


if __name__ == '__main__':
    report = parse_plagiarism_result("./outputs/result.txt")

    keys = set()
    matrix = [[]]

    for authors, percantage in report.items():
        keys.add(authors.first_name)
        keys.add(authors.second_name)

    list_keys = list(keys)
    list_keys.sort()

    if len(list_keys) != 0:
        matrix = numpy.ones(shape=(len(list_keys), len(list_keys)))

        for authors, percantage in report.items():
            first_index, second_index = list_keys.index(authors.first_name), list_keys.index(authors.second_name)
            matrix[first_index][second_index] = percantage
            matrix[second_index][first_index] = percantage

        heatmap = sns.heatmap(matrix,
                              annot=True,
                              vmin=0,
                              vmax=1,
                              xticklabels=list_keys,
                              yticklabels=list_keys,
                              cmap='coolwarm')

        figure = heatmap.get_figure()
        figure.savefig("./outputs/plot.png")
