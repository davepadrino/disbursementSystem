# Disbursement system

## Intro

Disbursement system to process payments, earnings and fees.
I've had a lot of fun 💪🏾 :)

## Decision making

### Database

Given the amount of data of each file and given that we're talking about transactions and relations between elements/objects/entities, I've decided to create a SQL database to handle this properly. Also, given the data requested by the problem, is easier to create relationships and use proper SQL operations in order to get the results.

Creating a relational schema also prepares the project for scalability, in opposition to the CSV schema that is not efficient and lacks relationships.
Also, handle in-memory data wasn't the best solution due to the amount of data we're handling.
No-SQL DB was considered (documents or even graphs based) but since the relation between Merchants and Orders is pretty clear (transactions), we have a clear winner.

## Assumptions

- Dates are correct and in the same timezone
- All order have merchants associated (I've grouped orders by merchants, but have inserted every remaining order without merchant anyway)
- Execution automatized for more years since the first merchant `live_on` date to the current and increasing automatically.

## Improvements

### Some of the improvements i'd do in a real life app, but didn't applied at the moment.

- Create partitions/index in certain tables so the queries are quicker. (for big number of records)
- Proper logging for production debugging (at the moment only print/puts), so we can debug properly in any configured tool (Logjam, Datadog, Graylog, etc)
- A kubernetes (for instance) cronjob instead of a native one to run the task, will give us more control and on-demand start.
- Some Ids in the DB could be UUIDs for security reasons (just in case we don't want to expose the number of records inherent of the sequential id assignation of some DB)
- Add more tests, I added only one of them for timing reasons, but configuring the `db_test` and the FactoryBot to handle the mocked data.
- rake tasks to process historical data NEED refactor to optimize time (batch or parallelism) and probably add indexes to improve even more the performance of the queries (order-created_at, order-merchants-dates, merchants-frequency), but since in a real case scenario this job will be run once.
- Create the proper queries to test the table results are correct.
- Proper CI configuration via Jenkins or GHA to run tests, create project images and test coverage.
- Create a base Service and Error classes (among others) to have conherent methods, error handling and service structure. This way we could take advantage of inheritance and interfaces.
- Missing cleanup of files and directories that are not being used.

## Features

- Setup a docker repository production ready for a rails app ✅
- Setup data model ✅
- Create DB migrations ✅
- Inject data via rake task and store it in DB ✅
- Add disburshment logic ✅
- Add monthtly fee logic ✅
- Add final report logic ✅
- Add daily processing task (yes and no)
- Add test suite and specs ✅

## Getting Started

1. **Setup and start the application:**
   This install all dependencies, start servers, apply migrations and import CSV data. In case a command fails, you can run the failing one manually. For more information, check the [Makefile](Makefile)

```bash
make setup
```

2. **Process all the disbursements (historical ones):**

```bash
make disbursements-all
```

3. **Process the monthly_fees for the existing disbursements:**
   Recommended this command after the one above for realistic data

```bash
make monthly-fees-all
```

4. **Generate reports in console:**

```bash
make report
```

## Additional commands in the Makefile

1. **Create a migration file given a name:**

```bash
make generate-migration NAME=<migration-name>
```

## Available Commands

- `make setup` - Build and start the application
- `make build` - Build Docker image
- `make up` - Start services
- `make stop` - Stop services
- `make logs` - View logs
- `make console` - Open Rails console
- `make migrate` - Run database migrations
- `make import-data` - Run screipt to read CSV files and fill the database
- `make test-file` - To run tests for a certain file (example in Makefile)
- `make disbursements` - Run disbursements for a current date
- `make disbursements-all`- Run historical disbursements
- `make monthly-fee-all` - Run monthly fees calculation for historical disbursements
- `make monthly-fee` - Run disbursements for current date
- `make report` - Print in screen report for requested data
- `make db-reset` - Reset database
- `make clean` - Clean up Docker resources for this project

## Health Check

The application includes a health check endpoint at `/up` that returns:

- 200 OK if the application is running properly
- 500 Internal Server Error if there are any issues

## Database

The application uses MySQL 8.0.
I made a mistake by lettign the default id for the merchants table and instead of recreating everything taking advantage that the project is brand new, i preferred to do migrations to fix this so it can be a similar to a real case scenario. That's why there are more migrations than the expected ones. Example [this](db/migrate/20250717075810_change_merchants_primary_key_to_string.rb)

We have a relation like this:

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

Use of AI: I used ChatGPT to move forward with DB models and migrations given the model and relations I created, I used it to move forward quickly and because I considered more important having created that data model and logic behind it than the tech details themselves, link [here](https://chatgpt.com/share/6877dc73-62dc-8011-9aa7-58f770d0d02e). This has changed since i needed adaptations (not trusting 100% AI ~yet~)

## Additional information

### Create new orders (to validate that the fees are calculated in creation time)

Specfied an existing merchant since an order cannot exist without it

```rb
Order.create!(id: "abcdfeg", merchant_id: "86312006-4d7e-45c4-9c28-788f4aa68a62", amount: "800".to_f, created_at: DateTime.parse("2025-07-17"))
```

### Validate amounts and fees in disbursements manually to corroborate the algoritm works

```sql
SELECT
   COUNT(*) as order_count,
   SUM(o.amount) as calculated_total,
   SUM(o.commission_fee) as calculated_commission,
   (SUM(o.amount) - SUM(o.commission_fee)) as calculated_net,
   MIN(DATE(o.created_at)) as first_order_date,
   MAX(DATE(o.created_at)) as last_order_date
FROM orders o
WHERE o.disbursement_id = '<insert_disbursement_id>';
```

### Since no deploy/cronjob pod could be created

This is a built in solution, altought I'd stick with a dedicated pod for this processing to avoid consume resources from the API pod when deployed.

```bash
crontab -e

# Process disbursements every day at 8am
0 8 * * * cd <project_directory> && make disbursements

# Check for monthly fees daily during first day of month
0 9 1 * * cd <project_directory> && make monthly-fees
```

# Final report

| Year | # of disbursements | Amount disbursed to merchants | Amount of order fees | # of monthly fees charged | Amount of monthly fees charged |
| ---- | ------------------ | ----------------------------- | -------------------- | ------------------------- | ------------------------------ |
| 2022 | 1547               | 37852696.71 €                 | 338976.04 €          | 126                       | 2899.16 €                      |
| 2023 | 10363              | 189684161.2 €                 | 1703961.96 €         | 154                       | 2863.56 €                      |
| 2024 | 0                  | 0.0 €                         | 0.0 €                | 408                       | 10080.0 €                      |
| 2025 | 0                  | 0.0 €                         | 0.0 €                | 204                       | 5040.0 €                       |

# Final words

To check some intra-documentation look for `# INFO: ` in the project and you'll easily find some decisions, thoughts and information of mine :)
