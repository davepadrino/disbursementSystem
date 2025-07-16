# README

# Disbursement system

## Intro

All of this project, decisions and architecture is based in my understanding of the problem that can always be wrong.
Also regarding selection of the technologies, they were chosen since is what I've been working with the past months and want to learn and improve in this aspect 💪🏾

## Decision making

### Database

Given the amount of data of each file and given that we're talking about transactions and relations between elements/objects/entities, I've decided to create a SQL database to handle this properly. Also, given the data requested by the problem, is easier to create relationships and use proper SQL operations in order to get the results.

Creating a relational schema also prepares everything for scalability, in opposition to the CSV schema that is not efficient and lacks relationships.
Also, handle in-memory data wasn't the best solution due to the amount of data wwe're handling.
No-SQL DB was considered (documents or even graphs based) but since the relation between Merchants and Orders is pretty clear, we have a clear winner.

...

## Features

- Setup a docker repository production ready for a rails app ✅
- Setup data model ✅
- Create DB migrations ✅
- Inject data via rake task and store it in DB
- Add business logic services / controllers and routes
- Add test suite and specs

## Getting Started

1. **Setup and start the application:**

   ```bash
   make setup
   ```

2. **Check if the application is running:**

   ```bash
   make health
   ```

3. **View logs:**

   ```bash
   make logs
   ```

4. **Access Rails console:**
   ```bash
   make console
   ```

## Available Commands

- `make setup` - Build and start the application
- `make build` - Build Docker image
- `make up` - Start services
- `make stop` - Stop services
- `make logs` - View logs
- `make console` - Open Rails console
- `make migrate` - Run database migrations
- `make db-reset` - Reset database
- `make health` - Check health status
- `make clean` - Clean up Docker resources for this project

## Health Check

The application includes a health check endpoint at `/up` that returns:

- 200 OK if the application is running properly
- 500 Internal Server Error if there are any issues

## Database

The application uses MySQL 8.0

According to my understanding of the problem, we have a relation like this:

```pgsql
┌───────────────────────────────────────────────────┐
│                         merchants                 │
├──────────────────────────┬────────────────────────┤
│ id                       │          UUID          │
│ reference                │          STRING        │
│ live_on                  │          DATE          │
│ disbursement_frequency   │ ENUM('daily', 'weekly')│
│ minimum_monthly_fee      │         DECIMAL        │
└──────────────────────────┴────────────────────────┘

                           ▲
                           │ 1
                           │
                           │
                           │ N
┌────────────────────────────────────────────────┐
│                     orders                     │
├────────────────────────┬───────────────────────┤
│ id                     │ UUID / INT            │
│ merchant_id            │ FK → merchants        │
│ amount                 │ DECIMAL               │
│ created_at             │ DATETIME              │
│ disbursement_id        │ FK → disbursements    │ ← Nullable
│ commission_fee         │ DECIMAL               │ ← calculated at disbursement time
└────────────────────────┴───────────────────────┘

                           ▲
                           │ 1
                           │
                           │
                           │ N
┌──────────────────────────────────────────────────┐
│                  disbursements                   │
├──────────────────┬───────────────────────────────┤
│ id               │ UUID / INT                    │
│ merchant_id      │ FK → merchants                │
│ reference        │ STRING (unique merchant+date) │
│ disbursement_date│ DATE                          │
│ total_amount     │ DECIMAL                       │
│ total_fees       │ DECIMAL                       │
└──────────────────┴───────────────────────────────┘

                  ▲
                  │ 1
                  │
                  │
                  │ 1
┌─────────────────────────────┐
│         monthly_fee         │
├─────────────┬───────────────┤
│ id          │ UUID / INT    │
│ merchant_id │ FK → merchants│
│ month       │ YYYY-MM       │
│ total_fees  │ DECIMAL       │ ← sum of order commissions
│ charged_fee │ DECIMAL       │ ← if < min fee
└─────────────┴───────────────┘
```

Use of AI: I used ChatGPT to move forward with DB models and migrations given the model and relations I created, I used it to move forward quickly and because I considered more important having created that data model and logic behind it than the tech itself, link [here](https://chatgpt.com/share/6877dc73-62dc-8011-9aa7-58f770d0d02e). This probably will change if need adaptations (not trusting 100% AI ~yet~)
