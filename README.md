# ⚽ Football Ticket Booking System
### Database Design & SQL Assignment

---

## 📋 Table of Contents

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
| **Concepts Covered** | WHERE, ILIKE, IS NULL, COALESCE, INNER JOIN, LEFT JOIN, Subquery, LIMIT/OFFSET |

---

## Entity Relationship Diagram (ERD)

> 📌 **Place your ERD image below:**

![ERD Diagram](./erd.png)

*Figure 1 — ERD for the Football Ticket Booking System using Crow's Foot notation.*

### Relationships

| Relationship | Type | Description |
|---|---|---|
| Users → Bookings | One-to-Many | One user can place many bookings |
| Matches → Bookings | One-to-Many | One match can have many booking records |
| Users + Matches via Bookings | Logical One-to-One | Each booking row maps exactly one user to one match for one seat |

---

## Database Schema

### Table 1 — Users

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

| Field | Type | Constraint |
|---|---|---|
| `user_id` | INT | Primary Key |
| `full_name` | VARCHAR(20) | — |
| `email` | VARCHAR(30) | UNIQUE |
| `role` | VARCHAR(20) | CHECK: `'Ticket Manager'` or `'Football Fan'` |
| `phone_number` | VARCHAR(20) | Nullable |

---

### Table 2 — Matches

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

| Field | Type | Constraint |
|---|---|---|
| `match_id` | INT | Primary Key |
| `fixture` | VARCHAR(30) | — |
| `tournament_category` | VARCHAR(20) | — |
| `base_ticket_price` | DECIMAL(10,2) | CHECK: >= 0 |
| `match_status` | VARCHAR(20) | CHECK: 4 allowed values |

---

### Table 3 — Bookings

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

| Field | Type | Constraint |
|---|---|---|
| `booking_id` | INT | Primary Key |
| `user_id` | INT | Foreign Key → Users |
| `match_id` | INT | Foreign Key → Matches |
| `seat_number` | VARCHAR(20) | Nullable |
| `payment_status` | VARCHAR(20) | CHECK: 4 allowed values |
| `total_cost` | DECIMAL(10,2) | CHECK: >= 0 |

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

| user_id | full_name | email | role | phone_number |
|---|---|---|---|---|
| 1 | Tanvir Rahman | tanvir@mail.com | Football Fan | +8801711111111 |
| 2 | Asif Haque | asif@mail.com | Football Fan | +8801722222222 |
| 3 | Sajjad Rahman | sajjad@mail.com | Ticket Manager | +8801733333333 |
| 4 | Jannat Ara | jannat@mail.com | Football Fan | NULL |

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

| match_id | fixture | tournament_category | base_ticket_price | match_status |
|---|---|---|---|---|
| 101 | Real Madrid vs Barcelona | Champions League | 150.00 | Available |
| 102 | Man City vs Liverpool | Premier League | 120.00 | Selling Fast |
| 103 | Bayern Munich vs PSG | Champions League | 130.00 | Available |
| 104 | AC Milan vs Inter Milan | Serie A | 90.00 | Sold Out |
| 105 | Juventus vs Roma | Serie A | 80.00 | Available |

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

| booking_id | user_id | match_id | seat_number | payment_status | total_cost |
|---|---|---|---|---|---|
| 501 | 1 | 101 | A-12 | Confirmed | 150.00 |
| 502 | 1 | 102 | B-04 | Confirmed | 120.00 |
| 503 | 2 | 101 | A-13 | Confirmed | 150.00 |
| 504 | 2 | 101 | NULL | NULL | 150.00 |
| 505 | 3 | 102 | C-20 | Pending | 120.00 |

---

## SQL Queries

> 📥 **The full query file is available in this repository.**
> Download **`query.sql`** from GitHub and run it in Beekeeper Studio (or any PostgreSQL client) after completing the setup steps below.

---

### Query 1 — Champions League Available Matches
> Retrieve all upcoming football matches belonging to the `Champions League` where the match status is `Available`.
>
> **Concepts:** `WHERE`, `AND`

**Output:**

| match_id | fixture | base_ticket_price |
|---|---|---|
| 101 | Real Madrid vs Barcelona | 150 |
| 103 | Bayern Munich vs PSG | 130 |

---

### Query 2 — Search Users by Name
> Search for all users whose full names start with `Tanvir` or contain the phrase `Haque` (case-insensitive).
>
> **Concepts:** `ILIKE`

**Output:**

| user_id | full_name | email |
|---|---|---|
| 1 | Tanvir Rahman | tanvir@mail.com |
| 2 | Asif Haque | asif@mail.com |

---

### Query 3 — Bookings with Missing Payment Status
> Retrieve all booking records where the payment status is missing (`NULL`), replacing the empty result with `Action Required`.
>
> **Concepts:** `IS NULL`, `COALESCE`

**Output:**

| booking_id | user_id | match_id | systematic_status |
|---|---|---|---|
| 504 | 2 | 101 | Action Required |

---

### Query 4 — Booking Details with User and Match Info
> Retrieve match booking details along with the user's full name and the scheduled match fixture teams.
>
> **Concepts:** `INNER JOIN`

**Output:**

| booking_id | full_name | fixture | total_cost |
|---|---|---|---|
| 501 | Tanvir Rahman | Real Madrid vs Barcelona | 150 |
| 502 | Tanvir Rahman | Man City vs Liverpool | 120 |
| 503 | Asif Haque | Real Madrid vs Barcelona | 150 |
| 504 | Asif Haque | Real Madrid vs Barcelona | 150 |
| 505 | Sajjad Rahman | Man City vs Liverpool | 120 |

---

### Query 5 — All Users Including Those with No Bookings
> Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
>
> **Concepts:** `LEFT JOIN`

**Output:**

| user_id | full_name | booking_id |
|---|---|---|
| 1 | Tanvir Rahman | 501 |
| 1 | Tanvir Rahman | 502 |
| 2 | Asif Haque | 503 |
| 2 | Asif Haque | 504 |
| 3 | Sajjad Rahman | 505 |
| 4 | Jannat Ara | NULL |

---

### Query 6 — Bookings Above Average Cost
> Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.
>
> **Concepts:** `Subquery`, `AVG()`

> Average = (150 + 120 + 150 + 150 + 120) / 5 = **138.00**

**Output:**

| booking_id | match_id | total_cost |
|---|---|---|
| 501 | 101 | 150 |
| 503 | 101 | 150 |
| 504 | 101 | 150 |

---

### Query 7 — Top 2 Matches Skipping the Most Expensive
> Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.
>
> **Concepts:** `ORDER BY`, `LIMIT`, `OFFSET`

> *Skips Real Madrid vs Barcelona at 150*

**Output:**

| match_id | fixture | base_ticket_price |
|---|---|---|
| 103 | Bayern Munich vs PSG | 130 |
| 102 | Man City vs Liverpool | 120 |

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
3. Click **Run** (or press `Ctrl + Enter`)
4. You should see the 3 tables appear in the left sidebar under your database

---

### ✅ Step 4 — Download and Run the Query File

1. Go to this GitHub repository
2. Download the file **`query.sql`**
3. In Beekeeper Studio, open the SQL Editor
4. Drag and drop `query.sql` into the editor window — or open it via **File → Open**
5. Run each query one by one, or select all and run together

> 💡 **Tip:** You can highlight just one query and press `Ctrl + Enter` to run only that selected query.

---

### ✅ Step 5 — Verify the Output

After running each query, compare your results with the **Output tables** shown in the [SQL Queries](#sql-queries) section above. If the results match, your setup is working correctly.

---

*Football Ticket Booking System — SQL Assignment*
