-- 1 UPDATE LOOKUP
insert into hash_jdt_shipment (shipmode, shipinstruct)
select l_shipmode, l_shipinstruct
from tpcd.lineitem
where l_shipinstruct not in (
    select shipinstruct
    from hash_jdt_shipment
    where l_shipmode = shipmode
) AND l_shipmode not in (
    select shipmode
    from hash_jdt_shipment
    where l_shipinstruct = shipinstruct
)
group by l_shipinstruct, l_shipmode
