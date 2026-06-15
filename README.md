# Football Ticket Booking System

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
3. [Database Schema](#database-schema)
4. [Sample Data](#sample-data)
5. [SQL Queries](#sql-queries)
6. [How to Use This on Your PC](#how-to-use-this-on-your-pc)

---

## Project Overview

This project implements a **Football Ticket Booking System** using a relational database. The system manages users, football matches, and ticket bookings — enforcing data integrity through primary keys, foreign keys, and check constraints.

| Item | Detail |
|---|---|
| **Database** | PostgreSQL |
| **Tables** | Users, Matches, Bookings |
| **Total Queries** | 7 |

---

## Entity Relationship Diagram (ERD)

<p align="center">
  <img src="https://github.com/user-attachments/assets/55c614a5-6451-492d-bed2-19aad6522ad6" alt="ERD Diagram" />
  <br/>
  <em>Figure 1 — ERD for the Football Ticket Booking System using Crow's Foot notation.</em>
</p>

### Relationships

| Relationship | Type | Description |
|---|---|---|
| Users → Bookings | One-to-Many | One user can place many bookings |
| Matches → Bookings | One-to-Many | One match can have many booking records |
| Users + Matches via Bookings | Logical One-to-One | Each booking row maps exactly one user to one match for one seat |

---

## Database Schema

### Table 1 — Users

| user_id | full_name | email | role | phone_number |
|---|---|---|---|---|
| 1 | Tanvir Rahman | tanvir@mail.com | Football Fan | +8801711111111 |
| 2 | Asif Haque | asif@mail.com | Football Fan | +8801722222222 |
| 3 | Sajjad Rahman | sajjad@mail.com | Ticket Manager | +8801733333333 |
| 4 | Jannat Ara | jannat@mail.com | Football Fan | NULL |

---

### Table 2 — Matches

| match_id | fixture | tournament_category | base_ticket_price | match_status |
|---|---|---|---|---|
| 101 | Real Madrid vs Barcelona | Champions League | 150.00 | Available |
| 102 | Man City vs Liverpool | Premier League | 120.00 | Selling Fast |
| 103 | Bayern Munich vs PSG | Champions League | 130.00 | Available |
| 104 | AC Milan vs Inter Milan | Serie A | 90.00 | Sold Out |
| 105 | Juventus vs Roma | Serie A | 80.00 | Available |

---

### Table 3 — Bookings

| booking_id | user_id | match_id | seat_number | payment_status | total_cost |
|---|---|---|---|---|---|
| 501 | 1 | 101 | A-12 | Confirmed | 150.00 |
| 502 | 1 | 102 | B-04 | Confirmed | 120.00 |
| 503 | 2 | 101 | A-13 | Confirmed | 150.00 |
| 504 | 2 | 101 | NULL | NULL | 150.00 |
| 505 | 3 | 102 | C-20 | Pending | 120.00 |

---

## Create Tables Using This

### Create Users Table

```sql
-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id      INT,
    full_name    VARCHAR(20),
    email        VARCHAR(30),
    role         VARCHAR(20),
    phone_number VARCHAR(20),

    PRIMARY KEY (user_id),
    UNIQUE      (email),
    CHECK       (role = 'Ticket Manager' OR role = 'Football Fan')
);
```

---

### Create Matches Table

```sql
CREATE TABLE Matches (
    match_id             INT,
    fixture              VARCHAR(30),
    tournament_category  VARCHAR(20),
    base_ticket_price    DECIMAL(10, 2),
    match_status         VARCHAR(20),

    PRIMARY KEY (match_id),
    CHECK       (base_ticket_price >= 0),
    CHECK       (match_status = 'Available'    OR
                 match_status = 'Selling Fast' OR
                 match_status = 'Sold Out'     OR
                 match_status = 'Postponed')
);
```

---

### Create Bookings Table

```sql
CREATE TABLE Bookings (
    booking_id     INT,
    user_id        INT,
    match_id       INT,
    seat_number    VARCHAR(20),
    payment_status VARCHAR(20),
    total_cost     DECIMAL(10, 2),

    PRIMARY KEY (booking_id),
    FOREIGN KEY (user_id)  REFERENCES Users(user_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    CHECK       (total_cost >= 0),
    CHECK       (payment_status = 'Pending'   OR
                 payment_status = 'Confirmed' OR
                 payment_status = 'Cancelled' OR
                 payment_status = 'Refunded')
);
```

---

## Sample Data

### Users

```sql
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan',   '+8801711111111'),
(2, 'Asif Haque',   'asif@mail.com',   'Football Fan',   '+8801722222222'),
(3, 'Sajjad Rahman','sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara',   'jannat@mail.com', 'Football Fan',   NULL);
```

---

### Matches

```sql
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool',    'Premier League',   120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG',     'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan',  'Serie A',           90.00, 'Sold Out'),
(105, 'Juventus vs Roma',         'Serie A',           80.00, 'Available');
```

---

### Bookings

```sql
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101,  NULL,   NULL,       150.00),
(505, 3, 102, 'C-20', 'Pending',   120.00);
```

---

## SQL Queries

 **The full query file is available in this repository.**
 Download **`Query.sql`** from GitHub and run it in Beekeeper Studio or any PostgreSQL client.

---

## How to Use This on Your PC

Follow these steps to set up the database locally and run all queries on your own machine.

---

### ✅ Step 1 — Install Required Tools

You need two things installed on your PC:

| Tool | Purpose | Download |
|---|---|---|
| **PostgreSQL** | The database engine | [postgresql.org/download](https://www.postgresql.org/download/) |
| **Beekeeper Studio** | GUI to manage and query the database | [beekeeperstudio.io](https://www.beekeeperstudio.io/) |

> During PostgreSQL installation, remember the **username** (default: `postgres`) and **password** you set — you will need them in Step 2.

---

### ✅ Step 2 — Connect Beekeeper Studio to PostgreSQL

1. Open **Beekeeper Studio**
2. Click **New Connection**
3. Select **PostgreSQL** as the connection type
4. Fill in the fields:

| Field | Value |
|---|---|
| Host | `localhost` |
| Port | `5432` |
| Database | `postgres` *(or create a new one)* |
| Username | `postgres` |
| Password | *(the password you set during install)* |

5. Click **Test** — if it says Connected, click **Save & Connect**

---

### ✅ Step 3 — Create the Database and Tables

1. In Beekeeper Studio, open the **SQL Editor** (top menu or sidebar)
2. Copy and paste the full **CREATE TABLE** and **INSERT** SQL from the [Database Schema](#database-schema) and [Sample Data](#sample-data) sections above
3. Click **Run**
4. You will see the 3 tables appear in the left sidebar under your database

---

### ✅ Step 4 — Download and Run the Query File

1. Download the file **`Query.sql`**
2. In Beekeeper Studio, open Query.sql file
3. Run each query one by one


