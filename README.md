# NoForexNonsense-MQL-EA

## Table of contents

- [What is this?!](#what-is-this)
- [No Nonsense Forex (NNF) Strategy](#no-nonsense-forex-nnf-strategy)
	- [Main tools of the strategy](#main-tools-of-the-strategy)
	- [Tactics](#tactics)
	- [NNF strategy references](#nnf-strategy-references)
- [How To Use it?!](#how-to-use-it)
	- [MetaTrader 4](#metatrader-4)
	- [MetaTrader 5](#metatrader-5)
- [Results](#results)

## What is this?!

this is a **Metatrader4/5 EA** which uses **[No Nonsense Forex (NNF) strategy](#no-nonsense-forex-nnf-strategy)** to trade pairs. The NNF strategy is a complex trend following strategy. This EA is configurable and optimizable, so you can tune it to your own preferences or by using the strategy tester.

---

## How To Use it?!

***Warning :*** *don't apply this EA to a real account until you know what you are doing.*

### Windows 

1. Clone the repository into your MetaTrader 4/5 ***Shared Project*** Folder by **--recursive** flag.
2. Open *MetaEditor* and double click on **Indicators stuffs handler.bat**. it compiles predefined indicators and move to Indicators main folder.
3. Open **NoForexNonsense-MQL-EA.mq5** in *MetaEditor* and it the *Compile* button.
4. Now you find th EA in *Expert/Shared Folder/NoForexNonesense-MQL-EA* directory in *MetaTrader*.

### Mac
Comming soon!

---
## No Nonsense Forex (NNF) Strategy

### Main tools of the strategy
1. **ATR Indicator**
2. **Baseline**
3. **Confirmation Indicator**
4. **2nd Confirmation Indicator**
5. **Volume (Volatility) Indicator**
6. **Exit Indicator**

### Tactics
1. Scaling Out
2. Use trailing stops at 1.5xATR
3. One Candle Rule
4. $EVZ as a Volatility Indication
5. Pullbacks
6. Continuation Trades

🤔 **Need more details? ➡️ [NoNonesenseForex Strategy (NNF) Summary](./Docs/NoNonesenseForex%20Strategy%20(NNF).md)**

## Diagram

![](./Docs/Excalidraw/NoForexNonsense%20StateMachine.excalidraw.png)


---


