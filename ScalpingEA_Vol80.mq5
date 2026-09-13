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
input ENUM_TIMEFRAME Timeframe = PERIOD_M1;  // Timeframe (M1/M5)

//--- Global variables
double PointValue;
int Digits_Adjust;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    // Get point value
    PointValue = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
    Digits_Adjust = (SymbolInfoInteger(_Symbol, SYMBOL_DIGITS) == 5 || 
                     SymbolInfoInteger(_Symbol, SYMBOL_DIGITS) == 3) ? 10 : 1;
    
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
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    CopyRates(_Symbol, Timeframe, 0, 50, rates);
    
    // Calculate indicators
    double fastMA = iMA(_Symbol, Timeframe, FastMA, 0, MODE_EMA, PRICE_CLOSE, 0);
    double slowMA = iMA(_Symbol, Timeframe, SlowMA, 0, MODE_EMA, PRICE_CLOSE, 0);
    double rsi = iRSI(_Symbol, Timeframe, RSIPeriod, PRICE_CLOSE, 0);
    
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
    
    // Exit Logic (handled by TP/SL)
}

//+------------------------------------------------------------------+
//| Open BUY position                                                |
//+------------------------------------------------------------------+
void OpenBuyPosition(double entryPrice)
{
    double lot = CalculateLotSize(StopLossPips);
    double tp = entryPrice + (TakeProfitPips * PointValue * Digits_Adjust);
    double sl = entryPrice - (StopLossPips * PointValue * Digits_Adjust);
    
    trade.Buy(lot, _Symbol, entryPrice, sl, tp, "Scalping Buy");
}

//+------------------------------------------------------------------+
//| Open SELL position                                               |
//+------------------------------------------------------------------+
void OpenSellPosition(double entryPrice)
{
    double lot = CalculateLotSize(StopLossPips);
    double tp = entryPrice - (TakeProfitPips * PointValue * Digits_Adjust);
    double sl = entryPrice + (StopLossPips * PointValue * Digits_Adjust);
    
    trade.Sell(lot, _Symbol, entryPrice, sl, tp, "Scalping Sell");
}

//+------------------------------------------------------------------+
//| Calculate lot size based on risk                                 |
//+------------------------------------------------------------------+
double CalculateLotSize(int stopLossPips)
{
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double riskAmount = accountBalance * (RiskPercent / 100.0);
    double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
    double lot = riskAmount / (stopLossPips * pipValue);
    
    double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
    double stepLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
    
    lot = MathMax(lot, minLot);
    lot = MathMin(lot, maxLot);
    lot = MathFloor(lot / stepLot) * stepLot;
    
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
        if (PositionSelectByTicket(PositionGetTicket(i)))
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
        if (PositionSelectByTicket(PositionGetTicket(i)))
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
        if (PositionSelectByTicket(PositionGetTicket(i)))
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
    Print("Scalping EA Vol80 stopped");
}