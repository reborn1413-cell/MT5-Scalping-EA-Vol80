# Parameter Optimization Guide

## Quick Start Settings (Conservative)
```
RiskPercent = 0.5
TakeProfitPips = 15
StopLossPips = 7
MaxOpenPositions = 2
FastMA = 5
SlowMA = 20
RSIPeriod = 14
Timeframe = M5
```

## Aggressive Scalping (M1)
```
RiskPercent = 2.0
TakeProfitPips = 8
StopLossPips = 4
MaxOpenPositions = 5
FastMA = 3
SlowMA = 15
RSIPeriod = 12
Timeframe = M1
```

## Balanced Settings (Recommended M5)
```
RiskPercent = 1.0
TakeProfitPips = 10
StopLossPips = 5
MaxOpenPositions = 3
FastMA = 5
SlowMA = 20
RSIPeriod = 14
Timeframe = M5
```

## Parameter Descriptions

### RiskPercent (0.1 - 5.0)
- **Low (0.1-0.5)**: Conservative, smaller wins/losses
- **Medium (1.0-1.5)**: Balanced approach
- **High (2.0+)**: Aggressive, larger swings

### TakeProfitPips (5 - 50)
- **Tight (5-10)**: Quick scalps, many wins
- **Medium (10-20)**: Balanced profit potential
- **Wide (20+)**: Larger moves, fewer trades

### StopLossPips (2 - 15)
- **Tight (2-5)**: Low risk per trade
- **Medium (5-10)**: Standard protection
- **Wide (10+)**: Allows pullbacks

### MaxOpenPositions (1 - 5)
- **1**: Single position at a time
- **3**: Medium diversification
- **5+**: High frequency scalping

### FastMA Period (2 - 15)
- **Fast (2-5)**: Catches quick reversals
- **Medium (5-10)**: Standard responsiveness
- **Slow (10+)**: Filters noise

### SlowMA Period (10 - 50)
- **Fast (10-15)**: Quick trend identification
- **Medium (20-25)**: Balanced
- **Slow (30+)**: Trend confirmation

### RSI Settings
- **RSIPeriod**: 12-14 (standard for scalping)
- **Overbought**: 70-75 (higher = fewer sells)
- **Oversold**: 25-30 (lower = fewer buys)

### Timeframe Selection
- **M1**: High frequency, tight spreads required
- **M5**: Better for most traders, more stable signals

## Optimization Tips

1. **Start Conservative** - Begin with low risk, increase gradually
2. **Test in Backtest** - Use historical data to validate
3. **Forward Test** - Demo trade for 1-2 weeks minimum
4. **Monitor Spreads** - Volume 80 spreads are typically tight
5. **Adjust MA Periods** - Match your broker's volatility
6. **Track Win Rate** - Aim for 50%+ with proper risk/reward
7. **Time of Day** - Most active during major market hours

## Volume 80 Specific Tuning

Volume 80 Synthetic is designed for scalping:
- Spreads are typically 1-2 pips
- High volatility movements
- Good for tight TP/SL ratios
- Works well on M1 and M5

**Recommended for Vol80:**
- TakeProfitPips: 8-12
- StopLossPips: 4-6
- Timeframe: M5 (better stability than M1)

## Backtesting Checklist

- [ ] Set symbol to "Volume 80 Synthetic"
- [ ] Choose timeframe (M1 or M5)
- [ ] Set date range (at least 1 month)
- [ ] Run optimization on key parameters
- [ ] Check win rate (target: 50%+)
- [ ] Check profit factor (target: 1.5+)
- [ ] Review drawdown (max: 20%)

## Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Too many losses | Increase SL pips or raise RSI levels |
| Too few trades | Decrease MA periods or adjust RSI levels |
| Whipsaw trades | Increase SlowMA period, add filter |
| Large drawdowns | Reduce risk%, max positions, or tighten SL |
| Spreads eat profits | Use tighter TP values or M5 timeframe |

---

Always adjust parameters based on YOUR broker's conditions and account size.