# 🛒 E-Commerce Sales, Returns & Customer Behavior Analysis

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.10+-blue.svg?logo=python&logoColor=white)](https://www.python.org/)
[![SQL](https://img.shields.io/badge/SQL-MySQL%2FPostgreSQL-orange.svg?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-yellow.svg?logo=powerbi&logoColor=black)](https://powerbi.microsoft.com/)

An end-to-end data analytics project performing comprehensive sales performance evaluation, product return diagnosis, customer demographics segmentation, and financial profitability analysis using **Python**, **SQL**, and **Power BI**.

---

## 📌 Executive Summary

Understanding customer purchase patterns, revenue growth drivers, and return behavior is critical for e-commerce profitability. This project presents a full analytics pipeline to analyze multi-channel e-commerce order transactions, isolate top drivers of product returns, assess regional and category profit margins, and evaluate customer buying habits.

### Key Objectives
1. **Sales & Revenue Optimization**: Measure Gross Sales, Net Revenue, Average Order Value (AOV), and Month-over-Month (MoM) growth metrics.
2. **Product Return Analysis**: Quantify return rates by category, analyze primary return reasons, and examine the correlation between discount levels and customer return rates.
3. **Customer Segmentation**: Evaluate spending habits across age groups, gender demographics, and regional distributions.
4. **Interactive BI Reporting**: Provide executive decision-makers with an interactive Power BI dashboard for dynamic data exploration.

---

## 📂 Repository Structure

```guitree
├── E_commerce_Sales,_Returns_and_Customer_Analysis_In_Python.ipynb   # Python EDA, cleaning & analytics notebook
├── e-commerce analysis in sql.sql                                    # SQL queries for database schema, KPIs & trends
├── e commerce.pbix                                                   # Power BI interactive report & dashboard
├── Kaggle_Ecommerce Data.csv                                         # Raw e-commerce transaction dataset
├── cleaned_ecommerce.csv                                             # Processed & feature-engineered dataset
├── LICENSE                                                           # MIT License
└── README.md                                                         # Project documentation
```

### Detailed File Descriptions

| File Name | Description | Tools / Tech Used |
| :--- | :--- | :--- |
| **`E_commerce_Sales,...ipynb`** | End-to-end Python notebook covering raw data parsing, data hygiene, missing value handling, feature extraction (`net_sales`, `delivery_days`, `is_returned`), statistical analysis, and Seaborn/Matplotlib visualizations. | `Pandas`, `NumPy`, `Seaborn`, `Matplotlib` |
| **`e-commerce analysis in sql.sql`** | SQL script establishing the database schema (`ecommerce.orders`), indexing strategies, aggregate KPIs, MoM growth window functions (`LAG()`), and group-by aggregations. | `MySQL`, `PostgreSQL`, `Standard SQL` |
| **`e commerce.pbix`** | Complete Power BI report containing dynamic visuals, slicers (Category, Region, Date), visual KPI cards, cross-filtering, and return diagnostic breakdown. | `Power BI Desktop`, `DAX` |
| **`Kaggle_Ecommerce Data.csv`** | Raw transactional dataset imported from Kaggle containing raw dates, order attributes, customer IDs, and return logs. | Raw Data |
| **`cleaned_ecommerce.csv`** | Standardized, production-ready CSV formatted with calculated fields (`total_amount`, `shipping_cost`, `profit_margin`, `is_returned`). | Structured CSV |

---

## 📊 Dataset Schema & Metrics

The `cleaned_ecommerce.csv` dataset contains transactional order details defined by the following schema:

```sql
CREATE TABLE orders (
    order_id        VARCHAR(20),
    customer_id     VARCHAR(20),
    product_id      VARCHAR(20),
    category        VARCHAR(50),
    price           DECIMAL(10,2),
    discount        DECIMAL(4,2),
    quantity        INT,
    payment_method  VARCHAR(30),
    order_date      DATE,
    delivered_date  DATE,
    region          VARCHAR(30),
    returned        VARCHAR(5),
    request_date    VARCHAR(20),
    return_reason   VARCHAR(50),
    total_amount    DECIMAL(10,2),
    shipping_cost   DECIMAL(10,2),
    profit_margin   DECIMAL(10,2),
    customer_age    INT,
    customer_gender VARCHAR(20),
    order_month     VARCHAR(10),
    delivery_days   INT,
    is_returned     INT,
    net_sales       DECIMAL(10,2)
);
```

---

## 🔍 SQL Analytics & Key Queries

The project contains high-value SQL analytical queries designed to answer core business questions:

### 1. Overall Key Performance Indicators (KPIs)
```sql
SELECT 
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount)) AS gross_sales,
    ROUND(SUM(net_sales)) AS net_sales,
    ROUND(AVG(total_amount), 2) AS average_order_value,
    ROUND(AVG(is_returned) * 100, 2) AS return_percentage
FROM orders;
```

### 2. Category Sales & Profitability Analysis
```sql
SELECT 
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_amount)) AS gross_sales,
    ROUND(SUM(profit_margin)) AS total_profit,
    ROUND(AVG(is_returned) * 100, 2) AS return_percentage
FROM orders
GROUP BY category
ORDER BY gross_sales DESC;
```

### 3. Impact of Discount Levels on Product Return Rates
```sql
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount (0%)'
        WHEN discount <= 0.10 THEN 'Low Discount (1-10%)'
        ELSE 'High Discount (>10%)'
    END AS discount_group,
    COUNT(*) AS total_orders,
    ROUND(AVG(is_returned) * 100, 2) AS return_percentage
FROM orders
GROUP BY discount_group;
```

### 4. Month-over-Month (MoM) Growth Rate Calculation
```sql
SELECT 
    order_month,
    ROUND(SUM(total_amount)) AS current_month_sales,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY order_month))
        * 100.0 / LAG(SUM(total_amount)) OVER (ORDER BY order_month), 
        1
    ) AS growth_percentage
FROM orders
GROUP BY order_month
ORDER BY order_month;
```

---

## 🐍 Python Analytics Workflow

The Python notebook (`E_commerce_Sales,_Returns_and_Customer_Analysis_In_Python.ipynb`) performs structured data science exploratory workflows:

1. **Data Preprocessing & Cleaning**:
   - Date format unification across order and delivery logs.
   - Imputation of missing request dates and return reasons for non-returned orders.
   - Calculation of exact order-to-delivery fulfillment lead times (`delivery_days`).

2. **Exploratory Data Analysis (EDA)**:
   - **Distribution Analysis**: Price points, order quantities, and profit margin distributions.
   - **Correlation Heatmaps**: Investigating relationships between shipping cost, discount percentage, delivery days, and return probabilities.
   - **Customer Demographics**: Spending distribution across age brackets and genders.

3. **Key Findings**:
   - Higher discount bands exhibit a noticeable rise in return rates, indicating potential impulse buying or value perception mismatches.
   - Delivery time latency correlates positively with return rates in specific high-value categories like Electronics and Apparel.

---

## 📊 Power BI Dashboard Highlights

The **Power BI Dashboard (`e commerce.pbix`)** delivers executive-level interactivity:

- **Executive Overview Page**: Cards for Total Sales, Net Revenue, Total Orders, AOV, and Return Rate.
- **Regional & Category Breakdown**: Matrix visual comparing sales vs. profit margins across North, South, East, and West regions.
- **Return Diagnostics Tab**: Tree map and Pareto chart highlighting top reasons for returns (e.g., Defective, Size Mismatch, Wrong Item, Delayed Delivery).
- **Customer Insights Tab**: Demographics breakdown by age cohort and preferred payment methods (UPI, Credit Card, Cash on Delivery).

---

## 💡 Strategic Business Recommendations

1. **Mitigate Discount-Driven Returns**: Re-evaluate heavy promotional strategies (>10% discounts) that trigger high return volumes without contributing significantly to net profit margins.
2. **Optimize Logistics & Delivery Schedules**: Reduce fulfillment lead times for high-return product categories to minimize cancellation and return rates.
3. **Address Top Return Reasons**: Improve product description accuracy, sizing charts, and quality checks based on categorical return patterns.
4. **Target High-Value Customer Cohorts**: Focus retention strategies on top spending customer segments identified through RFM & demographic analysis.

---

## 🚀 Getting Started & Usage

### Prerequisites
- **Python**: Python 3.8+ with `pandas`, `matplotlib`, `seaborn`, `jupyter` installed.
- **Database**: Any standard SQL Engine (MySQL, PostgreSQL, SQLite).
- **Power BI**: Microsoft Power BI Desktop (for viewing `.pbix`).

### Running Python Notebook
```bash
git clone https://github.com/scriptedbyshivam/domain-verse-1.0.git
cd domain-verse-1.0
jupyter notebook E_commerce_Sales,_Returns_and_Customer_Analysis_In_Python.ipynb
```

### Running SQL Queries
1. Import `cleaned_ecommerce.csv` or `Kaggle_Ecommerce Data.csv` into your SQL database.
2. Execute `e-commerce analysis in sql.sql` in your SQL Workbench or DBeaver.

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

---

### 👤 Author
**Shivam Maurya**  
GitHub: [@scriptedbyshivam](https://github.com/scriptedbyshivam)
