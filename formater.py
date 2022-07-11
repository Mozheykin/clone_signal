from sql import Transaction

def format_message(id:int, message: str) -> Transaction | None:
    try:
        TP1, TP2, TP3, TP4 = 0, 0, 0, 0
        Order, Where, Emmet, CMP, SL, Risk, Change_line = '', '', '', 0, 0, 0, []
        if message.startswith('BUY') or message.startswith('SELL'):
            lines = message.split('\n')
            for line in lines:
                if line.startswith(('BUY', 'SELL')):
                    Order, Where, Emmet, CMP = line.split(' ', 3)
                    CMP = CMP.split()[2][:-1]
                elif line.startswith('TP:'):
                    TP1 = line.split()[1]
                elif line.startswith('TP1:'):
                    TP1 = line.split()[1]
                elif line.startswith('TP2:'):
                    TP2 = line.split()[1]
                elif line.startswith('TP3:'):
                    TP3 = line.split()[1]
                elif line.startswith('TP4:'):
                    TP4 = line.split()[1]
                elif line.startswith('SL:'):
                    SL = line.split()[1]
                elif line.startswith('Risk:'):
                    Risk = line.split()[1][:-1]
            return Transaction(id_=id, Order=Order, Where=Where, Emmet=Emmet, CMP=float(CMP), TP1=float(TP1), TP2=float(TP2), TP3=float(TP3), TP4=float(TP4), SL=float(SL), Risk=float(Risk), Update='')
        elif message.startswith('Update'):
            lines = message.split('\n')
            for line in lines:
                if line.startswith('Update'):
                    Order, Emmet, CMP = lines[0].split(' ', 2)
                    CMP = CMP.split()[2][:-1]
                elif line.startswith('TP:'):
                    TP1 = line.split()[1]
                elif line.startswith('TP1:'):
                    TP1 = line.split()[1]
                elif line.startswith('TP2:'):
                    TP2 = line.split()[1]
                elif line.startswith('TP3:'):
                    TP3 = line.split()[1]
                elif line.startswith('TP4:'):
                    TP4 = line.split()[1]
                elif line.startswith('SL:'):
                    SL = line.split()[1]
                elif line.startswith('ADJUST'):
                    Change_line = line.split()
            return Transaction(id_=id, Order=Order, Where=f'{Change_line[1]}', Emmet=Emmet, CMP=float(CMP), TP1=float(TP1), TP2=float(TP2), TP3=float(TP3), TP4=float(TP4), SL=float(SL), Risk=float(0), Update=Change_line[-1])
        elif message.startswith('Close'):
            Order, Where, Emmet, Other = message.split(' ', 3)
            CMP = Other.split()[2][:-1]
            return Transaction(id_=id, Order=Order, Where=Where, Emmet=Emmet, CMP=float(CMP), TP1=float(0), TP2=float(0), TP3=float(0), TP4=float(0), SL=float(0), Risk=float(0), Update='')
    except Exception:
        return None


if __name__ == '__main__':
    print(format_message(id=2, message='BUY NOW NAS100 (CMP : 12140)\nTP: 12500\nSL: 11800\nRisk: 2%'))
    print(format_message(id=2, message='BUY NOW NAS100 (CMP : 12140)\nTP1: 12501\nTP2: 12502\nTP3: 12503\nTP4: 12504\nSL: 11800\nRisk: 2%'))
    print(format_message(id=2, message='SELL NOW NAS100 (CMP : 12140)\nTP: 12500\nSL: 11800\nRisk: 2%'))
    print(format_message(id=5, message='Update SPX500 (CMP : 12140)\nTP: 12500\nSL: 11800\nADJUST SL TO 3848'))
    print(format_message(id=6, message='Close NOW NAS100 (CMP : 12140)\nResult pips: -300'))
    print(format_message(id=6, message='Close NOW NAS100 (CMP : 12140)'))