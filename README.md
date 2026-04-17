# E-commerce Analytics Project (dbt + BigQuery + Tableau)

## Overview
This project builds an end-to-end analytics workflow on the Olist e-commerce dataset.

The objective is to analyze revenue performance, customer behavior, and operational efficiency using a modern data stack.

The project includes:
- data modeling with dbt
- dimensional modeling (facts & dimensions)
- business-driven analytics
- Tableau dashboards (in progress)
- AI query interface (planned)

---

## Tech Stack
- **BigQuery** → data warehouse  
- **dbt** → data transformation & modeling  
- **Tableau Public** → data visualization  
- **Python (planned)** → AI / MCP component  

---

## Data Model

The project follows a **dimensional modeling approach (star schema)** with two fact tables.

### Staging Layer
- `stg_customers` → 1 row per `customer_id`
- `stg_orders_` → 1 row per `order_id`
- `stg_order_items` → 1 row per (`order_id`, `order_item_id`)
- `stg_order_payments` → 1 row per `order_id`
- `stg_products` → 1 row per `product_id`


### Intermediate Layer
- `int_orders_enhanced` → enriched order-level dataset combining:
  - customer attributes
  - aggregated item & payment metrics
  - delivery and operational metrics

### Dimensions
- `dim_customers` → customer information (1 row per `customer_id`)
- `dim_products` → product attributes (1 row per `product_id`)
- `dim_date` → calendar table (1 row per day)

### Fact Tables
- `fct_orders` → one row per `order_id`
- `fct_order_items` → one row per (`order_id`, `order_item_id`)

---

## Data Model Overview

The schema is designed to support both order-level and item-level analysis:

- `fct_orders` → used for revenue and customer-level analysis  
- `fct_order_items` → used for product and basket-level analysis  

Shared dimensions:
- `dim_customers` connects to both fact tables  
- `dim_date` connects to both fact tables  
- `dim_products` connects to `fct_order_items`  

This structure enables flexible analysis while maintaining a clean and scalable model.

---

## KPI Definitions

### Revenue Metrics

**Gross Merchandise Value (GMV)**

SUM(order_gmv)

Total value of orders, including item price and freight.

---

**Total Orders**

COUNT(order_id)

Total number of completed orders (excluding canceled/unavailable).

---

**Average Order Value (AOV)**

SUM(order_gmv) / COUNT(order_id)

Average revenue generated per order.

---

### Basket Metrics

**Average Items per Order**

AVG(item_count)

Average number of items per order.

---

**Item GMV**

SUM(item_gmv)

Total value at item level (price + freight).

---

### Operational Metrics

**Average Delivery Time**

AVG(days_to_deliver)

Average number of days between purchase and delivery.

---

**Delivery Delay**

AVG(delivery_delay_days)

Difference between actual and estimated delivery time.

- Positive → delayed delivery  
- Negative → early delivery  

---

## Key Business Questions

### Revenue Analysis
- How does GMV trend over time?
- Which customer states generate the most revenue?
- Which product categories contribute the most GMV?
- What is the average order value over time?

### Customer & Behavioral Analysis
- What is the distribution of orders per customer?
- Are customers repeat buyers or one-time purchasers?
- What is the average basket size?

### Operational Analysis
- How long does delivery take?
- Are deliveries delayed compared to estimates?
- Do delays vary by region?

---

## Data Quality

The project includes data quality checks performed in DBT to ensure consistency:

- primary key tests (unique + not null)
- relationship tests across models
- accepted values tests for order status
- composite key validation for order items


---

## Visualization

Tableau dashboards are used to analyze:

overall business performance

revenue drivers

customer behavior

operational metrics


### Dashboard Preview

Executive Overview
![alt text](https://github.com/astonaIT/portfolio_project/blob/6a6aaaf6e611e9c228596e7e47e59b4e22460dd9/assets/1.%20ExecutiveOverview.png "dashboard 1")

Revenue Drivers
![alt text](https://raw.githubusercontent.com/astonaIT/portfolio_project/main/assets/2.RevenueDrivers.png "dashboard 2")

Customers & Operations
![alt text](https://raw.githubusercontent.com/astonaIT/portfolio_project/main/assets/3.Customers&Operations.png "dashboard 3")


### Key Insights

- ~97% of customers are one-time buyers, indicating low retention
- GMV is concentrated in a few key states (e.g. São Paulo)
- A small number of product categories drives the majority of revenue
- Deliveries are generally early vs estimated, though performance varies by region

---
### Analytical Approach

The project was designed to:

- separate order-level vs item-level analysis
- avoid aggregation issues using proper grain modeling
- ensure data quality via dbt tests
- build dashboards focused on business questions, not just visuals

---

### Notes

Due to Tableau Public limitations, data is exported via Google Sheets as a bridge between BigQuery and Tableau.

---

AI Component (Planned)

A lightweight AI interface will allow users to query the dataset using natural language.

Example queries:

"Which states generate the most revenue?"

"How has GMV evolved over time?"


The system will translate user input into SQL queries executed on BigQuery.



