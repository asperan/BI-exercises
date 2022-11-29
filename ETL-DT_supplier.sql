-- 1 UPDATE LOOKUP TABLE    
insert into hash_dt_supplier (suppkey)
select s_suppkey
from tpcd.supplier
where s_suppkey not in (
    select suppkey
    from hash_dt_supplier
);

-- 2 INSERT NEW ROWS
insert into dt_supplier (id, supplier, address, phone, acctbal, nation, region)
select h.id, s.s_name, s.s_address, s.s_phone, s.s_acctbal, n.n_name, r.r_name
from (tpcd.supplier s JOIN hash_dt_supplier h ON s.s_suppkey = h.suppkey)
    JOIN (tpcd.nation n JOIN tpcd.region r ON n.n_regionkey = r.r_regionkey)
    ON s.s_nationkey = n.n_nationkey
where h.id not in (
    select id
    from dt_supplier
);

-- 3 UPDATE EXISTING ROWS
update dt_supplier
set supplier = s.s_name
from (tpcd.supplier s JOIN hash_dt_supplier h ON s.s_suppkey = h.suppkey)
    JOIN (tpcd.nation n JOIN tpcd.region r ON n.n_regionkey = r.r_regionkey)
    ON s.s_nationkey = n.n_nationkey
where h.id = dt_supplier.id AND s.s_name <> dt_supplier.supplier
