# Basic operations
## Snippets
### Filter only values not present
```sql
where myID not in (
    select myId
    from tableYouAreInsertingInto
);
```

### Join source table with lookup table and other referenced source tables
```sql
sourceTable join lookupTable on sourceTable.id = lookupTable.sourceId 
    join anotherSourceTable on sourceTable.referenceValue = anotherSourceTable.id -- ...
```

### Filter values already present and changed
```sql
where lookupTable.id = dt.id AND changedField <> dt.field
```

## Table operations
### Update lookup table
```sql
insert into lookupTable (sourceIdField)
select sourceId
from sourceTable
where 'not-present'
```
[`not-present`](note.md#filter-only-values-not-present)

### Date hierarchy
Lookup table is updated as usual.

```sql
insert into dt_date(id, date, month, year)
select id, date, to_char(date, 'YYYY-MM'), to_number(to_char(date, 'YYYY'), '0000')
from lookupTableDate
where 'not-present'
```
[`not-present`](note.md#filter-only-values-not-present)

### Insert new rows in DT
```sql
insert into dt (dt_fields, ...)
from 'joined-table'
where 'not-present'
```
[`joined-table`](note.md#join-source-table-with-lookup-table-and-other-referenced-source-tables)

[`not-present`](note.md#filter-only-values-not-present)

### Update rows in DT
```sql
update dt
set dt_field1 = sourceTable.field1,
    dt_field2 = sourceTable.field2 --, ...
from 'joined-table'
where 'present'
```
[`joined-table`](note.md#join-source-table-with-lookup-table-and-other-referenced-source-tables)

[`present`](note.md#filter-values-already-present-and-changed)
