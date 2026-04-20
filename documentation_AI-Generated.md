# 📦 Olist E-Commerce Analytics Dashboard

> A multi-dashboard Tableau Public project analysing the Brazilian Olist e-commerce dataset across revenue performance, customer behaviour, and operational/logistics metrics.

🔗 **[View Live on Tableau Public](https://public.tableau.com/app/profile/andrea.stona5757/viz/OlistDatasetPortfolioDashboard/Olistdataset-E-CommerceDashboard)**

---

## Table of Contents

- [Project Overview](#project-overview)
- [Dataset](#dataset)
- [Data Model](#data-model)
- [Dashboard Structure](#dashboard-structure)
- [Key Metrics & Calculated Fields](#key-metrics--calculated-fields)
- [Technical Details](#technical-details)
- [How to Use](#how-to-use)
- [Author](#author)

---

## Project Overview

This project explores the publicly available **Olist dataset**, a real-world Brazilian e-commerce marketplace dataset covering ~100,000 orders placed between 2016 and 2018. The goal is to surface actionable insights across three business domains:

- **Revenue** — GMV trends, AOV, and category/regional breakdowns
- **Customers** — purchase frequency, one-time vs. repeat buyer segmentation
- **Operations** — delivery performance, delay distribution, and fulfilment speed

The workbook is built as a portfolio piece demonstrating proficiency in data modelling (star schema), calculated fields (including LOD expressions), and dashboard design across multiple audience types (executive, analytical, operational).

---

## Dataset

| Property | Details |
|---|---|
| **Source** | [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — Kaggle |
| **Geography** | Brazil |
| **Period** | 2016 – 2018 |
| **Volume** | ~100,000 orders |
| **Licence** | CC BY-NC-SA 4.0 |

The dataset was made available by **Olist**, the largest department store in Brazilian marketplaces, and includes orders, customers, products, sellers, payments, and delivery information.

---

## Data Model

The workbook uses a **star schema** with `fct_order_items` as the central fact table, joined to one supporting fact table and three dimension tables.

```
                    ┌─────────────────┐
                    │  dim_customers  │
                    │─────────────────│
                    │ customer_id     │
                    │ customer_city   │
                    │ customer_state  │
                    │ customer_zip    │
                    └────────┬────────┘
                             │
┌──────────────┐    ┌────────▼──────────┐    ┌──────────────────┐
│  dim_dates   │    │  fct_order_items  │    │   dim_products   │
│──────────────│    │───────────────────│    │──────────────────│
│ date         ◄────│ order_id          │────► product_id       │
│ day          │    │ order_item_id     │    │ product_category │
│ month        │    │ product_id        │    │ product_height   │
│ day_of_week  │    │ customer_id       │    │ description_len  │
│ is_weekend   │    │ price             │    └──────────────────┘
└──────────────┘    │ item_gmv          │
                    │ item_count        │
                    │ freight_value     │    ┌──────────────────┐
                    │ order_gmv         │    │   fct_orders     │
                    │                   │    │──────────────────│
                    └────────┬──────────┘    │ order_id         │
                             │               │ order_status     │
                             └───────────────► order_date       │
                                             │ days_to_deliver  │
                                             │ delivery_delay   │
                                             │ is_delivered     │
                                             └──────────────────┘
```

### Table Descriptions

**`fct_order_items`** *(central fact)*
The grain is one row per order line item. Contains pricing (`price`, `item_gmv`, `freight_value`), item-level aggregates (`item_count`), and order-level GMV (`order_gmv`).

**`fct_orders`** *(supporting fact)*
Order-level operational data. Contains delivery status (`is_delivered`), fulfilment speed (`days_to_deliver`), and delivery variance (`delivery_delay_days` — negative = early, positive = late).

**`dim_customers`**
Customer master with geographic detail at city, state, and zip code level. Joined on `customer_id` and `customer_unique_id` (the latter persists across repeat purchases).

**`dim_products`**
Product catalogue with category name and physical attributes (height, description length).

**`dim_dates`**
Date spine providing time-based dimensions: date, day, month, day of week, and a weekend flag for temporal analysis.

---

## Dashboard Structure

The workbook contains **4 dashboards** and **13 worksheets**.

### 1. 🏠 Executive Overview
*Audience: Leadership / C-suite*

Top-line KPI summary providing an at-a-glance view of business health.

| KPI | Description |
|---|---|
| Total GMV | Aggregate Gross Merchandise Value across all orders |
| Total Orders | Count of distinct orders placed |
| AOV | Average Order Value (GMV ÷ distinct orders) |
| Avg Items per Order | Mean number of line items per order |

### 2. 💰 Revenue Drivers
*Audience: Commercial / GTM teams*

Breaks down GMV by the two primary dimensions that explain revenue composition:

- **GMV by Product Category** — ranked bar chart with % of total contribution, filterable by category. Identifies top-performing and underperforming verticals.
- **GMV by Brazilian State** — geographic breakdown showing regional revenue concentration and growth opportunities.

### 3. 👥 Customers & Operations
*Audience: CRM / Growth / Ops teams*

Covers customer purchase behaviour and fulfilment performance:

- **Customer Order Frequency** — distribution of orders per customer, segmented into *One-time* vs *Repeat* buyers using a FIXED LOD expression.
- **Delivery Performance** — distribution of orders across 7 delay buckets (from "10+ days early" to "10+ days late"), giving a full picture of fulfilment variance.
- **Delivery Time** — average days to deliver over time, enabling trend identification.

### 4. 📊 E-Commerce Dashboard *(Default View)*
*Audience: Analysts / General*

The composite main dashboard combining time-series views for GMV, order volume, and AOV alongside summary KPIs. Serves as the primary entry point for exploratory analysis, with a year-month filter for time scoping.

---

## Key Metrics & Calculated Fields

### Core KPIs

| Field | Formula | Description |
|---|---|---|
| `Total GMV` | `SUM([order_gmv])` | Total Gross Merchandise Value |
| `Total Orders` | `COUNTD([order_id])` | Distinct order count |
| `Avg of Value` (AOV) | `SUM([order_gmv]) / COUNTD([order_id])` | Average order value |
| `Avg Items per Order` | `AVG([item_count])` | Mean items per order |
| `Avg Delivery Days` | `AVG([days_to_deliver])` | Mean fulfilment time |

### Share Calculations

| Field | Formula | Description |
|---|---|---|
| `% of Total Sales` | `SUM([order_gmv]) / TOTAL(SUM([order_gmv]))` | Order GMV as % of grand total |
| `% of Item Sales` | `SUM([item_gmv]) / TOTAL(SUM([item_gmv]))` | Item GMV as % of grand total |

### Customer Segmentation

| Field | Formula | Description |
|---|---|---|
| `Orders per Customer` | `{ FIXED [customer_unique_id] : COUNTD([order_id]) }` | LOD: orders per unique customer |
| `Customer group` | `IF [orders per customer] = 1 THEN "One-time" ELSE "Repeat" END` | One-time vs repeat buyer flag |

### Delivery Performance

| Field | Formula | Description |
|---|---|---|
| `Delay (absolute)` | `- [delivery_delay_days]` | Absolute delay magnitude |
| `delays group` | Bucketed IF/ELSEIF on `delivery_delay_days` | Categorical delay band (7 buckets from "10+ days early" to "10+ days late") |
| `Calculation1` | `IF AVG([delivery_delay_days]) > 0 THEN "Late" ...` | Late / On Time / Early label |

---

## Technical Details

| Property | Value |
|---|---|
| **Tool** | Tableau Desktop / Tableau Public |
| **Tableau Version** | 2026.1 |
| **Workbook Build** | 20261.26.0226.1626 |
| **Data Source Type** | Federated (Multiple Connections) |
| **Extract Format** | `.hyper` |
| **Extract Size** | ~35.4 MB |
| **Total Fields** | 74 (60 source + 14 calculated) |
| **LOD Expressions** | 1 (`Orders per Customer` — FIXED) |
| **Parameters** | None |
| **Platform** | Windows |

---

## How to Use

### Viewing the Dashboard

The workbook is publicly available on Tableau Public — no software installation required:

👉 [Open in Tableau Public](https://public.tableau.com/app/profile/andrea.stona5757/viz/OlistDatasetPortfolioDashboard/Olistdataset-E-CommerceDashboard)

Navigate between the four dashboards using the tabs at the bottom of the view.

### Downloading the Workbook

1. Open the Tableau Public link above
2. Click the **download** icon (bottom toolbar) → select **Tableau Workbook**
3. Open in Tableau Desktop (version 2026.1 or later recommended)

### Accessing the Raw Data

The underlying dataset is publicly available on Kaggle:

👉 [Olist Brazilian E-Commerce Dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The data model was pre-processed and structured into a star schema before loading into Tableau. Source tables used:

- `olist_orders_dataset.csv` → `fct_orders`
- `olist_order_items_dataset.csv` → `fct_order_items`
- `olist_customers_dataset.csv` → `dim_customers`
- `olist_products_dataset.csv` → `dim_products`
- Custom date spine → `dim_dates`

---

## Author

**Andrea Stona**
Senior Business Analyst · Revenue & GTM Analytics

🔗 [Tableau Public Profile](https://public.tableau.com/app/profile/andrea.stona5757)

---

*Built with the [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — licensed under CC BY-NC-SA 4.0.*
