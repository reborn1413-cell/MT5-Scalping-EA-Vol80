# MT5 Scalping EA - Vol 80 Synthetic

A professional high-frequency scalping Expert Advisor optimized for MetaTrader 5, specifically designed for Volume 80 Synthetic on M1/M5 timeframes.

## Features

✅ **Multi-Timeframe Support** - Optimized for M1 and M5
✅ **Risk Management** - Configurable risk per trade with automatic position sizing
✅ **Indicator-Based Signals** - EMA crossover + RSI confirmation
✅ **Position Management** - Max simultaneous positions limit
✅ **Quick Scalping** - Tight take profit/stop loss for rapid trades
✅ **Volume 80 Optimized** - Tuned for synthetic high-volume trading

## Strategy Logic

### Entry Signals
- **BUY**: Fast MA crosses above Slow MA + RSI < 30 (oversold)
- **SELL**: Fast MA crosses below Slow MA + RSI > 70 (overbought)

### Exit Strategy
- **Take Profit**: 10 pips (configurable)
- **Stop Loss**: 5 pips (configurable)
- **Position Limit**: Max 3 simultaneous positions

## Input Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| RiskPercent | 1.0 | Risk per trade as % of balance |
| TakeProfitPips | 10 | Take profit distance in pips |
| StopLossPips | 5 | Stop loss distance in pips |
| MaxOpenPositions | 3 | Maximum simultaneous trades |
| FastMA | 5 | Fast moving average period |
| SlowMA | 20 | Slow moving average period |
| RSIPeriod | 14 | RSI indicator period |
| RSIOverbought | 70 | RSI overbought threshold |
| RSIOversold | 30 | RSI oversold threshold |
| Timeframe | M1 | Chart timeframe (M1 or M5) |

## Installation

1. Download `ScalpingEA_Vol80.mq5`
2. Copy to: `C:\Users\YourUsername\AppData\Roaming\MetaQuotes\Terminal\[TerminalID]\MQL5\Experts\`
3. Restart MetaTrader 5
4. Drag the EA onto Volume 80 Synthetic chart
5. Enable AutoTrading
6. Adjust input parameters as needed

## Testing & Optimization

- **Backtest** on Volume 80 Synthetic (M1/M5)
- **Forward test** on demo account first
- **Optimize** parameters based on your broker's spread and conditions
- **Monitor** daily for performance adjustments

## Risk Disclaimer

⚠️ **Trading involves risk.** This EA is provided as-is without warranty. Always:
- Test thoroughly on demo first
- Use proper money management
- Never risk more than you can afford to lose
- Monitor trades regularly

## Support

For issues, improvements, or questions, create an issue on GitHub.

---

**Version**: 1.0  
**Created**: 2024  
**Platform**: MetaTrader 5  
**Symbol**: Volume 80 Synthetic  
**Timeframes**: M1, M5