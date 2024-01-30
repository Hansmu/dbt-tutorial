# DBT Tutorial

## Background

### Data processing flow
When we think about data, we can think of it in stages.

1. Data collection - we capture the required data
2. Data wrangling - we clean and transform the data
3. Data integration - loading the clean data into a data warehouse/data lake
4. BI (Business intelligence) and Analytics - using the data to answer business questions
5. Artificial intelligence - using the data to train models that can make predictions

We care about the first three stages.

There are two terms used to describe the first three stages:
* ETL - Extract, Transform, Load
* ELT - Extract, Load, Transform

The difference between the two is that in ETL, the data is transformed before it is loaded into the data warehouse. 
In ELT, the data is loaded into the data warehouse first, and then transformed.

The reason for these two approaches is that in the past, data warehouses were expensive and had limited storage.
So, it was important to transform the data before loading it into the data warehouse.

Nowadays, data warehouses are cheaper and have more storage.
So, it is possible to load the data into the data warehouse first, and then transform it.

**So the default option is ELT - Extract, Load, Transform.**

### Data storage

There are two main types of data storage:
* Data warehouse - a database that is optimised for analytics
  * Data is stored in tables
  * They cannot handle unstructured data
* Data lake - a storage repository that holds a vast amount of raw data in its native format until it is needed

There's a term that combines the two - data lakehouse.

A data lakehouse is a data lake that has been enhanced with features that make it more like a data warehouse.

### What is DBT?

DBT fills te role of transforming the data after it has been loaded into the data warehouse.
So the T in ELT.

### Setting up the project

Refer to the [setup guide](Setup.md) for instructions on how to set up the project.

### Setting up DBT

First thing that you need to do is create a DBT configuration folder.

You need to have a DBT folder in the user root on the OS.

```bash
mkdir ~/.dbt
```

After that you can run the following command to create a DBT profile.

```bash
dbt init <projectName>
```

This will add a profile in the `profiles.yml` file in the `~/.dbt` folder.

You can then run the following command to test the connection to the database.

```bash
dbt debug
```

### DBT project structure

The main configuration file is `dbt_project.yml`.

The `models` folder contains the SQL files that are used to transform the data.

The `seeds` or `data` folder contains the data that is used to test the models.

The `target` folder contains the compiled SQL files that are used to transform the data.

The `snapshots` folder contains the SQL files that are used to create snapshots.

The `tests` folder contains the SQL files that are used to test the models.

The `macros` folder contains the SQL files that are used to create macros.

The `analysis` folder contains the SQL files that are used to analyse the data.

All of the above folders can be changed in the `dbt_project.yml` file.

### Models

Models are the SQL files that are used to transform the data.

They are the basic building blocks of your business logic.

Materialized as tables or views.

Models can reference each other, use templates, and use macros.

You'll usually see the SQL written in models using the `with` statement.

You can add subfolders to the `models` folder to organise your models.

By default, a model is a view.
The default materialization can be changed in the `dbt_project.yml` file.

Use `dbt run` to run the entire pipeline.
It will compile the models and run them against the target DB.

All models of type `table` will be re-created on every run.
So if you've manually inserted into it, it will be gone after the run.

`incremental` on the other hand will only update the rows that have added.
If a row is removed from the base table or a row has been manually inserted into the table, it will not be removed.

If your schema does not exist in the database, then the `dbt run` command will create it.

Remember, the schema was defined in the `dbt_project.yml` file.

There are four different kinds of materializations:
* Table - creates a table in the database. Frequent access.
* View - creates a view in the database. Infrequent access.
* Incremental - creates a table in the database, and then updates it incrementally. 
* Ephemeral - an intermediate step, doesn't create a table in the database.

DBT uses Jinja for templating and macros.

To refer to another model, you can use the `ref` function.

```sql
select * from {{ ref('model_name') }}
```

To override default settings, you can use the `config` function inside a model file.
For example in the [fct_reviews.sql](dbtlearn/models/facts/fct_reviews.sql) file, we have the following:

```sql
{{
    config(
        materialized = 'incremental',
        on_schema_change='fail'
    )
}}
```

If you want to re-create an incremental model, you can use the `--full-refresh` flag.

```bash
dbt run --full-refresh
```

If you change the type of materialization to `ephemeral`, then the model will not be dropped if it exists.
You have to do it manually.

When compilation happens, the `ephermal` models are turned into `with` statements in the compiled SQL file.

**If you want to debug what DBT has created, then you can look in the `target` folder.**

If you change a table to a view, then it automatically drops the table.

### Seeds

Seeds are local files that you upload to the data warehouse from DBT.

When running `dbt seed`, it will look in the `seeds` folder for CSV files.

When you run `dbt seed`, then the file will be uploaded to a table with the same name as the file.

DBT figures out the schema of the table by looking at the CSV file.

### Sources

The `sources.yml` file is used to document the raw data sources that you're using.

You can specify aliases for the tables, along with a bunch of metadata.

It also allows for the checking of freshness.
You specify how long ago data should have been updated.

To check for freshness, you can run the command:
    
```bash
dbt source freshness
```

### Snapshots

Snapshots handle slowly changing dimensions.

That is, they make sure that historic information is kept.

The row will have a valid from and a valid to field appended to it.

The active row is the one with the valid to field set to null.

If a property is changed, then a new row is created with the new values and a valid to of null, while the old row is updated with a valid to of the current date.

The snapshots live in the `snapshots` folder.

There are two strategies that you can use for snapshot creation checks:
1. A unique key and an updated_at field
2. Checking any number of fields

Snapshots create a new table in your DB.


### Tests

There are two types of tests:
1. Singular - SQL queries in tests that are expected to return 0 rows.
2. Generic - check the values of a column.

This isn't unit testing, but validating the data that already exists.

You can run the tests using the command:

```bash
dbt test
```

To run only a specific test, you can use the command:

```bash
dbt test --select <test_name>
```

#### Generic tests

They are built in tests in DBT.

They can come from the core installation, 3rd party packages, or your own custom definitions.

The tests go to your datasource and execute the tests against the data in the tables.

The aim is to make sure that the data is correct.

These live in the `schema.yml` folder.

#### Singular tests

These are custom tests that you write yourself.

They are written in SQL.

They live inside the `tests` folder.


### Macros

Macros are basically Jinja templates that are created in the `macros` folder.

There are built-in macros in DBT.

#### Custom generic tests
Custom generic tests can be created using macros.
They're nothing more than macros with a special signature.
You can add them to your `schema.yml` file.
They live inside the `macros` folder, because they're still macros.

#### Third-party libraries

Third party libraries can be found [here](https://hub.getdbt.com/).

In order to manage your packages, you'll need a `packages.yml` file in the project root.

To install the packages, you can run the command:

```bash
dbt deps
```