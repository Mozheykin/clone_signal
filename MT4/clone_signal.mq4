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
extern bool rediscovery = False; // Reopen orders

string tickets[1000];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   int history = FileOpen("HISTORY.csv", FILE_READ | FILE_CSV);
   if(history != INVALID_HANDLE)
     {
      int item = 0;
      while(FileIsEnding(history)==false)
        {
         if(item <= 1000)
            tickets[item] = int(FileReadString(history));
         item ++;
        }
      FileClose(history);
     }
//EventSetTimer(5);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   int history = FileOpen("HISTORY.csv", FILE_WRITE | FILE_CSV);
   if(history != INVALID_HANDLE)
     {
      for(int i; i< ArraySize(tickets); i++)
         FileWrite(history, tickets[i]);
      FileClose(history);
     }
//EventKillTimer();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_ticket(string ticket_history)
  {
   bool result;
   for(int i=0; i<1000; i++)
      if(tickets[i] == ticket_history)
         return(true);

   return (false);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool check_open_order(string comment)
  {
   for(int i=0; i<= OrdersTotal(); i++)
      if(OrderSelect(i, SELECT_BY_TICKET, MODE_TRADES))
         if(OrderComment() == comment)
            return(true);

   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Reopen()
  {

   if(rediscovery == True)
      for(int order=0; order <= OrdersHistoryTotal(); order++)
        {
         if(OrderSelect(order,SELECT_BY_POS,MODE_HISTORY)==false) continue; else
           {
            string str = OrderComment();
            string comment = StringReplace(str,"[sl]","");
            double open = NormalizeDouble(OrderOpenPrice(), Digits);
            double sl = NormalizeDouble(OrderStopLoss(), Digits);
            double tp = NormalizeDouble(OrderTakeProfit(), Digits);
            string symbol = OrderSymbol();
            double lot = OrderLots();
            //Comment(check_ticket(comment), check_open_order(comment));
            
            if((OrderMagicNumber() == magik_number) && (check_ticket(comment) == False) && (check_open_order(comment) == False))
              {
               //Comment(OrderType());
               if(OrderType() == OP_BUY)
                 {
                 Comment(open);
                  int ticket = OrderSend(symbol, OP_BUYSTOP, lot, open, 3, sl, tp, comment, magik_number, 0, clrBlue);
                  //OrderModify(ticket, OrderOpenPrice(), OrderStopLoss(), OrderTakeProfit(), 0, clrBlue);
                  if(ticket<0)
                    {
                     Print("OrderSend error #",GetLastError());
                    }
                  else
                    {
                     if(Alert_use)
                        Alert("Open oreder ", OrderSymbol(), " Buy Lot = ", OrderLots(), " Price = ", OrderOpenPrice(), " CMP = ", OrderComment());
                    }
                 }
               if(OrderType() == OP_SELL)
                 {
                  int ticket = OrderSend(symbol, OP_SELLSTOP, lot, open, 3, sl, tp, comment, magik_number, 0, clrRed);
                  
                  if(ticket<0)
                    {
                     Print("OrderSend error #",GetLastError());
                    }
                  else
                    {
                     if(Alert_use)
                        Alert("Open oreder ", OrderSymbol(), " Sell Lot = ", OrderLots(), " Price = ", OrderOpenPrice(), " CMP = ", OrderComment());
                    }
                 }
              }
           }
        }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   Reopen();
   string filename="Signal.csv";
   int Signal = FileOpen(filename, FILE_READ | FILE_CSV);
   int id;
   string Order;
   string Where;
   string Emmet;
   double CMP;
   double SL;
   double TP1, TP2, TP3, TP4;
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
      TP1 = double(FileReadString(Signal));
      TP2 = double(FileReadString(Signal));
      TP3 = double(FileReadString(Signal));
      TP4 = double(FileReadString(Signal));
      Risk = double(FileReadString(Signal));
      Update = double(FileReadString(Signal));

      FileClose(Signal);
     }

   if(Order == "BUY" && Where == "NOW")
     {
      double Lot=((Risk*AccountBalance())/100)/((Ask - SL)/Point);
      if(Lot < MinLot)
         Lot = MinLot;
      int ticket=OrderSend(Emmet,OP_BUY, Lot, Ask, 3, SL, TP1, CMP, magik_number,0,clrBlue);
      double distance_SL = NormalizeDouble(Ask - SL, Digits);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else
        {
         if(Alert_use)
            Alert("Open oreder ", Emmet, " Buy Lot = ", Lot, " Price = ", Ask, " CMP = ", CMP);
        }
      if(TP2 != 0)
         int ticket=OrderSend(Emmet,OP_BUYSTOP, Lot, TP1, 3, TP1 -distance_SL, TP2, CMP, magik_number,0,clrBlue);
      if(TP3 != 0)
         int ticket=OrderSend(Emmet,OP_BUYSTOP, Lot, TP2, 3, TP2 -distance_SL, TP3, CMP, magik_number,0,clrBlue);
      if(TP4 != 0)
         int ticket=OrderSend(Emmet,OP_BUYSTOP, Lot, TP3, 3, TP3 -distance_SL, TP4, CMP, magik_number,0,clrBlue);
     }

   if(Order == "SELL" && Where == "NOW")
     {
      double Lot=((Risk*AccountBalance())/100)/((SL - Bid)/Point);
      if(Lot < MinLot)
         Lot = MinLot;
      int ticket=OrderSend(Emmet,OP_SELL, Lot, Bid, 3, SL, TP1,CMP, magik_number,0,clrRed);
      double distance_SL = NormalizeDouble(SL - Bid, Digits);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else
        {
         if(Alert_use)
            Alert("Open oreder ", Emmet, " Sell Lot = ", Lot, " Price = ", Ask, " CMP = ", CMP);
        }
      if(TP2 != 0)
         int ticket=OrderSend(Emmet,OP_SELLSTOP, Lot, TP1, 3, distance_SL - TP1, TP2, CMP, magik_number,0,clrRed);
      if(TP3 != 0)
         int ticket=OrderSend(Emmet,OP_SELLSTOP, Lot, TP2, 3, distance_SL - TP2, TP3, CMP, magik_number,0,clrRed);
      if(TP4 != 0)
         int ticket=OrderSend(Emmet,OP_SELLSTOP, Lot, TP3, 3, distance_SL - TP3, TP4, CMP, magik_number,0,clrRed);
     }

   if(Order == "Close" && Where == "NOW")
     {
      for(int pos = 0; pos < OrdersTotal(); pos++)
         if(OrderSelect(pos,SELECT_BY_POS, MODE_TRADES) == True)
            if(OrderMagicNumber() == magik_number && OrderSymbol() == Emmet && OrderComment() == CMP)
              {
               if(OrderType() == OP_BUY)
                 {
                  for(int i; i<1000; i++)
                     if(tickets[i] == EMPTY_VALUE)
                       {
                        tickets[i] = OrderComment();
                        break;
                       }
                  OrderClose(OrderTicket(), OrderLots(), Bid, 3, clrBlue);
                 }
               if(OrderType() == OP_SELL)
                 {
                  for(int i; i<1000; i++)
                     if(tickets[i] == EMPTY_VALUE)
                       {
                        tickets[i] = OrderComment();
                        break;
                       }
                  OrderClose(OrderTicket(), OrderLots(), Ask, 3, clrRed);
                 }
               if(OrderType() == (OP_BUYSTOP || OP_SELLSTOP))
                  OrderDelete(OrderTicket(), clrYellow);

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
