# 📊 Sales Analysis SQL Project

## 📝 Project Description

This project is a beginner-level SQL-based sales analysis, aimed at exploring real-world business questions using structured relational data. The database is organized under two main schemas — `production` and `sales` — and includes 9 interrelated tables.

The project includes creating the database, cleaning the data, and running SQL queries to extract business insights. A total of **23 questions** were answered using advanced SQL techniques including joins, aggregation, and filtering.

---

## 📂 Project Structure

The project follows these **three main steps**:

1. **Database Setup** – Creating and populating tables under appropriate schemas.
2. **Data Cleaning** – Handling duplicates, null values, and standardizing data.
3. **Exploratory Data Analysis (EDA)** – Writing SQL queries to answer business questions.

---

## 🎯 Objectives

- ✅ Create and populate a structured SQL database using provided datasets
- ✅ Perform thorough data cleaning and validation
- ✅ Use SQL to answer key business questions
- ✅ Practice writing complex queries with joins and aggregations

---

## 🧰 Tools & Technologies

- **SQL Server**
- **SSMS (SQL Server Management Studio)**
- SQL Queries (SELECT, JOIN, GROUP BY, ORDER BY, etc.)
- Aggregate Functions (`SUM`, `COUNT`, `AVG`, etc.)

---

## 🗃️ Database Overview

### Schemas and Tables:

#### 🏭 `production` schema:
- `brands` – Contains brand information for each product
- `categories` – Product categories (e.g., bikes, clothing)
- `products` – Detailed product info (name, brand, category, price)
- `stocks` – Inventory data across different stores

#### 🛒 `sales` schema:
- `customers` – Customer details
- `order_items` – Line items in each order (product, quantity, price)
- `orders` – Main order records (date, customer, staff)
- `staffs` – Employee information
- `stores` – Store details where orders were placed

---

## 🧹 Data Cleaning

Key cleaning steps included:

- Removing **duplicate records** (e.g., in `orders` or `order_items`)
- Handling **NULL values** in important fields (e.g., product name, email)
- **Standardizing** inconsistent text formats
- Validating foreign key relationships between tables

---

## 📈 Exploratory Data Analysis (EDA)

Using SQL, I explored:

- Top-selling products
- Monthly and yearly sales trends
- Sales by store, staff, and customer
- Best and worst performing categories
- Customer behavior insights (e.g., repeat customers)

A total of **23 business questions** were answered.

Example questions:

- 🏆 What are the top 5 best-selling products?
- 🗓️ Which month recorded the highest total sales?
- 🧑‍💼 Which staff member processed the most orders?
- 🛍️ Which store had the highest revenue?
- ❌ What is the least liked product category?

---

## 📎 Folder Structure

```bash
Sales-Analysis-SQL-Project/
│
├── README.md                            # Project description
├── Sales_Analysis_Database.sql          # SQL script to create/populate DB
├── Data_Cleaning.sql                    # SQL scripts for data cleaning
├── EDA_and_Business_Questions.sql       # SQL queries for EDA & questions
├── Project_Questions.pdf (optional)     # Business questions answered

