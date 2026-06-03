# Mutual Funds Analytics Database — Data Dictionary

This document serves as the comprehensive data dictionary for the `mutual_funds.db` SQLite database. It establishes schemas, business requirements, field-level constraints, and references for all 10 cleaned mutual fund datasets.

---

## 1. Core Schema Architecture
[Image of mutual fund database entity relationship diagram]

The database contains 10 interdependent tables designed to cross-reference scheme metadata, historical financial metrics, transactional behavior, demographic data, and macro-level industry metrics.

* **Primary Relationships Key:** * `amfi_code` serves as the fundamental relational key across `fund_master`, `scheme_performance`, `nav_history`, `portfolio_holdings`, and `investor_transactions`.
  * Dates are uniformly mapped across historical series tables to match calendar horizons.

---

## 2. Table-by-Table Field Metadata

### Table 1: `fund_master`
* **Source Reference:** `cleaned_01_fund_master.csv`
* **Business Definition:** Master registry storing structural metadata, fund management profiles, legal SEBI classifications, and operational investment thresholds for all registered mutual fund schemes.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `amfi_code` | `INTEGER` | Association of Mutual Funds in India (AMFI) unique scheme identifier. Primary Key. | Non-Null, > 100000 | `100016` |
| `fund_house` | `TEXT` | Asset Management Company (AMC) name managing the vehicle. | Non-Null | `HDFC Mutual Fund` |
| `scheme_name` | `TEXT` | Full public name of the specific investment vehicle plan. | Non-Null | `HDFC Top 100 Fund - Regular Plan - Growth` |
| `category` | `TEXT` | Broad statutory asset class allocation framework. | `Equity`, `Debt`, `Hybrid`, `Index/ETF`, `Liquid` | `Equity` |
| `sub_category` | `TEXT` | Granular SEBI allocation definition. | e.g., `Large Cap`, `Mid Cap`, `Small Cap`, `Gilt` | `Large Cap` |
| `plan` | `TEXT` | Direct routing vs Intermediary commission plan distinction. | `Regular`, `Direct` | `Regular` |
| `launch_date` | `TEXT` | Statutory date the fund was initialized and went live. | `YYYY-MM-DD` | `1996-09-11` |
| `benchmark` | `TEXT` | Public tracking market index utilized to evaluate structural alpha. | Valid Exchange Index | `NIFTY 100 TRI` |
| `expense_ratio_pct` | `REAL` | Annualized cost percentage subtracted from fund asset pool to pay management. | `0.00` to `3.50` | `1.55` |
| `exit_load_pct` | `REAL` | Penalization fee charged if units are redeemed prior to a predefined lock-in window. | `>= 0.00` | `1.0` |
| `min_sip_amount` | `INTEGER` | Minimum systematic regular installment currency threshold. | Multiples of `100` | `500` |
| `min_lumpsum_amount`| `INTEGER` | Minimum primary point-in-time lump capital ingestion allowed. | Multiples of `500` | `1000` |
| `fund_manager` | `TEXT` | Lead portfolio manager executing buy/sell market strategies. | Non-Null | `Rahul Baijal` |
| `risk_category` | `TEXT` | Visual risk speedometer assignment based on portfolio volatile characteristics. | `Low`, `Moderate`, `High`, `Very High` | `Moderate` |
| `sebi_category_code`| `TEXT` | Internal SEBI regulatory taxonomy reporting structural label. | Alphanumeric Code | `EC01` |

---

### Table 2: `scheme_performance`
* **Source Reference:** `scheme_performance_cleaned.csv`
* **Business Definition:** Performance analysis table tracking annualized returns, volatility indexes, drawdown bounds, asset pool sizing, and Morningstar metadata benchmarks.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `amfi_code` | `INTEGER` | AMFI Unique Identifer code. Foreign key referencing `fund_master`. | Non-Null | `119551` |
| `scheme_name` | `TEXT` | Public retail name tracking the corporate vehicle. | Non-Null | `SBI Bluechip Fund - Regular Plan - Growth` |
| `fund_house` | `TEXT` | Legal enterprise handling fund structuring. | Non-Null | `SBI Mutual Fund` |
| `category` | `TEXT` | Asset tier operational group. | Match Master Set | `Large Cap` |
| `plan` | `TEXT` | Distribution architecture wrapper. | `Regular`, `Direct` | `Regular` |
| `return_1yr_pct` | `REAL` | Absolute trailing 12-month trailing investment growth return rate. | Percentage | `12.42` |
| `return_3yr_pct` | `REAL` | Annualized compound geometric mean rate of return over the past 36 months. | Percentage | `12.36` |
| `return_5yr_pct` | `REAL` | Annualized compound geometric mean rate of return over the past 60 months. | Percentage | `14.45` |
| `benchmark_3yr_pct` | `REAL` | Companion index matching annualized returns over identical 36 months. | Percentage | `11.49` |
| `alpha` | `REAL` | Risk-adjusted value-added performance metric relative to tracking benchmark. | Positive/Negative | `0.87` |
| `beta` | `REAL` | Systematic market volatility index relative to broad market indices. | General baseline = `1.0` | `0.89` |
| `sharpe_ratio` | `REAL` | Excess return generated per unit of absolute portfolio risk. Higher is superior. | Absolute Ratio | `0.88` |
| `sortino_ratio` | `REAL` | Excess return generated per unit of harmful downside portfolio risk. | Absolute Ratio | `1.29` |
| `std_dev_ann_pct` | `REAL` | Annualized statistical standard deviation tracking historical price variance. | Percentage | `14.0` |
| `max_drawdown_pct` | `REAL` | Maximum peak-to-trough value collapse percentage during lookback frame. | Negative Percentage | `-21.7` |
| `aum_crore` | `INTEGER` | Aggregate actual market valuation capitalization size of current assets pool. | In Crores (INR) | `14288` |
| `expense_ratio_pct` | `REAL` | Ongoing management cost charge parameter. | Percentage | `1.54` |
| `morningstar_rating`| `INTEGER` | Independent performance/risk-adjusted tier rating stars. | `1` to `5` | `4` |
| `risk_grade` | `TEXT` | Relative volatility assessment rank within specific categorization bucket. | `Low` to `Very High` | `Moderate` |

---

### Table 3: `nav_history`
* **Source Reference:** `nav_history_cleaned.csv`
* **Business Definition:** High-frequency transaction engine data stream tracking the daily net valuation per public share unit based on closing prices.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `amfi_code` | `INTEGER` | AMFI Unique Identifer code. Foreign key referencing `fund_master`. | Non-Null | `100016` |
| `date` | `TEXT` | Market valuation calendar operational business day. | `YYYY-MM-DD` | `2022-01-03` |
| `nav` | `REAL` | Absolute value per individual outstanding share unit at market close. | `> 0.00` | `520.4608` |

---

### Table 4: `investor_transactions`
* **Source Reference:** `investor_transactions_cleaned.csv`
* **Business Definition:** B2C operational dataset compiling retail customer demographic markers, localized regional groupings, transaction types, and structural validation workflows.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `investor_id` | `TEXT` | Masked internal alphanumeric distinct customer master system key. | Unique Format | `INV000001` |
| `transaction_date` | `TEXT` | Operational date capital flow occurred and clear checks finalized. | `YYYY-MM-DD` | `2024-11-04` |
| `amfi_code` | `INTEGER` | Target allocation fund code destination. | Match Master Set | `120505` |
| `transaction_type` | `TEXT` | Directional category of incoming/outgoing investment. | `SIP`, `Lumpsum`, `Redemption`| `SIP` |
| `amount_inr` | `INTEGER` | Financial volume transacted in absolute Indian Rupees. | `>= 100` | `44856` |
| `state` | `TEXT` | Geopolitical federal territory address of record for investor. | Valid Indian State | `Haryana` |
| `city` | `TEXT` | Local town/urban residency hub name. | Non-Null | `Gurugram` |
| `city_tier` | `TEXT` | Operational classification separating high urban concentration zones. | `T30` (Top 30), `B30` (Beyond 30)| `T30` |
| `age_group` | `TEXT` | Segmented grouping mapping age range for profiling. | `18-25`, `26-35`, `36-45`, `46-55`, `56+` | `36-45` |
| `gender` | `TEXT` | Biological demographic classification tag. | `Male`, `Female`, `Other` | `Male` |
| `annual_income_lakh`| `REAL` | Validated annual baseline income brackets scaled in Lakhs (100,000 INR). | Multiples of Lakhs | `19.9` |
| `payment_mode` | `TEXT` | Ingestion technology engine channel applied. | `UPI`, `Net Banking`, `Mandate`, `Cheque` | `UPI` |
| `kyc_status` | `TEXT` | Legal anti-money laundering registration validation status tag. | `Verified`, `Pending`, `Failed` | `Verified` |

---

### Table 5: `portfolio_holdings`
* **Source Reference:** `cleaned_09_portfolio_holdings.csv`
* **Business Definition:** Granular underlying investment table exposing exactly what public stocks and commercial company stakes individual fund engines are holding.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `amfi_code` | `INTEGER` | Sponsoring fund vehicle unique AMFI key. | Match Master Set | `100016` |
| `stock_symbol` | `TEXT` | National Stock Exchange (NSE) trade ticker symbol. | Valid Exchange Ticker| `WIPRO` |
| `stock_name` | `TEXT` | Formal enterprise registered corporate legal title. | Non-Null | `Wipro Ltd` |
| `sector` | `TEXT` | Macro economic segment classification label. | `Banking`, `IT`, `Pharma`, `Automobile`, `Utilities`, etc. | `IT` |
| `weight_pct` | `REAL` | Percentage proportion this specific stock takes within total fund capital. | `0.00` to `100.00` | `25.9` |
| `market_value_cr` | `REAL` | Current financial pricing weight scaled in absolute Crores. | `> 0.00` | `552.43` |
| `current_price_inr` | `REAL` | Exchange equity baseline closing share quote price in INR. | `> 0.00` | `579.31` |
| `portfolio_date` | `TEXT` | Reporting disclosures statement compilation batch target date. | `YYYY-MM-DD` | `2025-12-31` |

---

### Table 6: `aum_by_fund_house`
* **Source Reference:** `cleaned_03_aum_by_fund_house.csv`
* **Business Definition:** Macro corporate dashboard metric archiving industry asset accumulation metrics at individual fund house enterprise layers.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `date` | `TEXT` | Financial terminal cycle quarterly audit accounting date. | `YYYY-MM-DD` | `2022-03-31` |
| `fund_house` | `TEXT` | Corporate Asset Management entity name. | Match Master Set | `Aditya Birla Sun Life MF` |
| `aum_lakh_crore` | `REAL` | Aggregated corporate asset scale calculated in Lakh Crores. | `>= 0.00` | `2.78` |
| `aum_crore` | `INTEGER` | Identical valuation mapped directly into absolute Crores format. | Equivalent Scaled Val | `278000` |
| `num_schemes` | `INTEGER` | Active regulatory approved investment vehicles active on market. | `> 0` | `199` |

---

### Table 7: `monthly_sip_inflows`
* **Source Reference:** `cleaned_04_monthly_sip_inflows.csv`
* **Business Definition:** High-level macroeconomic trend tracking metrics analyzing the health and momentum of programmatic monthly direct retail equity flow.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `month` | `TEXT` | Target month identifier for inflow data collection. | `YYYY-MM-DD` (First day) | `2022-01-01` |
| `sip_inflow_crore` | `INTEGER` | Complete collective currency ingestion volume from all active SIP accounts. | In Crores (INR) | `11517` |
| `active_sip_accounts_crore`| `REAL` | Quantifiable total active scheduled running automatic execution pipelines. | In Crores (Count) | `4.91` |
| `new_sip_accounts_lakh` | `REAL` | Fresh accounts successfully signed up inside target timeline framework. | In Lakhs (Count) | `9.1` |
| `sip_aum_lakh_crore` | `REAL` | Net asset valuation tracking wealth built exclusively by historical SIP lines. | In Lakh Crores | `4.8` |
| `yoy_growth_pct` | `REAL` | Comparative dynamic calculation rate tracing parallel calendar frames. | Percentage | `23.64` |

---

### Table 8: `category_inflows`
* **Source Reference:** `cleaned_05_category_inflows.csv`
* **Business Definition:** Dynamic tracking database capturing shifting market sentiment by measuring capital flows on a per-category basis.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `month` | `TEXT` | Calendar boundary ledger tracking point. | `YYYY-MM-DD` | `2024-04-01` |
| `category` | `TEXT` | Standard broad style grouping taxonomy target. | Matches SEBI classifications | `ELSS` |
| `net_inflow_crore` | `REAL` | Gross purchases subtracted by total customer redemptions inside calendar window. | Positive or Negative | `466.0` |

---

### Table 9: `industry_folio_count`
* **Source Reference:** `cleaned_06_industry_folio_count.csv`
* **Business Definition:** Retail customer account mapping infrastructure monitoring unique investment account distributions across individual segments.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `month` | `TEXT` | Regulatory industry milestone capture frame timeline marker. | `YYYY-MM-DD` | `2022-01-01` |
| `total_folios_crore` | `REAL` | Cumulative count of all mutual fund accounts in India. | In Crores (Count) | `13.26` |
| `equity_folios_crore`| `REAL` | Segment subset mapping equity structures. | In Crores (Count) | `9.28` |
| `debt_folios_crore` | `REAL` | Segment subset mapping commercial debt instruments. | In Crores (Count) | `1.86` |
| `hybrid_folios_crore`| `REAL` | Segment subset mapping asset mix structures. | In Crores (Count) | `0.8` |
| `others_folios_crore`| `REAL` | Segment subset mapping index, commodity, and gold trackers. | In Crores (Count) | `1.33` |

---

### Table 10: `benchmark_indices`
* **Source Reference:** `cleaned_10_benchmark_indices.csv`
* **Business Definition:** Independent macro financial ledger storing close tracking numbers for public index assets to evaluate alpha performance parameters.

| Column Name | Storage Type (SQL) | Business Definition & Rules | Constraints / Valid Range | Sample Value |
| :--- | :--- | :--- | :--- | :--- |
| `date` | `TEXT` | Standard public stock exchange trading business day. | `YYYY-MM-DD` | `2022-01-03` |
| `index_name` | `TEXT` | Public tracking market standard taxonomy label. | `NIFTY50`, `BSE_SMALLCAP`, etc. | `NIFTY50` |
| `close_value` | `REAL` | Terminal value index level point pricing at exchange session bell. | `> 0.00` | `17492.79` |