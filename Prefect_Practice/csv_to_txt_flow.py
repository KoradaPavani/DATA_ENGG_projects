from prefect import flow, task
import pandas as pd
import os

# Task: Convert one CSV to TXT
@task
def csv_to_txt(input_path, output_path):
    print(f"Reading: {input_path}")
    df = pd.read_csv(input_path)

    print(f"Writing: {output_path}")
    df.to_csv(output_path, index=False, sep="\t")  # tab separated txt

    print("Done!")

# Flow: Process all files
@flow
def convert_all_csvs():
    input_folder = "input"
    output_folder = "output"

    os.makedirs(output_folder, exist_ok=True)

    files = ["data1.csv", "data2.csv", "data3.csv"]

    for file in files:
        input_path = os.path.join(input_folder, file)
        output_file = file.replace(".csv", ".txt")
        output_path = os.path.join(output_folder, output_file)

        csv_to_txt(input_path, output_path)

if __name__ == "__main__":
    convert_all_csvs()
