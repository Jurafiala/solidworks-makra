#property strict
#property description "Trades predefined round levels using limit or stop orders"

input string LevelList = "1.1000,1.2000"; // comma-separated levels
input double LotSize = 0.1;               // trade volume
input int    Deviation = 10;              // slippage in points
input ulong  Magic = 987654;              // magic number for orders

double Levels[];
int    LevelCount;

int OnInit()
{
    LevelCount = StringSplit(LevelList, ',', Levels);
    return (LevelCount > 0) ? INIT_SUCCEEDED : INIT_PARAMETERS_INCORRECT;
}

bool HasPendingAtLevel(double level)
{
    for(int i=0;i<OrdersTotal();++i)
    {
        if(OrderGetTicket(i) &&
           OrderGetInteger(ORDER_TYPE) != ORDER_TYPE_BUY &&
           OrderGetInteger(ORDER_TYPE) != ORDER_TYPE_SELL)
        {
            if(OrderGetString(ORDER_SYMBOL)==_Symbol &&
               OrderGetInteger(ORDER_MAGIC)==(long)Magic &&
               MathAbs(OrderGetDouble(ORDER_PRICE_OPEN)-level) <= _Point)
                return true;
        }
    }
    return false;
}

void PlacePending(double level)
{
    if(HasPendingAtLevel(level))
        return;

    MqlTradeRequest request;
    MqlTradeResult  result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action      = TRADE_ACTION_PENDING;
    request.symbol      = _Symbol;
    request.volume      = LotSize;
    request.price       = level;
    request.deviation   = Deviation;
    request.magic       = Magic;
    request.type_time   = ORDER_TIME_GTC;
    request.type_filling= ORDER_FILLING_FOK;
    request.comment     = "Level "+DoubleToString(level, _Digits);

    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    if(ask > level)
        request.type = ORDER_TYPE_BUY_LIMIT;
    else
        request.type = ORDER_TYPE_BUY_STOP;

    OrderSend(request, result);
}

void OnTick()
{
    for(int i=0;i<LevelCount;++i)
        PlacePending(Levels[i]);
}
