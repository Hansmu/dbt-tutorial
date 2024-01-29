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