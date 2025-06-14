#property strict
#property description "Simple Moving Average Cross Expert Advisor"

input int FastMAPeriod = 10;       // Fast MA period
input int SlowMAPeriod = 25;       // Slow MA period
input double LotSize     = 0.1;    // Trade lot size

int fast_ma_handle;
int slow_ma_handle;

int OnInit()
{
    fast_ma_handle = iMA(_Symbol, _Period, FastMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    slow_ma_handle = iMA(_Symbol, _Period, SlowMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    if(fast_ma_handle == INVALID_HANDLE || slow_ma_handle == INVALID_HANDLE)
        return(INIT_FAILED);
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
    if(fast_ma_handle != INVALID_HANDLE)
        IndicatorRelease(fast_ma_handle);
    if(slow_ma_handle != INVALID_HANDLE)
        IndicatorRelease(slow_ma_handle);
}

void OnTick()
{
    double fast_ma[2];
    double slow_ma[2];

    if(CopyBuffer(fast_ma_handle,0,0,2,fast_ma)<=0)
        return;
    if(CopyBuffer(slow_ma_handle,0,0,2,slow_ma)<=0)
        return;

    double fast_prev = fast_ma[1];
    double slow_prev = slow_ma[1];
    double fast_curr = fast_ma[0];
    double slow_curr = slow_ma[0];

    if(!PositionSelect(_Symbol))
    {
        if(fast_prev < slow_prev && fast_curr > slow_curr)
            TradePosition(ORDER_TYPE_BUY);
        else if(fast_prev > slow_prev && fast_curr < slow_curr)
            TradePosition(ORDER_TYPE_SELL);
    }
}

void TradePosition(const ENUM_ORDER_TYPE type)
{
    MqlTradeRequest request;
    MqlTradeResult  result;
    ZeroMemory(request);
    ZeroMemory(result);

    request.action      = TRADE_ACTION_DEAL;
    request.symbol      = _Symbol;
    request.volume      = LotSize;
    request.type        = type;
    request.price       = (type==ORDER_TYPE_BUY) ? SymbolInfoDouble(_Symbol,SYMBOL_ASK)
                                                : SymbolInfoDouble(_Symbol,SYMBOL_BID);
    request.deviation   = 10;
    request.magic       = 123456;
    request.type_filling= ORDER_FILLING_FOK;

    OrderSend(request, result);
}
