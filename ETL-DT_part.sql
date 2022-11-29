-- 1 LOOKUP TABLE FEEDING
insert into hash_dt_part (partkey)
select p_partkey
from tpcd.part
where p_partkey not in (
    select partkey
    from hash_dt_part
);

-- 2 NEW ROWS INTO DT
insert into dt_part (id, part, mfgr, brand, type, size, container, retailprice)
select h.id, p_name, p_mfgr, p_brand, p_type, p_size, p_container, p_retailprice
from tpcd.part p join hash_dt_part h on (p.p_partkey = h.partkey)
where h.id not in (
    select id
    from dt_part
);

-- 3 UPDATE ROWS OF DT
update dt_part
set part = p_name,
    mfgr = p_mfgr,
    brand = p_brand,
    type = p_type,
    size = p_size,
    container = p_container,
    retailprice = p_retailprice
from tpcd.part p join hash_dt_part h on (p.p_partkey = h.partkey)
where h.id = dt_part.id AND dt_part.part <> p_name
