//+------------------------------------------------------------------+
//|                     Scalping EA - Vol 80 Synthetic                |
//|                      Optimized for M1/M5                          |
//|                    Professional Trading System                    |
//+------------------------------------------------------------------+
#property copyright "Scalping EA"
#property link      "https://github.com/reborn1413-cell"
#property version   "1.0"
#property strict
#property description "High-frequency scalping EA for Volume 80 Synthetic"

#include <Trade\Trade.mqh>

CTrade trade;

//--- Input Parameters
input double RiskPercent = 1.0;           // Risk per trade (%)
input int TakeProfitPips = 10;            // Take Profit (pips)
input int StopLossPips = 5;               // Stop Loss (pips)
input int MaxOpenPositions = 3;           // Max simultaneous positions
input int FastMA = 5;                     // Fast MA period
input int SlowMA = 20;                    // Slow MA period
input int RSIPeriod = 14;                 // RSI Period
input double RSIOverbought = 70;          // RSI Overbought level
input double RSIOversold = 30;            // RSI Oversold level
input ENUM_TIMEFRAME TimeframeInput = PERIOD_M1;  // Timeframe (M1/M5)

//--- Global variables
double PointValue;
int Digits_Adjust;
int FastMAHandle;
int SlowMAHandle;
int RSIHandle;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Get point value
    PointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    Digits_Adjust = (SymbolInfoInteger(_Symbol, SYMBOL_DIGITS) == 5 || 
                     SymbolInfoInteger(_Symbol, SYMBOL_DIGITS) == 3) ? 10 : 1;
    
    // Create indicator handles
    FastMAHandle = iMA(_Symbol, TimeframeInput, FastMA, 0, MODE_EMA, PRICE_CLOSE);
    SlowMAHandle = iMA(_Symbol, TimeframeInput, SlowMA, 0, MODE_EMA, PRICE_CLOSE);
    RSIHandle = iRSI(_Symbol, TimeframeInput, RSIPeriod, PRICE_CLOSE);
    
    // Check if handles are valid
    if (FastMAHandle == INVALID_HANDLE || SlowMAHandle == INVALID_HANDLE || RSIHandle == INVALID_HANDLE)
    {
        Print("Error creating indicator handles");
        return(INIT_FAILED);
    }
    
    // Initialize trade object
    trade.SetExpertMagicNumber(20240913);
    trade.SetTypeFillingBySymbol(_Symbol);
    trade.SetDeviationInPoints(10);
    
    Print("Scalping EA Vol80 initialized successfully");
    return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    // Get market data
    double fastMABuffer[];
    double slowMABuffer[];
    double rsiBuffer[];
    
    ArraySetAsSeries(fastMABuffer, true);
    ArraySetAsSeries(slowMABuffer, true);
    ArraySetAsSeries(rsiBuffer, true);
    
    // Copy indicator data
    if (CopyBuffer(FastMAHandle, 0, 0, 3, fastMABuffer) <= 0)
    {
        Print("Error copying Fast MA data");
        return;
    }
    
    if (CopyBuffer(SlowMAHandle, 0, 0, 3, slowMABuffer) <= 0)
    {
        Print("Error copying Slow MA data");
        return;
    }
    
    if (CopyBuffer(RSIHandle, 0, 0, 3, rsiBuffer) <= 0)
    {
        Print("Error copying RSI data");
        return;
    }
    
    double fastMA = fastMABuffer[0];
    double slowMA = slowMABuffer[0];
    double rsi = rsiBuffer[0];
    
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    
    // Count open positions
    int openPositions = CountOpenPositions();
    
    // Entry Logic
    if (openPositions < MaxOpenPositions)
    {
        // BUY Signal: Fast MA above Slow MA + RSI oversold
        if (fastMA > slowMA && rsi < RSIOversold && !HasOpenBuy())
        {
            OpenBuyPosition(ask);
        }
        
        // SELL Signal: Fast MA below Slow MA + RSI overbought
        if (fastMA < slowMA && rsi > RSIOverbought && !HasOpenSell())
        {
            OpenSellPosition(bid);
        }
    }
}

//+------------------------------------------------------------------+
//| Open BUY position                                                |
//+------------------------------------------------------------------+
void OpenBuyPosition(double entryPrice)
{
    double lot = CalculateLotSize(StopLossPips);
    double tp = entryPrice + (TakeProfitPips * PointValue * Digits_Adjust);
    double sl = entryPrice - (StopLossPips * PointValue * Digits_Adjust);
    
    if (lot > 0)
    {
        trade.Buy(lot, _Symbol, entryPrice, sl, tp, "Scalping Buy");
    }
}

//+------------------------------------------------------------------+
//| Open SELL position                                               |
//+------------------------------------------------------------------+
void OpenSellPosition(double entryPrice)
{
    double lot = CalculateLotSize(StopLossPips);
    double tp = entryPrice - (TakeProfitPips * PointValue * Digits_Adjust);
    double sl = entryPrice + (StopLossPips * PointValue * Digits_Adjust);
    
    if (lot > 0)
    {
        trade.Sell(lot, _Symbol, entryPrice, sl, tp, "Scalping Sell");
    }
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                 |
//+------------------------------------------------------------------+
double CalculateLotSize(int stopLossPips)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (RiskPercent / 100.0);
    double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
    
    if (tickSize == 0 || tickValue == 0)
    {
        Print("Error: Invalid tick size or tick value");
        return 0;
    }
    
    double pipValue = tickValue / tickSize;
    double lot = riskAmount / (stopLossPips * pipValue);
    
    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    lot = MathMax(lot, minLot);
    lot = MathMin(lot, maxLot);
    
    if (stepLot > 0)
    {
        lot = MathFloor(lot / stepLot) * stepLot;
    }
    
    return lot;
}

//+------------------------------------------------------------------+
//| Count open positions                                             |
//+------------------------------------------------------------------+
int CountOpenPositions()
{
    int count = 0;
    int total = PositionsTotal();
    
    for (int i = total - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket > 0)
        {
            if (PositionGetString(POSITION_SYMBOL) == _Symbol &&
                PositionGetInteger(POSITION_MAGIC) == 20240913)
            {
                count++;
            }
        }
    }
    
    return count;
}

//+------------------------------------------------------------------+
//| Check if there's an open BUY position                            |
//+------------------------------------------------------------------+
bool HasOpenBuy()
{
    int total = PositionsTotal();
    
    for (int i = total - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket > 0)
        {
            if (PositionGetString(POSITION_SYMBOL) == _Symbol &&
                PositionGetInteger(POSITION_MAGIC) == 20240913 &&
                PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
                return true;
            }
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Check if there's an open SELL position                           |
//+------------------------------------------------------------------+
bool HasOpenSell()
{
    int total = PositionsTotal();
    
    for (int i = total - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket > 0)
        {
            if (PositionGetString(POSITION_SYMBOL) == _Symbol &&
                PositionGetInteger(POSITION_MAGIC) == 20240913 &&
                PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
                return true;
            }
        }
    }
    
    return false;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Release indicator handles
    if (FastMAHandle != INVALID_HANDLE)
        IndicatorRelease(FastMAHandle);
    if (SlowMAHandle != INVALID_HANDLE)
        IndicatorRelease(SlowMAHandle);
    if (RSIHandle != INVALID_HANDLE)
        IndicatorRelease(RSIHandle);
    
    Print("Scalping EA Vol80 stopped");
}
