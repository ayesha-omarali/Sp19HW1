DROP VIEW IF EXISTS q0, q1i, q1ii, q1iii, q1iv, q2i, q2ii, q2iii, q3i, q3ii, q3iii, q4i, q4ii, q4iii, q4iv, q4v;

-- Question 0
CREATE VIEW q0(era) 
AS
  SELECT max(era)
  FROM pitching;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight > 300;
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  select namefirst, namelast, birthyear from people where namefirst like '% %';
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
SELECT birthyear, AVG(height), COUNT(*)  FROM people GROUP BY birthyear ORDER BY birthyear ASC;
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height) as avgheight, COUNT(*)  FROM people GROUP BY birthyear HAVING AVG(height) > 70 ORDER BY birthyear ASC;
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT namefirst, namelast, h.playerid, yearid FROM halloffame h, people p WHERE h.playerid = p.playerid AND h.inducted='Y' order by yearid desc;
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT p.namefirst, p.namelast, p.playerid, c.schoolid, p.yearid FROM q2i AS p, collegeplaying c, schools s  WHERE p.playerid=c.playerid AND c.schoolid=s.schoolid AND s.schoolstate = 'CA' ORDER BY p.yearid DESC, c.schoolid, p.playerid ASC;
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT q2i.playerid, namefirst, namelast, schoolid 
  FROM q2i LEFT JOIN collegeplaying on q2i.playerid = collegeplaying.playerid
  ORDER BY playerid DESC, schoolid ASC; 
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, b.yearid, cast(b.h - (b.h2b + b.h3b + b.hr) + (b.h2b * 2) + (b.h3b * 3) + (b.hr * 4) as float) / cast(b.ab as float) as slug FROM batting b, people p WHERE b.playerid = p.playerid AND b.ab > 50 ORDER BY slug DESC, b.yearid, p.playerid ASC LIMIT 10;
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT p.playerid, p.namefirst, p.namelast, CAST(SUM(b.h) - (SUM(b.h2b) + SUM(b.h3b) + SUM(b.hr)) + (SUM(b.h2b) * 2) + (SUM(b.h3b) * 3) + (SUM(b.hr) * 4) AS float) / CAST(SUM(b.ab) AS float) AS lifeslug FROM people p, batting b WHERE p.playerid=b.playerid GROUP BY p.playerid HAVING SUM(b.ab) > 50 ORDER BY lifeslug DESC, p.playerid ASC LIMIT 10;
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
 SELECT slug.namefirst, slug.namelast, slug.lifeslug FROM (SELECT p.playerid, p.namefirst, p.namelast, CAST(SUM(b.h) - (SUM(b.h2b) + SUM(b.h3b) + SUM(b.hr)) + (SUM(b.h2b) * 2) + (SUM(b.h3b) * 3) + (SUM(b.hr) * 4) AS float) / CAST(SUM(b.ab) AS float) AS lifeslug FROM people p, batting b WHERE p.playerid=b.playerid GROUP BY p.playerid HAVING SUM(b.ab) > 50) AS slug WHERE slug.lifeslug > (SELECT CAST(SUM(b.h) - (SUM(b.h2b) + SUM(b.h3b) + SUM(b.hr)) + (SUM(b.h2b) * 2) + (SUM(b.h3b) * 3) + (SUM(b.hr) * 4) AS float) / CAST(SUM(b.ab) AS float) AS lifeslug FROM people p, batting b WHERE p.playerid=b.playerid AND p.playerid='mayswi01');
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg, stddev)
AS
  SELECT yearid, MIN(salary), MAX(salary), AVG(salary), STDDEV(salary) FROM salaries
  GROUP BY yearid ORDER BY yearid ASC;
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
  SELECT FLOOR(CAST(salary / (SELECT max - min / 10 FROM q4i WHERE yearid='2016'))) AS bin FROM salaries WHERE yearid='2016' GROUP BY bin; 
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
  SELECT a.yearid, a.min - b.min, a.max - b.max, a.avg - b.avg FROM q4i a, q4i b WHERE b.yearid = a.yearid - 1 ORDER BY a.yearid ASC;
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
  SELECT 1, 1, 1, 1, 1 -- replace this line
;
-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT 1, 1 -- replace this line
;

