from sql import Transaction

def format_message(id:int, message: str) -> Transaction | None:
    try:
        print(id, message)
        lines = message.split('\n')
        Order, Where, Emmet, CMP = lines[0].split(' ', 3)
        CMP = CMP.split()[2][:-1]
        TP = lines[1].split()[1]
        SL = lines[2].split()[1]
        Risk = lines[3].split()[1][:-1]
        return Transaction(id_=id, Order=Order, Where=Where, Emmet=Emmet, CMP=float(CMP), TP=float(TP), SL=float(SL), Risk=float(Risk))
    except Exception:
        return None


if __name__ == '__main__':
    print(format_message(id=2, message='BUY NOW NAS100 (CMP : 12140)\nTP: 12500\nSL: 11800\nRisk: 2%'))