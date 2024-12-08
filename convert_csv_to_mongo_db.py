import pandas as pd
from pathlib import Path
import csv
import json
import sys
import ast

def read_csv_to_json (csv_file):
    with open(csv_file, mode='r', encoding='utf-8') as f:
        columns = f.readline()
        columns = columns.split(", ")
        reader = csv.DictReader(f)
        data = [row for row in reader]

        # Evaluate the json columns, which are quoted, to convert them into a dictionary or list of dictionaries
        # print(type(data[0]), data[0])
        for row in data:
            for col in columns:
                try:
                    # evaluate row[col] as dict or list of dicts
                    row[col] = ast.literal_eval(row[col])
                    # print(f"SETTING {col} TO {row[col]}")
                except Exception as e:
                    pass  # ignore - not a good practice, in general   
        
    return data

def write_json(data, name):
    json_file = Path(name).with_suffix('.json')
    with open(json_file, mode='w') as f:
        json.dump(data, f)

if __name__ == "__main__":
    csv_file = sys.argv[1]
    child_files = sys.argv[2:]

    main_data = read_csv_to_json(csv_file)

    for fichero in child_files:
        main_data[fichero] = read_csv_to_json(fichero)

    #simply writes the data filename with a json format and extension       
    write_json(main_data, csv_file)


