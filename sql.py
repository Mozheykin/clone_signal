import sqlite3
from clone_signal import Transaction

class SQL:
    def __init__(self, name_db: str) -> None:
        self.db = sqlite3.connect(name_db)
        self.cursor = self.db.cursor()
        self.cursor.execute("""CREATE TABLE IF NOT EXISTS main(
                                `id` INTEGER,
                                `transaction` TEXT,
                                `open` REAL,
                                `SL` REAL,
                                `TP` REAL)""")
        self.db.commit()
    
    def add(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('INSERT INTO main VALUES(?,?,?,?,?)', *get_)
    
    def update_sl(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('UPDATE main SET `SL`=? where `id`=?', (get_.SL, get_.id))
    
    def update_tp(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('UPDATE main SET `SL`=? where `id`=?', (get_.TP, get_.id))
    
    def find(self, get_: Transaction) -> sqlite3.Cursor | None:
        with self.db:
            return self.cursor.execute('SELECT * FROM main WHERE `id`=? ', (get_.id)).fetchone()
