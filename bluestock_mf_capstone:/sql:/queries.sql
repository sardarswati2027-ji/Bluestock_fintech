-- 1. TOP 5 FUNDS BY AUM (Assets Under Management)
SELECT 
    fund_id,
    fund_name,
    category,
    assets_under_management_cr AS aum_in_crores
FROM 
    funds
ORDER BY 
    assets_under_management_cr DESC
LIMIT 5;


-- 2. AVERAGE NAV PER MONTH

SELECT 
    fund_id,
    EXTRACT(YEAR FROM nav_date) AS nav_year,
    EXTRACT(MONTH FROM nav_date) AS nav_month,
    ROUND(AVG(nav_value), 2) AS avg_monthly_nav
FROM 
    nav_history
GROUP BY 
    fund_id, 
    EXTRACT(YEAR FROM nav_date), 
    EXTRACT(MONTH FROM nav_date)
ORDER BY 
    fund_id, 
    nav_year DESC, 
    nav_month DESC;


-- 3. SIP YEAR-OVER-YEAR (YoY) GROWTH

WITH yearly_sip AS (    
    SELECT 
        EXTRACT(YEAR FROM start_date) AS sip_year,
        SUM(monthly_installment_amount) AS total_sip_volume
    FROM 
        sip_accounts
    WHERE 
        status = 'ACTIVE'
    GROUP BY 
        EXTRACT(YEAR FROM start_date)
)
SELECT 
    curr.sip_year,
    curr.total_sip_volume AS current_year_volume,
    prev.total_sip_volume AS previous_year_volume,
    ROUND(((curr.total_sip_volume - prev.total_sip_volume) / prev.total_sip_volume) * 100, 2) AS yoy_growth_percentage
FROM 
    yearly_sip curr
LEFT JOIN 
    yearly_sip prev ON curr.sip_year = prev.sip_year + 1
ORDER BY 
    curr.sip_year DESC;


-- 4. TOTAL TRANSACTIONS BY STATE

SELECT 
    i.state,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_invested_amount
FROM 
    transactions t
JOIN 
    investors i ON t.investor_id = i.investor_id
GROUP BY 
    i.state
ORDER BY 
    total_invested_amount DESC;


-- 5. COST-EFFECTIVE FUNDS (Expense Ratio < 1%)

SELECT 
    fund_id,
    fund_name,
    category,
    expense_ratio_percentage
FROM 
    funds
WHERE 
    expense_ratio_percentage < 1.0
ORDER BY 
    expense_ratio_percentage ASC;


-- 6. INVESTOR CHURN ANALYSIS (Inactive/Cancelled SIPs)

SELECT 
    f.fund_id,
    f.fund_name,
    COUNT(s.sip_id) AS cancelled_sip_count,
    SUM(s.monthly_installment_amount) AS lost_monthly_revenue
FROM 
    sip_accounts s
JOIN 
    funds f ON s.fund_id = f.fund_id
WHERE 
    s.status = 'CANCELLED' AND s.end_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY)
GROUP BY 
    f.fund_id, f.fund_name
ORDER BY 
    cancelled_sip_count DESC
LIMIT 5;


-- 7. FUND PERFORMANCE VS. BENCHMARK ROLLING RETURN (Alpha Generation)

SELECT 
    f.fund_id,
    f.fund_name,
    f.category,
    f.trailing_12m_return AS fund_return,
    b.benchmark_12m_return AS benchmark_return,
    (f.trailing_12m_return - b.benchmark_12m_return) AS alpha_generated
FROM 
    funds f
JOIN 
    category_benchmarks b ON f.category = b.category
WHERE 
    (f.trailing_12m_return - b.benchmark_12m_return) > 0
ORDER BY 
    alpha_generated DESC;


-- 8. HIGH-NET-WORTH INDIVIDUAL (HNWI) CONCENTRATION RISK

SELECT 
    t.fund_id,
    f.fund_name,
    COUNT(DISTINCT t.investor_id) AS large_investor_count,
    SUM(t.current_value) AS aggregate_hnw_value,
    f.assets_under_management_cr * 10000000 AS total_fund_aum_absolute,
    ROUND((SUM(t.current_value) / (f.assets_under_management_cr * 10000000)) * 100, 2) AS concentration_percentage
FROM 
    investor_holdings t
JOIN 
    funds f ON t.fund_id = f.fund_id
WHERE 
    t.current_value >= 5000000 
GROUP BY 
    t.fund_id, f.fund_name, f.assets_under_management_cr
HAVING 
    concentration_percentage > 15.0 
ORDER BY 
    concentration_percentage DESC;


-- 9. REDEMPTION-TO-INFLOW RATIO (Liquidity Stress Test)

SELECT 
    fund_id,
    SUM(CASE WHEN transaction_type = 'REDEMPTION' THEN amount ELSE 0 END) AS total_outflow,
    SUM(CASE WHEN transaction_type = 'PURCHASE' THEN amount ELSE 0 END) AS total_inflow,
    ROUND(
        SUM(CASE WHEN transaction_type = 'REDEMPTION' THEN amount ELSE 0 END) / 
        NULLIF(SUM(CASE WHEN transaction_type = 'PURCHASE' THEN amount ELSE 0 END), 0), 2
    ) AS redemption_inflow_ratio
FROM 
    transactions
WHERE 
    transaction_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
GROUP BY 
    fund_id
ORDER BY 
    redemption_inflow_ratio DESC;


-- 10. DEMOGRAPHIC ASSET ALLOCATION (Age-Group Preferences)

SELECT 
    CASE 
        WHEN i.age < 30 THEN 'Under 30 (Gen Z/Young Millennial)'
        WHEN i.age BETWEEN 30 AND 45 THEN '30-45 (Core Professionals)'
        WHEN i.age BETWEEN 46 AND 60 THEN '46-60 (Pre-Retirement)'
        ELSE 'Above 60 (Retirees)'
    END AS investor_age_group,
    f.category AS preferred_fund_category,
    COUNT(t.transaction_id) AS total_investments,
    SUM(t.amount) AS total_capital_allocated
FROM 
    transactions t
JOIN 
    investors i ON t.investor_id = i.investor_id
JOIN 
    funds f ON t.fund_id = f.fund_id
WHERE 
    t.transaction_type = 'PURCHASE'
GROUP BY 
    investor_age_group, f.category
ORDER BY 
    investor_age_group, total_capital_allocated DESC;