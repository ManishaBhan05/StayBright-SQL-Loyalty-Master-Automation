
# StayBright – SQL-Powered Loyalty Master Automation

## Project Overview

A SQL-based loyalty data aggregation solution developed in Salesforce Marketing Cloud for StayBright, a fictional Australian hospitality group operating hotels, resorts, bars, and bistros.

The project consolidates customer information from five Data Extensions into a centralized `Loyalty_Master` Data Extension.

The solution combines transaction history, loyalty points, spending behaviour, property visits, app engagement, and loyalty tier information to support future customer segmentation and personalized marketing campaigns.

## Business Scenario

StayBright's marketing team needed a centralized view of its loyalty members to simplify campaign preparation.

Previously, customer information was stored across five separate Data Extensions, requiring marketers to retrieve information from multiple sources whenever they wanted to build audiences or personalize campaigns.

The business required a single master Data Extension designed for daily updates, containing essential loyalty metrics, engagement history, and property preferences.

## Project Requirements

### Data Aggregation
- Consolidate information from five source Data Extensions.
- Calculate loyalty points earned over the previous 6 and 12 months.
- Calculate spending and property visits over the same periods.
- Return zero for missing transactional aggregates.

### Loyalty Tier Calculations
- Retrieve each member's current loyalty tier and points balance.
- Calculate additional points required to reach the next tier.
- Return zero for members already in the Platinum tier.

### Customer Activity and Engagement
- Identify each member's most recent transaction date.
- Calculate the number of days since their last purchase.
- Retrieve the last visited property and its name.
- Identify the most recent app login date.

### Master Data Extension
- Consolidate the calculated information into `Loyalty_Master`.
- Maintain one record per member.
- Prepare the dataset for future segmentation and personalization.

## Source Data Extensions

Five Data Extensions provide the data required to build the consolidated loyalty profile.

| Data Extension | Purpose |
|---|---|
| Loyalty_Members_StayBright | Stores member profiles, membership status, loyalty points, and current tier. |
| Loyalty_Transactions_StayBright | Contains transactions used to calculate spending, points, visits, and purchase recency. |
| Property_Dictionary | Stores property information used to retrieve the last visited property name. |
| App_Events | Contains app activity records used to identify the most recent login. |
| Tier_Matrix | Defines loyalty tier thresholds used to calculate points required for the next tier. |

## SQL Query – Loyalty_Master

**Purpose:** Consolidate member information and calculate key loyalty metrics.

A single SQL query combines information from the five source Data Extensions to create a centralized loyalty profile for each member.

### SQL Features Demonstrated

**LEFT JOIN**
- Combines member information with transactions, properties, app engagement, and loyalty tier data.
- Retains members even when related activity records are unavailable.

**Aggregate Functions**
- SUM() calculates loyalty points, spending, and property visits.
- MAX() retrieves the most recent transaction and app login dates.

**CASE Statements**
- Calculates in-property visits.
- Determines points required to reach the next loyalty tier.
- Returns zero for Platinum members.

**ISNULL**
- Replaces missing transactional aggregates with zero.

**Date Functions**
- DATEADD() defines the 6-month and 12-month reporting periods.
- DATEDIFF() calculates days since the last purchase.

**NOT EXISTS**
- Identifies each member's most recent in-property transaction.
- Uses TransactionID as a tie-breaker when transaction dates match.

### SQL File

`Loyalty_Master.sql`

The SQL query generates 21 output fields containing member information, loyalty metrics, transaction history, property visits, app engagement, and tier progression.

## Automation Studio

An Automation Studio workflow was configured with one SQL Query Activity named `Loyalty_Master`.

The activity processes member, transaction, property, app engagement, and tier information to populate the centralized Data Extension.

The project demonstrates a successfully tested SQL execution.

## Testing and Results

The SQL automation was executed successfully in Salesforce Marketing Cloud Automation Studio.

### Execution Results

- Automation execution: Completed successfully
- Recorded success rate: 100%
- Reported errors: None
- Resulting Data Extension: Loyalty_Master
- Total records: 200
- Output fields: 21

The resulting Data Extension consolidates customer information and calculated loyalty metrics into one member-level dataset.

### Reporting Date

The SQL query uses a fixed reference date of October 10, 2025, for historical calculations.

This provides a consistent reporting snapshot for the capstone. A dynamic reference date would be required to maintain rolling reporting periods in a daily production automation.

### Project Outcome

The project demonstrates SQL-based customer data aggregation, loyalty metric calculations, and the preparation of a centralized Data Extension for future segmentation and personalized marketing.

The solution reduces the need to retrieve customer information separately from multiple Data Extensions when preparing future marketing audiences.

## Tools and Technologies

- Salesforce Marketing Cloud
- SQL
- Automation Studio
- SQL Query Activities
- Data Extensions
- GitHub

## Project Note

This project was completed as part of the AMPscript Academy SQL Capstone program using a fictional business scenario and sample data.

The SQL automation was successfully tested. The project does not represent an activated production automation or a live marketing campaign.


