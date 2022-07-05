from pyrogram import Client, filters
import config
import uvloop

from typing import NamedTuple


class Transaction(NamedTuple):
    transaction: str
    open: float
    sl: float
    tp: float

# get API telegramm
# https://my.telegram.org/apps

uvloop.install()
app = Client('clone_signal', api_id=config.api_id, api_hash=config.api_hash)


@app.on_message(filters.chat(config.chanel))
async def get_message(client, message):
    print(message) ### Formater and send BD, Save file



if __name__ == '__main__':
    try:
        app.run()
        
    except KeyboardInterrupt:
        pass