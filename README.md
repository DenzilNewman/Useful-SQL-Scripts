# Useful-SQL-Scripts
This repositry contains useful T-SQL scripts, detailed below.

## Scalar Functions

### ISINTEGER
A simple function simular to ISNUMERIC that returns a BIT value of 1 if the value is a valid INT, or 0 if it is not.

### NTH_DIGIT
Scalar function for getting a single digit of a BIGINT. Supply the value, and the index to retrieve (right to left).
For example, the second digit of 654321, is 2.

### SESSION_CODE
A function for getting a unique string to represent the current database function.
Result is a hexadecimal VARCHAR(15) based on the SESSION_ID, and the LOGIN_TIME of the current session.

## Table Values Functions

### DATABASEOBJECT
There are times where it is useful for a script to act upon multiple database objects.  These are usually for testing, maintainence or deployment purposes rather than production.
This accepts a string list of one or more database entities and returns a result set of entities found.

![database-object](https://user-images.githubusercontent.com/26501604/153776800-144423eb-1bb0-42c1-84fc-8073ab24c81a.png)
