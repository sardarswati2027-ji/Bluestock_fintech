
-- DIMENSION TABLES

CREATE TABLE dim_fund (
    fund_key INTEGER PRIMARY KEY AUTOINCREMENT,
    amfi_code INTEGER UNIQUE NOT NULL,
    fund_name TEXT NOT NULL,
    fund_house TEXT,
    category TEXT,
    sub_category TEXT,
    risk_grade TEXT
);

CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,      -- YYYYMMDD
    full_date DATE NOT NULL UNIQUE,
    day INTEGER,
    month INTEGER,
    quarter INTEGER,
    year INTEGER,
    month_name TEXT,
    weekday_name TEXT
);



-- FACT NAV

CREATE TABLE fact_nav (
    nav_key INTEGER PRIMARY KEY AUTOINCREMENT,
    fund_key INTEGER NOT NULL,
    date_key INTEGER NOT NULL,
    nav_value DECIMAL(12,4) NOT NULL,

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    UNIQUE(fund_key, date_key)
);



-- FACT TRANSACTIONS

CREATE TABLE fact_transactions (
    transaction_key INTEGER PRIMARY KEY AUTOINCREMENT,
    fund_key INTEGER NOT NULL,
    date_key INTEGER NOT NULL,

    investor_id TEXT NOT NULL,
    transaction_type TEXT NOT NULL,
    amount_inr DECIMAL(15,2) NOT NULL,
    units DECIMAL(15,4),
    kyc_status TEXT,

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key)
);


-- FACT PERFORMANCE


CREATE TABLE fact_performance (
    performance_key INTEGER PRIMARY KEY AUTOINCREMENT,
    fund_key INTEGER NOT NULL,
    date_key INTEGER NOT NULL,

    return_1m DECIMAL(8,2),
    return_3m DECIMAL(8,2),
    return_6m DECIMAL(8,2),
    return_1y DECIMAL(8,2),
    return_3y DECIMAL(8,2),
    return_5y DECIMAL(8,2),

    expense_ratio DECIMAL(5,2),
    sharpe_ratio DECIMAL(8,4),

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    UNIQUE(fund_key, date_key)
);


-- FACT AUM


CREATE TABLE fact_aum (
    aum_key INTEGER PRIMARY KEY AUTOINCREMENT,
    fund_key INTEGER NOT NULL,
    date_key INTEGER NOT NULL,

    aum_crore DECIMAL(18,2) NOT NULL,

    FOREIGN KEY (fund_key)
        REFERENCES dim_fund(fund_key),

    FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    UNIQUE(fund_key, date_key)
);