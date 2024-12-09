from pathlib import Path
import csv
import json
import sys
import ast

def read_csv_to_json (csv_file: str, columns:dict):
    """reads the csv file with the documents to be embbebed

    Args:
        csv_file (str): main csv file
        columns (dict): dictionary with the name of the files of keys and (primary_key_field_name, foreing_key_field_name, json_name)

    Returns:
        dict: dict with all the data from the database
    """
    print("reading main csv")

    out = list()

    with open(csv_file, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        data = [row for row in reader]

        print("finished reading csv")

        for fichero in columns.keys():
            print(f"starting reading {fichero}")
            with open(fichero, mode='r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                col_data = [row for row in reader]

            index = {item[columns[fichero][1]]: item for item in col_data}

            print(f"finished reading {fichero} \nImbibing the file to the field")

            for row in data:
                #we have to take the relation betwen the foreing key and the primary key to insert the document
                primary_key = columns[fichero][0]
                atribute_name = columns[fichero][2]
                row[atribute_name] = index.get(row[primary_key])
                del row[primary_key]
                out.append(row)

    return out

def write_json(data, name):
    print(f"writing file to {name}.json")
    json_file = Path(name).with_suffix('.json')
    with open(json_file, mode='w') as f:
        json.dump(data, f)
    print("finished to write file")

if __name__ == "__main__":
    csv_file = sys.argv[1]
    child_files = sys.argv[2:]

    child_dict = dict()
    while len(child_files) >= 4:
        head = child_files[:4]
        child_dict[head[0]] = (head[1], head[2], head[3])
        child_files = child_files[4:]

    main_data = read_csv_to_json(csv_file, child_dict)

    #simply writes the data filename with a json format and extension       
    write_json(main_data, csv_file)
