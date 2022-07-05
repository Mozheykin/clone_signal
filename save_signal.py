from pathlib import Path


class Saver:
    def __init__(self, name_file:str) -> None:
        self.name = name_file
    
    def save(self, data: str) -> None:
        raise NotImplemented

class SaveTextFile(Saver):
    def save(self, data: str) -> None:
        Path(self.name).write_text(data=data)