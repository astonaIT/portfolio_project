# E-commerce Analytics Project (dbt + BigQuery + Tableau)

## Overview
This project builds an end-to-end analytics workflow on the Olist e-commerce dataset.

The goal is to analyze revenue performance, customer behavior, and operational efficiency using a modern data stack.

The project covers:
- data modeling with dbt
- dimensional modeling (facts & dimensions)
- business-focused analytics
- visualization (Tableau)
- (planned) AI interface for natural language querying

---

## Tech Stack
- **BigQuery** → data warehouse
- **dbt** → data transformation & modeling
- **Tableau Public** → data visualization
- **Python (planned)** → AI / MCP component

---

## Data Model

The project follows a dimensional modeling approach.

### Dimensions
- `dim_customers` → customer information (1 row per customer_id)
- `dim_products` → product attributes (1 row per product_id)
- `dim_date` → calendar table (1 row per day)

### Fact Tables
- `fct_orders` → one row per order  
- `fct_order_items` → one row per order item (order_id + order_item_id)

### Intermediate Layer
- `int_orders_enhanced` → enriched order-level data including:
  - delivery metrics
  - order value (GMV)
  - customer context

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

The project includes several data quality checks performed in DBT:

- primary key tests (unique + not null)
- relationship tests across models
- accepted values tests for order status
- composite key validation for order items

These tests ensure consistency across the data model.

---
