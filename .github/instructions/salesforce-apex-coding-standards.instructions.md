---
applyTo: "**/*.cls,**/*.trigger"
---

# Salesforce Apex Coding Standards

## Core behavior
When creating or modifying Apex classes and triggers, follow these standards as the default implementation rules for this project.

## Class naming
- Class names must be PascalCase.
- Names should clearly describe the purpose.
- Use domain-specific names instead of vague abbreviations.

### Good
- AccountService
- OpportunityTriggerHandler
- CSVContactImporter

### Bad
- accService
- oppHandler
- testcls

## Method naming
- Methods must be camelCase.
- Method names must start with a verb.
- Prefer explicit, readable names over short shorthand.

### Good
- processContacts()
- validateAccounts()
- createOpportunities()
- sendNotification()

### Bad
- ProcessContacts()
- contacts()
- data()
- m1()

## Variable naming
- Use meaningful names.
- Avoid abbreviations.
- Use camelCase.

### Good
- accountName
- contactEmail
- totalOpportunityAmount

### Bad
- accNm
- e
- x
- amt

## Collection naming
Prefix collections based on type.

### List
- List<Account> listAccounts

### Set
- Set<Id> setAccountIds

### Map
- Map<Id, Account> mapAccountsById

### Bad
- accounts
- accSet
- m

## Boolean naming
Boolean variables must begin with one of these prefixes:
- is
- has
- can
- should

### Good
- isActive
- hasPermission
- canUpdate
- shouldProcess

### Bad
- active
- permission
- updateAccess

## Constants
Constants must be:
- static
- final
- uppercase with underscores

### Good
- public static final Integer MAX_RECORDS = 200;

### Bad
- public static Integer maxRecords = 200;

## Loop variables
Use contextual names that describe the record represented in the loop.

### Good
- for (Account accountRecord : listAccounts)
- for (Contact contactRecord : listContacts)

### Bad
- for (Account a : accounts)
- for (Contact c : contacts)

## SOQL naming
Use clear, descriptive collection variable names.

### Good
- List<Account> listAccounts = [
  SELECT Id, Name
  FROM Account
];

### Bad
- List<Account> accs = [
  SELECT Id
  FROM Account
];

## Method size
- Prefer methods under 50 lines.
- Extract helper methods when logic becomes large.
- Follow the single responsibility principle.
- Keep each method focused on one business responsibility.

## Trigger framework
Use the trigger-to-handler-to-service-to-helper pattern.

Trigger
↓
Handler
↓
Service
↓
Helper

Avoid putting business logic directly in triggers.

## Logging
Use meaningful debug statements.

### Good
- System.debug(
    LoggingLevel.INFO,
    'Account processing completed.'
  );

### Bad
- System.debug('done');

## Bulkification
Never perform DML or SOQL inside loops.

### Good
- Collect records
- Perform a single DML operation

### Bad
- for (Account accountRecord : listAccounts) {
    insert accountRecord;
  }

## Implementation expectations
- Favor readable, maintainable Apex over clever but opaque code.
- Keep logic bulk-safe and governor-limit aware.
- Use helper methods to break large methods into smaller units.
- Use clear names that communicate business intent.
- Preserve separation of responsibilities across handler, service, and helper layers.

## Review checklist
Before finalizing Apex code, verify:
- names are consistent and descriptive
- methods are small and focused
- collections use clear typed names
- booleans use is/has/can/should prefixes
- constants are static final uppercase
- loops do not contain DML or SOQL
- business logic is not embedded directly in triggers
- logging is meaningful and useful
