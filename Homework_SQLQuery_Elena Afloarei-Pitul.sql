
--1. Create a database
CREATE DATABASE MOVIE_DB

--DROP DATABASE MOVIE_DB

/*2. Create a table called Director with the folowing columns: 
FirstName, LastName, Nationality and Birthdate. 
Insert 5 rows into it.*/

--DROP TABLE Director
CREATE TABLE Director (
	ID int NOT NULL IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	Nationality nvarchar (50),
	BirthDate DATE,
	PRIMARY KEY(ID)	
	)

INSERT INTO Director VALUES('Ioana', 'Popescu', 'Romanian', '1990-10-10')
INSERT INTO Director VALUES('Alina', 'Pop', 'Hungarian', '1989-1-1')
INSERT INTO Director VALUES('Madalina', 'Enescu', 'Bulgarian', '1988-12-20')
INSERT INTO Director VALUES('Maria', 'Smith', 'French', '1995-08-08')
INSERT INTO Director VALUES('Georgiana', 'Ionescu', 'German', '1991-05-26')

--SELECT * FROM Director

--3. Delete the director with id = 3.
DELETE FROM Director WHERE ID = 3

/*4. Create a table called Movie with following columns: 
DirectorId, Title, ReleaseDate, Rating and Duration.
Each movie has a director. Insert some rows into it. */

--DROP TABLE Movie
CREATE TABLE Movie (
	ID int NOT NULL IDENTITY(1,1),
	DirectorId int NOT NULL,
	Title nvarchar(100) NOT NULL,
	ReleaseDate date NOT NULL,
	Rating float(1),
	Duration int,
	CONSTRAINT PK_Movie PRIMARY KEY (ID),
	CONSTRAINT FK_Movie_Director FOREIGN KEY (DirectorId) REFERENCES Director (ID)
	
	ON DELETE CASCADE
    ON UPDATE CASCADE)

SET NOCOUNT ON
INSERT INTO Movie VALUES (1, 'Welcome to Marwen', '2018-01-01', 6.1, 116)
INSERT INTO Movie VALUES (2, 'Bloodline', '2018-02-02', 6.0, 95)
INSERT INTO Movie VALUES (3, 'Bohemian Rhapsody', '2018-03-03', 8.0, 134)
INSERT INTO Movie VALUES (4, 'Mary Queen of Scots', '2018-04-04', 6.3, 124)
INSERT INTO Movie VALUES (5, 'Aquaman', '2018-05-05', 7.0, 143)
INSERT INTO Movie VALUES (6, 'A Simple Favour', '2018-06-06', 6.8, 117)
INSERT INTO Movie VALUES (7, 'The Predator', '2018-07-07', 5.4, 107)
INSERT INTO Movie VALUES (8, 'Deadpool 2', '2018-08-08', 7.7, 119)
INSERT INTO Movie VALUES (9, 'Deadpool', '2016-01-01', 8.2, 120)
INSERT INTO Movie VALUES (10, 'A Star Is Born', '2018-09-09', 7.7, 136)
INSERT INTO Movie VALUES (6, 'Black Panther', '2019-06-06', 10, 134)
INSERT INTO Movie VALUES (7, ' Avengers: Infinity War ', '2017-07-07', 10, 149)
INSERT INTO Movie VALUES (8, 'I Feel Pretty', '2017-08-08', 10, 110)
INSERT INTO Movie VALUES (9, 'A Quiet Place', '2016-01-01', 10, 90)
INSERT INTO Movie VALUES (10, ' Jumanji: Welcome to the Jungle', '2015-09-09', 10, 119)

--SELECT * FROM Movie

--5. Update all movies that have a rating lower than 10
UPDATE Movie
SET Title = UPPER(Title) 
WHERE Rating < 10

/*6. Create a table called Actor with following columns: 
FirstName, LastName, Nationality, Birthdate and PopularityRating. 
Insert some rows into it.*/

--DROP TABLE Actor
CREATE TABLE Actor (
	ID int NOT NULL IDENTITY(1,1),
	FirstName nvarchar(50) NOT NULL,
	LastName nvarchar(50) NOT NULL,
	Nationality nvarchar (50),
	BirthDate DATE,
	PopularityRating DECIMAL (5,2)
	PRIMARY KEY(ID) )

SET NOCOUNT ON
INSERT INTO Actor VALUES ('Judi', 'Dench', 'English', '1934-12-09', 80.2)
INSERT INTO Actor VALUES ('Nicole', 'Kidman', 'Australian', '1967-06-20', 40.5) 
INSERT INTO Actor VALUES ('Cate', 'Blanchett', 'Australian', '1969-05-14', 70)
INSERT INTO Actor VALUES ('Uma', 'Thurman', 'American', '1970-04-29', 50)
INSERT INTO Actor VALUES ('Tilda', 'Swinton', 'English', '1960-11-05', 30)
INSERT INTO Actor VALUES ('Charlize','Theron', 'South African', '1975-08-07', 60)
INSERT INTO Actor VALUES ('Julia','Louis-Dreyfus','American','1961-01-13',10.3)
INSERT INTO Actor VALUES ('Sandra', 'Oh','Canadian','1971-07-20',20.2)
INSERT INTO Actor VALUES ('Helen','Mirren','English','1945-07-26',90.9)
INSERT INTO Actor VALUES ('Meryl','Streep','American','1949-06-22',100)

--SELECT * FROM Actor

--7. Which is the movie with the lowest rating?

SELECT MOVIE.ID as Movie_ID, Title, Rating as Lowest_Rating
FROM Movie
WHERE Rating = (SELECT MIN(Rating) FROM Movie)


--8. Which director has the most movies directed?

SELECT Director.ID, CONCAT(FirstName,' ',LastName) as Full_Name, COUNT(Movie.ID) as No_Movies
FROM Director INNER JOIN Movie ON Director.ID = Movie.DirectorId
GROUP BY Director.ID, FirstName, LastName
HAVING COUNT(Movie.ID) = 
			(SELECT TOP(1) COUNT(Movie.ID) AS No_Movies
			FROM Director INNER JOIN Movie ON Director.ID = Movie.DirectorId
			GROUP BY Director.ID, FirstName, LastName
			ORDER BY No_Movies DESC)

--9. Display all movies ordered by director's LastName in ascending order, then by birth date descending.

SELECT Movie.Title, Director.FirstName, Director.LastName, Director.BirthDate FROM Movie LEFT JOIN Director ON Movie.DirectorId = Director.ID
ORDER BY LastName ASC, BirthDate DESC

--12. Create a stored procedure that will increment the rating by 1 for a given movie id.

CREATE PROCEDURE UpdateMovieRating @ID int
AS
BEGIN 
UPDATE Movie
SET Rating = Rating +1 
WHERE ID = @ID
END

EXEC UpdateMovieRating @ID = 4

--SELECT * FROM MOVIE


--15. Implement many to many relationship between Movie and Actor.

CREATE TABLE MovieActor 
		(
		 MovieId int NOT NULL,
		 ActorId int NOT NULL,
		 CONSTRAINT FK_MovieActor_Movie FOREIGN KEY (MovieId) REFERENCES Movie (ID),
		 CONSTRAINT FK_MovieActor_Actor FOREIGN KEY (ActorId) REFERENCES Actor (ID),
		 UNIQUE (MovieId, ActorId)
		)

--SELECT * FROM Movie
--SELECT * FROM Actor

INSERT INTO MovieActor VALUES(5,1)
INSERT INTO MovieActor VALUES(4,2)
INSERT INTO MovieActor VALUES(3,3)
INSERT INTO MovieActor VALUES(2,4)
INSERT INTO MovieActor VALUES(1,5)
INSERT INTO MovieActor VALUES(1,6)
INSERT INTO MovieActor VALUES(2,7)
INSERT INTO MovieActor VALUES(2,8)
INSERT INTO MovieActor VALUES(2,9)
INSERT INTO MovieActor VALUES(4,10)
INSERT INTO MovieActor VALUES(1,1)
INSERT INTO MovieActor VALUES(2,2)
INSERT INTO MovieActor VALUES(5,3)
INSERT INTO MovieActor VALUES(4,4)
INSERT INTO MovieActor VALUES(5,5)
INSERT INTO MovieActor VALUES(3,6)
INSERT INTO MovieActor VALUES(3,7)
INSERT INTO MovieActor VALUES(4,8)
INSERT INTO MovieActor VALUES(4,9)
INSERT INTO MovieActor VALUES(5,10)
INSERT INTO MovieActor VALUES(3,10)
INSERT INTO MovieActor VALUES(2,10)
INSERT INTO MovieActor VALUES(1,10)
INSERT INTO MovieActor VALUES(5,9)
INSERT INTO MovieActor VALUES(3,9)

--SELECT * FROM MovieActor

--16. Implement many to many relationship between Movie and Genre.

--DROP TABLE Genre
CREATE TABLE Genre
		(
		ID int NOT NULL IDENTITY(1,1),
		Name nvarchar(50)
		CONSTRAINT PK_Genre PRIMARY KEY (ID)
		)

INSERT INTO Genre VALUES ('Comedy')
INSERT INTO Genre VALUES ('Horror')
INSERT INTO Genre VALUES ('Action')
INSERT INTO Genre VALUES ('Thriller')
INSERT INTO Genre VALUES ('Romantic')
INSERT INTO Genre VALUES ('Adventure')
INSERT INTO Genre VALUES ('Crime')
INSERT INTO Genre VALUES ('Drama')
INSERT INTO Genre VALUES ('Fantasy')
INSERT INTO Genre VALUES ('Historical')
INSERT INTO Genre VALUES ('Historical fiction')
INSERT INTO Genre VALUES ('Mystery')
INSERT INTO Genre VALUES ('Philosophical')
INSERT INTO Genre VALUES ('Saga')
INSERT INTO Genre VALUES ('Satire')
INSERT INTO Genre VALUES ('Animation')

--SELECT * FROM Genre

--DROP TABLE MovieGenre

CREATE TABLE MovieGenre 
		(
		 MovieId int NOT NULL,
		 GenreId int NOT NULL,
		 CONSTRAINT FK_MovieGenre_Movie FOREIGN KEY (MovieId) REFERENCES Movie (ID),
		 CONSTRAINT FK_MovieGenre_Genre FOREIGN KEY (GenreId) REFERENCES Genre (ID),
		 UNIQUE (MovieId, GenreId)
		)

--SELECT * FROM Movie

INSERT INTO MovieGenre VALUES(1,1)
INSERT INTO MovieGenre VALUES(2,2)
INSERT INTO MovieGenre VALUES(3,3)
INSERT INTO MovieGenre VALUES(4,4)
INSERT INTO MovieGenre VALUES(5,5)
INSERT INTO MovieGenre VALUES(5,1)
INSERT INTO MovieGenre VALUES(4,2)
INSERT INTO MovieGenre VALUES(2,4)
INSERT INTO MovieGenre VALUES(1,5)
INSERT INTO MovieGenre VALUES(1,6)
INSERT INTO MovieGenre VALUES(2,7)
INSERT INTO MovieGenre VALUES(3,8)
INSERT INTO MovieGenre VALUES(4,9)
INSERT INTO MovieGenre VALUES(5,10)
INSERT INTO MovieGenre VALUES(2,1)
INSERT INTO MovieGenre VALUES(1,3)
INSERT INTO MovieGenre VALUES(1,4)
INSERT INTO MovieGenre VALUES(2,5)
INSERT INTO MovieGenre VALUES(2,6)
INSERT INTO MovieGenre VALUES(3,6)
INSERT INTO MovieGenre VALUES(4,6)
INSERT INTO MovieGenre VALUES(3,1)
INSERT INTO MovieGenre VALUES(1,2)

--SELECT * FROM MovieGenre

--17. Which actor has worked with the most distinct movie directors?

/*SELECT Actor.ID, COUNT(Movie.DirectorId) AS No_Directors, CONCAT(Actor.FirstName, ' ', Actor.LastName) AS FullName
FROM Actor 
	INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
	INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
GROUP BY Actor.ID, FirstName, LastName
HAVING COUNT(Movie.DirectorId) = 
(SELECT TOP (1) COUNT (DISTINCT Movie.DirectorId) AS No_Directors
FROM Actor 
INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
GROUP BY Actor.ID
ORDER BY No_Directors DESC)*/ 

SELECT TOP (1) COUNT (DISTINCT Movie.DirectorId) AS No_Directors, Actor.ID AS ID_Actor, CONCAT(Actor.FirstName, ' ', Actor.LastName) AS FullName 
			  FROM Actor 
				INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
				INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
				GROUP BY Actor.ID, FirstName, LastName
				ORDER BY No_Directors DESC	

/*SELECT * FROM Actor 
	INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
	INNER JOIN Movie ON MovieActor.MovieId = Movie.ID*/


--18. Which is the preferred genre of each actor?

/*CREATE VIEW Count_Genre_Each_Actor AS
SELECT Actor.ID AS ID_Actor, CONCAT(Actor.FirstName, ' ', Actor.LastName) AS FullName, COUNT(Genre.ID) AS No_Genre, Genre.Name
FROM Actor INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
		   INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
		   INNER JOIN MovieGenre ON Movie.ID = MovieGenre.MovieId
		   INNER JOIN Genre ON MovieGenre.GenreId = Genre.ID
GROUP BY Actor.Id, FirstName, LastName, Genre.Name*/
--SELECT *  FROM Count_Genre_Each_Actor

--DROP PROCEDURE ActorPreferredGenre

CREATE PROCEDURE ActorPreferredGenre @ID int
AS
BEGIN 
SELECT Actor.ID AS ID_Actor, CONCAT(Actor.FirstName, ' ', Actor.LastName) AS FullName, COUNT(Genre.ID) AS No_Genre, Genre.Name
FROM Actor INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
		   INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
		   INNER JOIN MovieGenre ON Movie.ID = MovieGenre.MovieId
		   INNER JOIN Genre ON MovieGenre.GenreId = Genre.ID
WHERE Actor.ID = @ID
GROUP BY Actor.Id, FirstName, LastName, Genre.Name
HAVING COUNT(Genre.ID) =  
			(SELECT TOP(1) Count(Genre.ID) AS No_Genre
			FROM Actor	INNER JOIN MovieActor ON Actor.ID = MovieActor.ActorId
						INNER JOIN Movie ON MovieActor.MovieId = Movie.ID
						INNER JOIN MovieGenre ON Movie.ID = MovieGenre.MovieId
						INNER JOIN Genre ON MovieGenre.GenreId = Genre.ID
			WHERE Actor.ID = @ID
			GROUP BY Actor.ID, FirstName, LastName, Genre.Name
			ORDER BY No_Genre DESC)
ORDER BY FullName ASC, Genre.Name ASC
END

--EXEC ActorPreferredGenre @ID = 1
--EXEC ActorPreferredGenre @ID = 2
--EXEC ActorPreferredGenre @ID = 3
--EXEC ActorPreferredGenre @ID = 4
--EXEC ActorPreferredGenre @ID = 5
--EXEC ActorPreferredGenre @ID = 6
--EXEC ActorPreferredGenre @ID = 7
--EXEC ActorPreferredGenre @ID = 8
--EXEC ActorPreferredGenre @ID = 9
--EXEC ActorPreferredGenre @ID = 10


DECLARE @ActorID int = 1 
DECLARE My_Cursor CURSOR
LOCAL STATIC READ_ONLY FORWARD_ONLY
FOR
SELECT DISTINCT Count_Genre_Each_Actor.ID_Actor
FROM Count_Genre_Each_Actor
OPEN My_Cursor
FETCH NEXT FROM My_Cursor INTO @ActorID
WHILE @@FETCH_STATUS = 0
BEGIN	
	EXEC ActorPreferredGenre @ActorID
	PRINT @ActorID
	FETCH NEXT FROM My_Cursor INTO @ActorID	
END
CLOSE My_Cursor
DEALLOCATE My_Cursor