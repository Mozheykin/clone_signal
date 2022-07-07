//+------------------------------------------------------------------+
//|                                                 clone_signal.mq4 |
//|                                                   Mozheykin Igor |
//|           https://www.upwork.com/freelancers/~01dd7daccf19642309 |
//+------------------------------------------------------------------+
#property copyright "Mozheykin Igor"
#property link      "https://www.upwork.com/freelancers/~01dd7daccf19642309"
#property version   "1.00"
#property strict
extern int timer_time = 1;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   EventSetTimer(timer_time);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   Comment("");
   string filename=TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Experts\\Signal";
   int Signal = FileOpen(filename, FILE_READ);
   string message;
   if(Signal!=INVALID_HANDLE)
     {
      int str_size;
      string str;
      
      while(!FileIsEnding(Signal))
        {
         str_size=FileReadInteger(Signal,INT_VALUE);
         str=FileReadString(Signal,str_size);
         message = message + "\n " + str;
        }
      Comment(message);      
     }
   FileClose(Signal);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {


  }
//+------------------------------------------------------------------+
