import sqlite3
from typing import NamedTuple


class Transaction(NamedTuple):
    id_: int
    Order: str
    Where:str
    Emmet:str
    CMP:float
    SL: float
    TP: float
    Risk: float


class SQL:
    def __init__(self, name_db: str) -> None:
        self.db = sqlite3.connect(name_db)
        self.cursor = self.db.cursor()
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS main(
                                `id` INTEGER,
                                `Order` TEXT,
                                `Where` TEXT,
                                `Emmet` TEXT,
                                `CMP` REAL,
                                `SL` REAL,
                                `TP` REAL,
                                `Risk` REAL)""")
                                
        self.db.commit()
    
    def add(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('INSERT INTO main VALUES(?,?,?,?,?,?,?,?)', (*get_,))
    
    def update_sl(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('UPDATE main SET `SL`=? where `id`=?', (get_.SL, get_.id_))
    
    def update_tp(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('UPDATE main SET `SL`=? where `id`=?', (get_.TP, get_.id_))
    
    def find(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('SELECT * FROM main WHERE `id`=? ', (get_.id_,)).fetchone()
