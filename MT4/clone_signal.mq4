//+------------------------------------------------------------------+
//|                                                 clone_signal.mq4 |
//|                                                   Mozheykin Igor |
//|           https://www.upwork.com/freelancers/~01dd7daccf19642309 |
//+------------------------------------------------------------------+
#property copyright "Mozheykin Igor"
#property link      "https://www.upwork.com/freelancers/~01dd7daccf19642309"
#property version   "1.00"
#property strict

//Options
//extern int timer_time = 1;
extern int magik_number = 6232; // Magik number
extern double MinLot=0.001; // Minimal Lot
extern bool Alert_use = False; // Use Allert

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

//EventSetTimer(5);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//EventKillTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   string filename="Signal.csv";
   int Signal = FileOpen(filename, FILE_READ | FILE_CSV);
   int id;
   string Order;
   string Where;
   string Emmet;
   double CMP;
   double SL;
   double TP;
   double Risk;
   string Update;

   if(Signal!=INVALID_HANDLE)
     {

      id = int(FileReadString(Signal));
      Order =FileReadString(Signal);
      Where = FileReadString(Signal);
      Emmet = FileReadString(Signal);
      CMP = FileReadString(Signal);
      SL = double(FileReadString(Signal));
      TP = double(FileReadString(Signal));
      Risk = double(FileReadString(Signal));
      Update = double(FileReadString(Signal));

      FileClose(Signal);
     }

   if(Order == "BUY" && Where == "NOW")
     {
      double Lot=((Risk*AccountBalance())/100)/((Ask - SL)/Point);
      if(Lot < MinLot)
         Lot = MinLot;
      int ticket=OrderSend(Emmet,OP_BUY, Lot, Ask, 3, SL, TP, CMP, magik_number,0,clrBlue);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else
        {
         if(Alert_use)
            Alert("Open oreder ", Emmet, " Buy Lot = ", Lot, " Price = ", Ask, " CMP = ", CMP);
        }
     }

   if(Order == "SELL" && Where == "NOW")
     {
      double Lot=((Risk*AccountBalance())/100)/((SL - Bid)/Point);
      if(Lot < MinLot)
         Lot = MinLot;
      int ticket=OrderSend(Emmet,OP_SELL, Lot, Bid, 3, SL, TP,CMP, magik_number,0,clrRed);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else
        {
         if(Alert_use)
            Alert("Open oreder ", Emmet, " Sell Lot = ", Lot, " Price = ", Ask, " CMP = ", CMP);
        }
     }

   if(Order == "Close" && Where == "NOW")
     {
      for(int pos = 0; pos < OrdersTotal(); pos++)
         if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES) == True)
            if(OrderMagicNumber() == magik_number && OrderSymbol() == Emmet && OrderComment() == CMP)
              {
               if(OrderType() == OP_BUY)
                  OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrBlue);
               if(OrderType() == OP_SELL)
                  OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrRed);
              }
     }

   if(Order == "Update")
     {
      for(int pos=0; pos <= OrdersTotal(); pos++)
         if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES) == True)
            if(OrderMagicNumber() == magik_number && OrderSymbol() == Emmet && OrderComment() == CMP)
              {
               if(Where == "SL")
                  OrderModify(OrderTicket(), OrderOpenPrice(), Update, OrderTakeProfit(), 0, clrYellow);
               if(Where == "TP")
                  OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), Update, 0, clrYellow);
              }
     }


   FileDelete(filename);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {


  }
//+------------------------------------------------------------------+
