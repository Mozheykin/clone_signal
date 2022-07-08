from pathlib import Path
from sql import Transaction
import csv


class Saver:
    def __init__(self, name_file:str) -> None:
        self.name = name_file
    
    def save(self, data: str) -> None:
        raise NotImplemented

class SaveTextFile(Saver):
    def save(self, data: Transaction) -> None:
        with open(self.name, 'w') as file:
            for line in [*data]:
                file.write(f'{line}\n')
        # Path(self.name).write_text(data=data)



class SaveCSVfile(Saver):
    def save(self, data: Transaction) -> None:
        with open(self.name, 'w', newline='') as file:
            csv_writer = csv.writer(file, delimiter=';', quotechar='|', quoting=csv.QUOTE_MINIMAL)
            csv_writer.writerow([*data])
            print(f'Save file {data}')