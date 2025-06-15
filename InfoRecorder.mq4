#property script_show_inputs

input int MaxRecords = 100;      // kolik záznamu udrzovat
input int DisplayRecords = 10;   // kolik radku zobrazit na chartu
string FileName = "information.txt";
string FilePath;

string panel = "InfoPanel";
string listObj = panel + "_List";
string btnObj  = panel + "_Close";

string records[];

//+------------------------------------------------------------------+
//| OnStart                                                          |
//+------------------------------------------------------------------+
void OnStart()
{
   FilePath = TerminalInfoString(TERMINAL_COMMONDATA_PATH) + "\\" + FileName;
   CreateForm();
   InitializeFile();
   RefreshList();
   EventSetTimer(1);
}

//+------------------------------------------------------------------+
//| OnTimer                                                          |
//+------------------------------------------------------------------+
void OnTimer()
{
   static datetime lastClose = 0;
   datetime t0 = iTime(_Symbol, PERIOD_M1, 0);
   if(t0 != lastClose)
   {
      if(lastClose > 0)
      {
         int idx = iBarShift(_Symbol, PERIOD_M1, lastClose);
         double h = iHigh  (_Symbol, PERIOD_M1, idx);
         double l = iLow   (_Symbol, PERIOD_M1, idx);
         long   v = iVolume(_Symbol, PERIOD_M1, idx);
         AddRecord(h, l, v);
         RefreshList();
      }
      lastClose = t0;
   }
}

//+------------------------------------------------------------------+
//| OnChartEvent                                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == btnObj)
   {
      ObjectDelete(0, panel);
      EventKillTimer();
      ExpertRemove();
   }
}

//+------------------------------------------------------------------+
//| CreateForm                                                       |
//+------------------------------------------------------------------+
void CreateForm()
{
   ObjectCreate(0, panel, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, panel, OBJPROP_XDISTANCE, 20);
   ObjectSetInteger(0, panel, OBJPROP_YDISTANCE, 20);
   ObjectSetInteger(0, panel, OBJPROP_WIDTH,     260);
   ObjectSetInteger(0, panel, OBJPROP_HEIGHT,    200);
   ObjectSetInteger(0, panel, OBJPROP_COLOR,     clrWhite);
   ObjectSetInteger(0, panel, OBJPROP_BACK,      true);
   ObjectSetInteger(0, panel, OBJPROP_ALPHA,     64);

   string lbl = panel + "_Label";
   ObjectCreate(0, lbl, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, lbl, OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, lbl, OBJPROP_YDISTANCE, 20);
   ObjectSetString (0, lbl, OBJPROP_TEXT, "Poslednich " + IntegerToString(DisplayRecords) + " zaznamu (High Low Volume):");
   ObjectSetInteger(0, lbl, OBJPROP_FONTSIZE, 10);

   ObjectCreate(0, listObj, OBJ_LIST, 0, 0, 0);
   ObjectSetInteger(0, listObj, OBJPROP_XDISTANCE, 30);
   ObjectSetInteger(0, listObj, OBJPROP_YDISTANCE, 40);
   ObjectSetInteger(0, listObj, OBJPROP_WIDTH,     220);
   ObjectSetInteger(0, listObj, OBJPROP_HEIGHT,    120);

   ObjectCreate(0, btnObj, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, btnObj, OBJPROP_XDISTANCE, 100);
   ObjectSetInteger(0, btnObj, OBJPROP_YDISTANCE, 170);
   ObjectSetInteger(0, btnObj, OBJPROP_WIDTH,     60);
   ObjectSetInteger(0, btnObj, OBJPROP_HEIGHT,    20);
   ObjectSetString (0, btnObj, OBJPROP_TEXT, "Zavrit");
}

//+------------------------------------------------------------------+
//| InitializeFile                                                   |
//+------------------------------------------------------------------+
void InitializeFile()
{
   if(FileIsExist(FilePath))
   {
      ReadAllLines();
      return;
   }

   ArrayResize(records, MaxRecords);
   for(int i = MaxRecords - 1; i >= 0; i--)
   {
      double hh = iHigh  (_Symbol, PERIOD_M1, i);
      double ll = iLow   (_Symbol, PERIOD_M1, i);
      long   vv = iVolume(_Symbol, PERIOD_M1, i);
      records[MaxRecords - 1 - i] = DoubleToString(hh, _Digits) + " " +
                                   DoubleToString(ll, _Digits) + " " +
                                   LongToString(vv);
   }
   WriteAllLines();
}

//+------------------------------------------------------------------+
//| AddRecord                                                        |
//+------------------------------------------------------------------+
void AddRecord(double high_, double low_, long vol_)
{
   string line = DoubleToString(high_, _Digits) + " " +
                 DoubleToString(low_,  _Digits) + " " +
                 LongToString(vol_);
   int cnt = ArraySize(records);
   if(cnt >= MaxRecords)
   {
      for(int i = 1; i < cnt; i++)
         records[i-1] = records[i];
      records[cnt-1] = line;
   }
   else
   {
      ArrayResize(records, cnt + 1);
      records[cnt] = line;
   }
   WriteAllLines();
}

//+------------------------------------------------------------------+
//| ReadAllLines                                                     |
//+------------------------------------------------------------------+
void ReadAllLines()
{
   ArrayResize(records, 0);
   int handle = FileOpen(FilePath, FILE_READ | FILE_TXT);
   if(handle == INVALID_HANDLE)
   {
      Print("FileOpen read error: ", GetLastError());
      return;
   }
   while(!FileIsEnding(handle))
   {
      string line = FileReadString(handle);
      ArrayResize(records, ArraySize(records) + 1);
      records[ArraySize(records) - 1] = line;
   }
   FileClose(handle);
}

//+------------------------------------------------------------------+
//| WriteAllLines                                                    |
//+------------------------------------------------------------------+
void WriteAllLines()
{
   int handle = FileOpen(FilePath, FILE_WRITE | FILE_TXT);
   if(handle == INVALID_HANDLE)
   {
      Print("FileOpen write error: ", GetLastError());
      return;
   }
   for(int i = 0; i < ArraySize(records); i++)
      FileWrite(handle, records[i]);
   FileClose(handle);
}

//+------------------------------------------------------------------+
//| RefreshList                                                      |
//+------------------------------------------------------------------+
void RefreshList()
{
   int total = ArraySize(records);
   int start = MathMax(0, total - DisplayRecords);
   for(int i = 0; i < DisplayRecords; i++)
   {
      string line = (start + i < total) ? records[start + i] : "";
      ObjectSetString(0, listObj, OBJPROP_LIST, line, i);
   }
}

