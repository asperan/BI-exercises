-- 1 UPDATE LOOKUP TABLE
insert into hash_dt_date (date)
select dates.date
from (
    select l_shipdate as date
    from tpcd.lineitem
    UNION
    select l_commitdate as date
    from tpcd.lineitem
    UNION
    select l_receiptdate as date
    from tpcd.lineitem
    UNION
    select o_orderdate as date
    from tpcd.orders
) AS dates
where dates.date not in (
    select date
    from hash_dt_date
);

-- 2 INSERT NEW ROWS
insert into dt_date (id, date, month, year)
select h.id, h.date, to_char(h.date, 'YYYY-MM'), to_number(to_char(h.date, 'YYYY'), '0000')
from hash_dt_date h
where h.id not in (
    select id
    from dt_date
);
