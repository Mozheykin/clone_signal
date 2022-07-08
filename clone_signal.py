from pyrogram import filters
from pyrogram.client import Client
import config
import uvloop
import formater
import sql
from save_signal import SaveCSVfile





# get API telegramm
# https://my.telegram.org/apps

uvloop.install()
app = Client('clone_signal', api_id=config.api_id, api_hash=config.api_hash)


@app.on_message(filters.chat(config.chanel))
async def get_message(client, message):
    get_transaction = formater.format_message(id=message.id, message=message.text)
    db = sql.SQL('db.sqlite')
    if get_transaction:
        if db.find(get_=get_transaction) is None:
            db.add(get_=get_transaction)
            MT_file = SaveCSVfile('Signal.csv')
            MT_file.save(get_transaction)



if __name__ == '__main__':
    try:
        app.run()
        
    except KeyboardInterrupt:
        pass