
-- 290125
-- Sailor DB.

CREATE TABLE IF NOT EXISTS Sailor(
	sid int primary key,
	sname varchar(15),
	rating float, 
	age int
);

CREATE TABLE IF NOT EXISTS Boats(
	bid int primary key, 
	bname varchar(20), 
	color varchar(10)
);

CREATE TABLE IF NOT EXISTS Reserves(
	sid int, bid int, day varchar(10),
	foreign key(sid) references Sailor(sid) on update cascade on delete set null,
	foreign key(bid) references Boats(bid) on update cascade on delete set null
);

INSERT INTO Sailor VALUES
(1, 'Ajay', 4.7, 27),
(2, 'Bharath', 4.5, 24),
(3, 'Chetta', 4.8, 28),
(4, 'Deep', 4.2, 26),
(5, 'Eesha', 4.6, 29);

INSERT INTO Boats VALUES
(101, 'The Black Pearl', 'Black'),
(202, 'The Voyager', 'Red'),
(303, 'The Silent Mary', 'Green'),
(404, 'The Interceptor', 'Brown'),
(505, 'The Flying Dutchman', 'Green');

INSERT INTO Reserves VALUES
(2, 202, 'Monday'),
(5, 303, 'Tuesday'),
(1, 404, 'Wednesday'),
(2, 303, 'Thursday'),
(1, 101, 'Friday');

SELECT * FROM Sailor;
SELECT * FROM Boats;
SELECT * FROM Reserves;


--Query 1 : Finding sailors who have reserved atleast one boat.
SELECT sid, sname FROM Sailor
	where sid in (SELECT (sid) FROM Reserves);

--Query 2 : Finding the sid of sailors who have reserved a red or green boat.
SELECT sid, sname FROM Sailor
	where sid in (
		SELECT sid FROM Reserves
			where bid in (SELECT bid FROM Boats where color = 'Red' or color = 'Green')
	) order by sid;



SELECT * FROM Boats; 

--Query 3 : Funding the sid of sailors who have not reserved a boat.
SELECT sid, sname FROM Sailor
	where sid not in (SELECT (sid) FROM Reserves);
