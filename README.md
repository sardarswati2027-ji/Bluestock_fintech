# Bluestock_fintech
Data Analyst Intern capstone project @ Bluestock Fintech

#  Mutual Fund Portfolio & Risk Analytics Platform
### Bluestock Fintech Capstone Project — End-to-End Data Engineering, ETL Pipeline & Interactive Dashboard
**Author:** Swati Sardar  
**Designation:** Intern / Data Analyst — Bluestock Fintech  

---

## Project Overview
This repository contains a production-grade, state-retaining data engineering pipeline and quantitative risk analytics engine built to ingest, sanitize, model, and visualize multi-relational Indian mutual fund datasets. 

The platform scales fragmented, high-frequency historical data arrays (sourced from AMFI India, mfapi.in, and public stock exchange records) into structured financial assets. By engineering decoupled pipeline modules and non-parametric downside tail risk engines, the system provides asset management companies (AMCs) and quantitative teams with crystal-clear visibility into fund performance, demographic shifts, sector concentrations, and left-tail exposure metrics during deep economic corrections.

---

## Technology Stack & Environment
* **Language Layer:** Python 3.12 (Vectorized execution via Pandas, NumPy)
* **Statistical Computing & Data Science:** SciPy, Statsmodels, Architecture Modeling
* **Database & Transformation Layer:** PostgreSQL / DuckDB, Structured SQL Engines
* **Data Visualization Universes:** Plotly Express, Seaborn, Matplotlib, Power BI / Tableau Desktop
* **Enterprise Reporting Suite:** WeasyPrint (Automated CSS Paged Media HTML-to-PDF compilers)

---

## System Pipeline Architecture
The codebase is structured as a decoupled series of state-preserving Jupyter notebooks (`.ipynb`) and script controllers (`.py`). Each module handles isolated database tasks and serializes validated states to disk, allowing flawless error handling and pipeline check-pointing.

Traceback (most recent call last):
  File "<xbox-string>", line 296, in <module>
    print(f"CRITICAL FAULT: Required dataset target '{filename}' missing.")
NameError: name 'filename' is not defined

[Raw Files Store] ──> (01_Data_Ingestion) ──> [Schema Verified Profiles]
│
[Clean Data Tables] <── (02_Data_Cleaning) <──────────┘
│
├──> (03_EDA_Analysis) ──────────> [Visual Matrices & Market Phases]
│
├──> (04_Performance_Analytics) ─> [Scale-Invariant Log Return Vectors]
│
└──> (05_Advanced_Analytics) ────> [Empirical VaR / CVaR Tail Risk Models]

### Production Module Breakdown:
1. **`01_data_ingestion.ipynb` (Ingestion & Health Check):** Mounts data interface streams, verifies structural grid constraints, checks primitive feature data types, and logs immediate system memory usage boundaries.
2. **`02_data_cleaning.ipynb` (Sanitization & Type Enforcement):** Applies text-trimming filters to categorical arrays, enforces exact ISO datetime formats, coercively fixes invalid numerical objects, and sets foreign index keys.
3. **`03_EDA_Analysis.ipynb` (Exploratory Data Science Core):** Isolates systemic institutional asset concentration, tracks long-horizon scaling trends, evaluates category inflow shifts, and maps investor folio distributions.
4. **`04_Performance_Analytics.ipynb` (Mathematical Volatility Vectorization):** Computes trailing compound asset trajectories and applies a vectorized rolling window derivative to convert absolute pricing records into stationary log returns.
5. **`05_advanced_analytics.ipynb` (Advanced Risk & Behavioral Engine):** Calculates non-parametric empirical left-tail boundaries ($VaR_{95} / CVaR_{95}$), tracks sector Herfindahl-Hirschman Indices (HHI), and runs demographic cohort survival matrices.

---

## Core Quantitative & Financial Formulations

### 1. Daily Logarithmic Return Vector
To eliminate the scaling biases and geometric inaccuracies inherent in standard percentage changes when compounding across long financial horizons, the returns extraction engine shifts the time-series space to scale-invariant, time-additive log variations:

$$R_t = \ln\left(\frac{\text{NAV}_t}{\text{NAV}_{t-1}}\right) = \ln(\text{NAV}_t) - \ln(\text{NAV}_{t-1})$$

### 2. Non-Parametric Value at Risk ($\text{VaR}_{95}$)
Instead of utilizing restricted parametric curves that fail to reflect real financial "fat tails," the tail risk framework extracts the exact 5th empirical percentile from the calculated historical log-return distribution:

$$\text{VaR}_{95} = \zeta \quad \text{such that} \quad P(R_t \le \zeta) = 0.05$$

### 3. Conditional Value at Risk ($\text{CVaR}_{95}$ / Expected Shortfall)
To measure the real extent of tail asset destruction once the initial $95\%$ protective boundary is breached, the engine models the conditional expected loss of the sub-5% tail distribution:

$$\text{CVaR}_{95} = E\left[ R_t \;\middle|\; R_t \le \text{VaR}_{95} \right] = \frac{1}{|T_{\text{tail}}|} \sum_{t \in T_{\text{tail}}} R_t$$

---

## Verified Relational Schema Profile
The platform reads, verifies, and blends 10 modular tabular datasets, constructing an optimized analytics network:

| Tabular Data Handle File | Primary Keys / Columns Checked | Data Grid Scale | Analytical Target Objective |
| :--- | :--- | :--- | :--- |
| `nav_history_cleaned.csv` | `amfi_code`, `date`, `nav` | ~8,050 rows baseline | Input for high-frequency volatility transformation. |
| `investor_transactions_cleaned.csv` | `investor_id`, `transaction_date`, `amount_inr`, `state`, `city_tier`, `gender`, `age_group` | ~5,000 active transacting logs | Drives demographic cohort splits and behavioral continuation analysis. |
| `scheme_performance_cleaned.csv` | `amfi_code`, `scheme_name`, `fund_house`, `alpha`, `beta`, `sharpe_ratio`, `sortino_ratio` | Fully cross-populated | Powers the multi-attribute fund screening scorecard matrix. |
| `cleaned_09_portfolio_holdings.csv` | `amfi_code`, `stock_symbol`, `sector`, `weight_pct` | Granular stock-by-stock lines | Computes micro-level asset diversification and portfolio sector concentration. |
| `cleaned_04_monthly_sip_inflows.csv` | `month`, `sip_inflow_crore`, `active_sip_accounts_crore` | 48-month continuous track | Tracks macroscopic retail momentum scaling over multi-year windows. |

---

##  Key Empirical Findings & Business Insights
* **SBI MF Market Footprint Leadership:** SBI Mutual Fund dominates the competitive landscape, compounding its maximum active asset base from **₹6.05 Lakh Crore** in early 2022 to an industry-leading high of **₹12.5 Lakh Crore** by late 2025.
* **SIP retail Volume Milestones:** Industry-wide monthly systematic recurring inflows achieved a record terminal pace of **₹31,002 Crore** in December 2025, matching a surge in unique retail registrations to **26.12 Crore folios**.
* **Systemic Sector Concentrations:** Aggregated equity mutual fund strategies maintain a massive institutional reliance on the **Banking and Financial Services** sector, holding an average portfolio allocation weight of **19.18%**, followed by Information Technology (**13.40%**).
* **The Demographic Divergence:** Unique folio registrations across the customer transaction ledger exhibit a persistent participation imbalance, with male-owned investment accounts locking in **66.7%** of active capitalization versus **33.3%** held by female investors.
* **Tail Vulnerability Grids:** Small-Cap Equity configurations (e.g., *ABSL Small Cap Regular, SBI Small Cap Direct*) present highly volatile downside boundaries, exhibiting single-day empirical $\text{VaR}_{95}$ drops down to **$-2.68\%$** with an expected tail downfall shortfall ($\text{CVaR}_{95}$) intensifying to **$-3.24\%$** during systemic market corrections. Conversely, defensive debt structures (*HDFC Short Term Debt*) remain perfectly secure near a daily VaR limit of **$-0.15\%$**.

---

### 🐍 2. Initialize and Activate Virtual Environment
python3 -m venv env
source env/bin/activate  # On Windows use: env\\Scripts\\activate
pip install -r requirements.txt

## 📌 Project Overview
This repository hosts a production-grade Data Engineering framework and Quantitative Risk Analytics Engine built to clean, ingest, model, and visualize a multi-table relational schema containing active Indian mutual fund asset data. 

The core mission of this engine is to establish data integrity validations and map empirical downside risk behaviors across diverse fund classes (e.g., High-growth Small-Caps vs. Low-volatility Fixed-Income Debt structures). The output includes highly descriptive multi-attribute scorecards and a modular Python ETL framework.

---

## 🏗️ Core Platform Architecture
The engine is decoupled into an ordered, state-preserving 5-stage pipeline where each notebook validates, handles, and serializes intermediate objects safely onto the local storage disk before down-stream vectorizations execute.


```

```
   [Raw Storage Warehouse]
             │
             ▼

```

┌────────────────────────────────┐
│ 01_data_ingestion.ipynb        │ ──► Dimensions Assertions & Schema Discovery
└────────────────────────────────┘
│
▼
┌────────────────────────────────┐
│ 02_data_cleaning.ipynb         │ ──► Whitespace Trimming & ISO Datetime Coercion
└────────────────────────────────┘
│
▼
┌────────────────────────────────┐
│ 03_EDA_Analysis.ipynb          │ ──► Macro-Regime Analysis & JSON State Exports
└────────────────────────────────┘
│
▼
┌────────────────────────────────┐
│ 04_Performance_Analytics.ipynb │ ──► Vectorized Shift Log Returns Converter
└────────────────────────────────┘
│
▼
┌────────────────────────────────┐
│ 05_advanced_analytics.ipynb    │ ──► Non-Parametric Left-Tail Risk Engine
└────────────────────────────────┘
│
▼
[Production Report Models] ───► `var_cvar_report.csv` & BI Interface Hooks

```

---

## 📂 System Data Inventory
The analytics warehouse unifies **10 core relational cleaning layers** that link transactions, holdings, and macroeconomic benchmark paths seamlessly:

* `cleaned_01_fund_master.csv`: Comprehensive descriptive static variables including AMFI unique codes and SEBI class references.
* `nav_history_cleaned.csv`: Continuous daily Net Asset Value tracking series.
* `scheme_performance_cleaned.csv`: Consolidated risk/return tracking indicators (Alpha, Beta, Sharpe, Sortino).
* `investor_transactions_cleaned.csv`: Granular client transactional ledger detailing cohort demographics, income tiers, and execution frequencies.
* `cleaned_09_portfolio_holdings.csv`: Stock-by-stock breakdowns and asset allocations across economic sectors.
* `cleaned_04_monthly_sip_inflows.csv`: Historical baseline tracking 48 months of retail payment velocities.

---

## 🔢 Mathematical & Algorithmic Framework

### 1. Vector Return Generation Engine
To prevent compounding drift errors and eliminate exponential scale distortions over long time-series horizons, absolute historical net valuations are converted into scale-invariant stationary vectors:
$$R_t = \ln\left(\frac{\text{NAV}_t}{\text{NAV}_{t-1}}\right) = \ln(\text{NAV}_t) - \ln(\text{NAV}_{t-1})$$

### 2. Empirical Left-Tail Downside Estimators
The platform avoids basic, linear Gaussian assumptions by testing real financial fat-tail distributions using non-parametric **Historical Simulations** at a strict $95\%$ confidence window:

* **Value at Risk ($VaR_{95}$)**: Extracts the empirical 5th percentile return cut-off parameter:
    $$\text{VaR}_{95} = \zeta \quad \text{such that} \quad P(R_t \le \zeta) = 0.05$$
* **Conditional Value at Risk ($CVaR_{95}$ / Expected Shortfall)**: Measures the expected conditional intensity of losses once the primary $VaR$ barrier is broken:
    $$\text{CVaR}_{95} = E\left[ R_t \;\middle|\; R_t \le \text{VaR}_{95} \right] = \frac{1}{|T_{\text{tail}}|} \sum_{t \in T_{\text{tail}}} R_t$$

---

## 📈 Key Empirical Risk Insights
From the compiled execution logs and output data registers (`var_cvar_report.csv`), the quantitative models isolated clear structural behaviors:

| Fund Category | Representative Asset Scheme | 95% Daily VaR | 95% Daily CVaR | Calc. Max Drawdown |
| :--- | :--- | :---: | :---: | :---: |
| **Equity Small-Cap** | SBI Small Cap Fund - Direct Plan | `-2.685%` | `-3.238%` | `-13.35%` |
| **Equity Small-Cap** | ABSL Small Cap Fund - Regular | `-2.602%` | `-3.245%` | `-35.44%` |
| **Equity Large-Cap** | Axis Bluechip Fund - Regular | `-1.374%` | `-1.732%` | `-11.29%` |
| **Fixed-Income Debt** | HDFC Short Term Debt Fund | `-0.152%` | `-0.210%` | `-4.30%` |

* **Small-Cap Left-Tail Exposures**: High-growth equity allocation portfolios present severe downside single-day boundaries, ranging between **$-2.34\%$ and $-2.68\%$**. If broken, expected daily shortfalls slide to an average of **$-3.24\%$**.
* **Defensive Debt Anchors**: Conversely, short-term bond matrices provide strong capital defense, capping single-day $VaR$ exposures at a negligible **$-0.15\%$**.

---

## 📊 Management Dashboard Highlights
The system passes data objects cleanly into an interactive Management Interface summarizing core industrial scale milestones as of **December 2025**:
* **Total Industry AUM**: Scaled to an all-time high of **₹81.0L Cr**.
* **SIP Monthly Velocity**: Established a landmark recurring pace of **₹31K Cr**.
* **Folio Volume Spreads**: Settled at **26.12 Cr active folios** tracking across 1,908 schemas.
* **Demographic Concentrations**: Isolated an industry-wide gender spread identifying **66.7% Male vs. 33.3% Female** account registration limits, alongside a heavy **19.18% reliance on the Banking & Financial Services sector**.

---

## 🛠️ Technology Stack

* **Language & Core Processing**: Python 3.12 (Pandas, NumPy, Vectorized Shifts)
* **Exploratory Visualizations**: Matplotlib, Seaborn, Plotly Engine
* **Business Intelligence Reporting**: Power BI / Tableau Layout integration
* **Document Compilation**: WeasyPrint CSS Paged Media HTML-to-PDF compiler
