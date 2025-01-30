
-- 300125
-- 4a) : Supplier-Parts DB

-- Creating Tables.
create table if not exists Supplier(
    sid int primary key,
    sname varchar(10),
    address varchar(15)
);

create table if not exists Part(
    pid int primary key,
    pname varchar(15),
    color varchar(15)
);

create table if not exists Shipment(
    sid int, pid int, cost float,

    foreign key(sid) references Supplier(sid) on update cascade on delete set null,
    foreign key(pid) references Part(pid) on update cascade on delete set null
)

-- Inserting the values.
insert into Supplier values
(1, 'S1', 'Blr'),
(2, 'S2', 'Mys'),
(3, 'S3', 'Del'),
(4, 'S4', 'Mum'),
(5, 'S5', 'Kol');

insert into Part values
(100, 'Transistors', 'Black'),
(200, 'PCBs', 'Grenn'),
(300, 'LEDs', 'Red'),
(400, 'Cables', 'Blue'),
(500, 'Battery', 'Green'),
(600, 'CPU-Box', 'Black');

insert into Shipment values
(4, 100, 30000),
(5, 200, 25000),
(3, 400, 20000),
(4, 500, 17000),
(1, 300, 15000),
(2, 300, 20000),
(3, 500, 25000),
(4, 600, 22000);


-- QUERIES,

-- Query 1 : To find all suppliers who supply a 'green' part.
select sid, sname from Supplier where sid in 
    (select sid from Shipment where pid in
        (select pid from Part where color="Green")
    );

-- Query 2 : To find number of parts supplied by every supplier.
select sid, count(*) from Shipment group by(sid);
-- (OR)
select supp.sid, supp.name, count(*) from Supplier supp, Shipment ship where supp.sid = ship.sid group by ship.sid;
-- (OR)
select supp.sid, supp.sname, count(*) from Supplier supp NATURAL JOIN Shipment ship group by ship.sid;

-- Query 3 : To update tge part color supplied by Supplier 'S3' to yellow.
update Part set color = "Yellow" where pid in 
  (select pid from Shipment where sid in 
    (select sid from Supplier where sname="S3")
);