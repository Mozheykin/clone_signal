from sql import Transaction

def format_message(id:int, message: str) -> Transaction | None:
    try:
        if message.startswith('BUY') or message.startswith('SELL'):
            lines = message.split('\n')
            Order, Where, Emmet, CMP = lines[0].split(' ', 3)
            CMP = CMP.split()[2][:-1]
            TP = lines[1].split()[1]
            SL = lines[2].split()[1]
            Risk = lines[3].split()[1][:-1]
            return Transaction(id_=id, Order=Order, Where=Where, Emmet=Emmet, CMP=float(CMP), TP=float(TP), SL=float(SL), Risk=float(Risk))
        elif message.startswith('Update'):
            lines = message.split('\n')
            Order, Emmet, CMP = lines[0].split(' ', 2)
            CMP = CMP.split()[2][:-1]
            TP = lines[1].split()[1]
            SL = lines[2].split()[1]
            Change_line = lines[3].split()
            return Transaction(id_=id, Order=Order, Where=f'{Change_line[1]} {Change_line[-1]}', Emmet=Emmet, CMP=float(CMP), TP=float(TP), SL=float(SL), Risk=float(0))
        elif message.startswith('Close'):
            Order, Where, Other = message.split(' ', 2)
            return Transaction(id_=id, Order=Order, Where=Where, Emmet='', CMP=float(0), TP=float(0), SL=float(0), Risk=float(0))
    except Exception:
        return None


if __name__ == '__main__':
    print(format_message(id=2, message='BUY NOW NAS100 (CMP : 12140)\nTP: 12500\nSL: 11800\nRisk: 2%'))
    print(format_message(id=2, message='SELL NOW NAS100 (CMP : 12140)\nTP: 12500\nSL: 11800\nRisk: 2%'))
    print(format_message(id=5, message='Update SPX500 (CMP : 12140)\nTP: 12500\nSL: 11800\nADJUST SL TO 3848'))
    print(format_message(id=6, message='Close NOW (CMP : 12140)\nResult pips: -300'))
    print(format_message(id=6, message='Close NOW (CMP : 12140)'))