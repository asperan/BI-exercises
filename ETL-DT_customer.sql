-- 1 UPDATE LOOKUP
insert into hash_dt_customer (custkey)
select c_custkey
from tpcd.customer
where c_custkey not in (
    select custkey
    from hash_dt_customer
);

-- 2 INSERT NEW ROWS
insert into dt_customer (id, customer, address, phone, acctbal, mktsegment, nation, region)
select h.id, c.c_name, c.c_address, c.c_phone, c.c_acctbal, c.c_mktsegment, n.n_name, r.r_name
from
    (tpcd.customer c JOIN hash_dt_customer h ON c.c_custkey = h.custkey)
    JOIN (tpcd.nation n JOIN tpcd.region r ON n.n_regionkey = r.r_regionkey)
    ON c.c_nationkey = n.n_nationkey
where h.id not in (
    select id
    from dt_customer
);

-- 3 UPDATE EXISTING ROWS
update dt_customer
set id = h.id,
    customer = c.c_name,
    address = c.c_address,
    phone = c.c_phone,
    acctbal = c.c_acctbal,
    mktsegment = c.c_mktsegment,
    nation = n.n_name,
    region = r.r_name
from (tpcd.customer c JOIN hash_dt_customer h ON c.c_custkey = h.custkey)
    JOIN (tpcd.nation n JOIN tpcd.region r ON n.n_regionkey = r.r_regionkey)
    ON c.c_nationkey = n.n_nationkey
where h.id = dt_customer.id AND dt_customer.customer <> c.c_name
