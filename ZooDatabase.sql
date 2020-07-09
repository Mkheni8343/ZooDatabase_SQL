
/*THIS IS A SIMPLE ZOO DATABASE MAJORLY FOR CANADIAN ZOO, WHICH IS CREATED BY MITUL KHENI AS PART OF FINAL SUBMISSION */
/*UPDATED ON 4-28-2020*/

USE Master;
SET NOCOUNT ON;
GO
PRINT '>>> Does a Zoo database already exist?';
GO 
IF EXISTS (SELECT "name"
           FROM Sysdatabases
           WHERE "name" = 'Zoo')    
    BEGIN
        PRINT '>>> Yes, a Zoo database already exists';
        PRINT '>>> Rolling back pending Zoo transactions';
         
        ALTER DATABASE Zoo
            SET SINGLE_USER
            WITH ROLLBACK IMMEDIATE;
 
        PRINT '>>> Dropping the existing Zoo database';   
        
        DROP DATABASE Zoo;
    END
ELSE
    BEGIN
        PRINT '>>> No, there is no Zoo database';    
    END

GO
CREATE DATABASE Zoo;
Print '>>> ZOO DATABASE CREATED';

Print '>>> Added Animal Schema in Zoo database';
USE Zoo
GO
	CREATE SCHEMA Animal

Print '>>> Creation of Tables';

PRINT 'TABLE 1';
PRINT '>>> Employee Table';
PRINT '>>> ADDED DEFAULT SALARY 0';
USE Zoo
GO
	CREATE TABLE Animal.Employee (
		ID	INT IDENTITY NOT NULL,
		FirstName NVARCHAR(255) NOT NULL,
		LastName NVARCHAR(255) NOT NULL,
		Contact NCHAR(15),
		Salary SMALLMONEY DEFAULT 0,
		Position VARCHAR(255) NOT NULL,

		CONSTRAINT PK_EmployeeID PRIMARY KEY (ID),
		CONSTRAINT CK_salary CHECK (Salary >= 0)
	)

PRINT 'TABLE 2';
PRINT '>>> Species Table';
PRINT '>>> ADDED DEAULT NUMBER OF EXISTS 0';

USE Zoo
GO
	CREATE TABLE Animal.Species (
		ID INT IDENTITY NOT NULL,
		Name VARCHAR(255) NOT NULL,
		Status CHAR(3) NOT NULL,
		TotalExists INT DEFAULT 0,

		CONSTRAINT PK_SpeciesID PRIMARY KEY (ID),
		CONSTRAINT CK_TotalExists CHECK (TotalExists >= 0),
		CONSTRAINT UK_SpeciesName UNIQUE (Name)
	)

PRINT 'TABLE 3';
PRINT '>>> Country Table';

USE Zoo
GO
	CREATE TABLE Animal.Country (
		ID INT IDENTITY NOT NULL,
		Name VARCHAR(255) NOT NULL,

		CONSTRAINT PK_CountryID PRIMARY KEY (ID),
		CONSTRAINT UK_CountryName UNIQUE (Name)
	)

PRINT 'TABLE 4';
PRINT '>>> Zoo Table';

USE Zoo
GO
	CREATE TABLE Animal.Zoo (
		ID INT IDENTITY NOT NULL,
		Name VARCHAR(255) NOT NULL,
		City VARCHAR(255) NOT NULL,
		CountryID INT NOT NULL,

		CONSTRAINT PK_ZooID PRIMARY KEY (ID),
		CONSTRAINT FK_CountryID FOREIGN KEY (CountryID) REFERENCES Animal.Country(ID)
	)

PRINT 'TABLE 5';
PRINT '>>> Animal Table';
PRINT '>>> DEFAULT Year of animal is 0'

USE Zoo
GO
	CREATE TABLE Animal.Animal(
		ID INT IDENTITY NOT NULL,
		SpeciesID INT NOT NULL,
		ZooID INT NOT NULL,
		AnimalName VARCHAR(255) NOT NULL,
		Year SMALLINT DEFAULT 0,
		Gender CHAR(2),

		CONSTRAINT PK_AnimalID PRIMARY KEY (ID),
		CONSTRAINT FK_SpeciesID FOREIGN KEY (SpeciesID) REFERENCES Animal.Species(ID),
		CONSTRAINT FK_ZooID FOREIGN KEY (ZooID) REFERENCES Animal.Zoo(ID)
	)

PRINT 'TABLE 6';
PRINT '>>> Contract Table';
PRINT '>>> ADDED DEFAULT on DATE';

USE Zoo
GO
	CREATE TABLE Animal.Contract (
		ID INT IDENTITY NOT NULL,
		EmployeeID INT NOT NULL,
		ZooID INT NOT NULL,
		StartDate DATE DEFAULT CONVERT(DATE, GETDATE()),

		CONSTRAINT PK_ContractID PRIMARY KEY (ID),
		CONSTRAINT FK_ContractEmployeeID FOREIGN KEY (EmployeeID) REFERENCES Animal.Employee(ID),
		CONSTRAINT FK_ContractZooID FOREIGN KEY (ZooID) REFERENCES Animal.Zoo(ID)
	)

PRINT 'TABLE 7';
PRINT '>>> Animal CareTaker Table';

USE Zoo
GO
	CREATE TABLE Animal.AnimalCareTaker (
		ID INT IDENTITY NOT NULL,
		AnimalID INT NOT NULL,
		EmployeeID INT NOT NULL,

		CONSTRAINT PK_CareTakerID PRIMARY KEY (ID),
		CONSTRAINT FK_CareTakerAnimalID FOREIGN KEY (AnimalID) REFERENCES Animal.Animal(ID),
		CONSTRAINT FK_CareTakerEmployeeID FOREIGN KEY (EmployeeID) REFERENCES Animal.Employee(ID)
	)

PRINT 'TABLE 8';
PRINT '>>> Image Table';
PRINT '>>> VarBinary';

USE Zoo
GO
	CREATE TABLE Animal.EmpImage (
		ID INT IDENTITY NOT NULL,
		EmployeeID INT NOT NULL,
		EmpImage VARBINARY(MAX),
		
		CONSTRAINT PK_ImageID PRIMARY KEY (ID),
		CONSTRAINT FK_ImageEmployeeID FOREIGN KEY (EmployeeID) REFERENCES Animal.Employee(ID)
	)

PRINT 'TABLE 9';
PRINT '>>> REPORT TABLE';

USE Zoo
GO
	CREATE TABLE Animal.ZooReport (
		ID INT IDENTITY NOT NULL,
		ZooID INT NOT NULL,
		Income INT DEFAULT 0,
		Outcome INT DEFAULT 0,
		Visitors INT DEFAULT 0,
		Year SMALLINT DEFAULT DATEPART(year,GETDATE()) NOT NULL,

		CONSTRAINT PK_ZooReportID PRIMARY KEY (ID),
		CONSTRAINT FK_ZooReportZooID FOREIGN KEY (ZooID) REFERENCES Animal.Zoo(ID)
	)

PRINT 'TABLE 10';
PRINT '>>> ANIMAL IMAGE TABLE';
USE Zoo
GO
	CREATE TABLE Animal.AnimalImage	(
		ID INT IDENTITY NOT NULL,
		AnimalID	INT NOT NULL,
		AnimalImg VARBINARY(MAX),

		CONSTRAINT PK_AnimalImageID PRIMARY KEY (ID),
		CONSTRAINT FK_AnimalImgAnimalID FOREIGN KEY (AnimalID) REFERENCES Animal.Animal(ID)
	)

PRINT '>>> ALL TABLE HAS BEEN CREATED SUCCESSFULLY'

PRINT '>>> INDEX #1 In_EmployeeName';
PRINT '>>> INDEX FOR EMPLOYEE FIRST_NAME AND LASTNAME';

USE Zoo
GO
	CREATE INDEX In_EmployeeName
	ON Animal.Employee (firstname,lastname);

PRINT '>>> INDEX #2 In_TotalNumberExists';
PRINT '>>> INDEX FOR 2 COLUMNS ON SPECIES TABLE';

USE Zoo
GO
	CREATE INDEX In_TotalNumberExists
	ON Animal.Species (Name,TotalExists);

PRINT '>>> INDEX #3 In_AnimalName';
PRINT '>>> INDEX FOR SINGLE COLUMNS ON ANIMAL NAME TABLE';

USE Zoo
GO
	CREATE INDEX In_AnimalName
	ON Animal.Animal (AnimalName);

PRINT '>>> Start Inserting Records in Tables';
PRINT '>>> Insert Records in Employee Table Begins';

USE Zoo
GO
	BEGIN TRAN
	INSERT INTO Animal.Employee (FirstName,LastName,Contact,Salary,Position)
						VALUES	('John','Wick','226-988-0000',70000,'Zoo Director'),
								('Mitul','Kheni','226-988-0001',45000,'DBA'),
								('Alexis','Richards','519-781-4979',50000,'Human Resource Director'),
								('Roberto','Tamburello','226-988-0002',45000,'Nutrition Director'),
								('Gail','Erickson','226-988-0003',40000,'Animal Supervisor'),
								('Jossef','Goldberg','226-988-0004',40000,'Bird Supervisor'),
								('Diane','Margheim','226-988-0005',30000,'Day Keeper'),
								('Ovidiu','Cracium','226-988-0006',30000,'Day Keeper'),
								('John','Potter','226-988-0007',30000,'Day Keeper'),
								('Peter','Wood','226-988-0008',30000,'Day Keeper'),
								('Peter','Parker','226-988-0009',30000,'Day Keeper'),
								('Mary','Gibson','226-988-0010',30000,'Night Keeper'),
								('James','Wood','226-988-0011',30000,'Night Keeper'),
								('James','Potter','226-988-0012',30000,'Night Keeper'),
								('Harry','Potter','226-988-0013',30000,'Night Keeper'),
								('Harry','Smith','226-988-0014',30000,'Pest Control'),
								('Erza','Scarlet','226-988-0015',40000,'Electrical Supervisor')
	COMMIT

PRINT '>>> Employee Table Ends';
PRINT '>>> SELECT DATA FROM EMPLOYEE';
USE Zoo
GO
	SELECT *
	FROM Animal.Employee


PRINT '>>> Insert Records in Species Table Begins';

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Species	(Name,Status,TotalExists)
							VALUES	('Alagoas curassow','EW',521),
									('Elephant','LC',102040),
									('Royal Bengal Tiger','EN',21000),
									('Tiger','LC',300000),
									('Lion','LC',351230),
									('Asiatic Lion','EN',350000),
									('Hippopotamus','LC',632054),
									('Brown Bear','LC',523064),
									('Kolala','NT',352604),
									('Jaguar','NT',142360),
									('Wolf','LC',365220),
									('Black rhinoceros','CR',100)
	COMMIT

PRINT '>>> Species Table Ends';
PRINT '>>> SELECT DATA FROM EMPLOYEE';
USE Zoo
GO
	SELECT *
	FROM Animal.Species

PRINT '>>> Insert Records in Country Table Begins'

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Country	(Name)
							VALUES	('Canada'),
									('US'),
									('Mexico'),
									('Brazil'),
									('India'),
									('Russia'),
									('Poland'),
									('Germany'),
									('UK'),
									('Ireland'),
									('China'),
									('Switzerland'),
									('Ukrain'),
									('Greece'),
									('Italy'),
									('France'),
									('Denmark'),
									('Sweden'),
									('Finland'),
									('Norway'),
									('Iceland')
	COMMIT

PRINT '>>> Country Table Ends';
PRINT '>>> SELECT DATA FROM Country';
USE Zoo
GO
	SELECT *
	FROM Animal.Country
	ORDER BY ID

PRINT '>>> Insert Records in Zoo Table Begins'

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Zoo	(Name,City,CountryID)
						VALUES	('Toronto Zoo','Scarborough',1),
								('Oshawa Zoo','Oshawa',1),
								('Calgary Zoo','Calgary',1),
								('Vancouver Zoo','Vancouver',1),
								('Zoo Berlin','Berlin',8),
								('ZSL London Zoo','London',9),
								('Bronx Zoo','New York',2),
								('Indianapolis Zoo','Indianapolis',2),
								('National Zoological Park','New Delhi',5),
								('Zoo de Granby','Granby',1)
	COMMIT

PRINT '>>> Zoo Table Ends'
PRINT '>>> SELECT DATA FROM Zoo';
USE Zoo
GO
	SELECT *
	FROM Animal.Zoo
	ORDER BY ID

PRINT '>>> Insert Records in Animal Table Begins'

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Animal	(SpeciesID,ZooID,AnimalName,Year,Gender)
							VALUES	(1,1,'Alagana',2019,'F'),
									(2,1,'Kaido',2002,'M'),
									(2,1,'Big Mom',2001,'F'),
									(2,1,'Baby Bee',2018,'F'),
									(3,1,'Bindi',2008,'F'),
									(3,1,'Bageera',2007,'M'),
									(5,1,'Simba',2018,'M'),
									(5,1,'Mufasa',2003,'M'),
									(5,1,'Sarabi',2003,'F'),
									(10,1,'Sid',2005,'M'),
									(10,1,'Sylvia',2006,'F')
	COMMIT

PRINT '>>> Animal Table Ends';
PRINT '>>> SELECT DATA FROM Animal';
USE Zoo
GO
	SELECT *
	FROM Animal.Animal
	ORDER BY ID

PRINT '>>> Insert Records in Contract Table Begins';

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Contract (EmployeeID,ZooID,StartDate)
							VALUES	(1,1,'2003-01-01'),
									(2,1,'2018-10-01'),
									(3,1,'2003-01-01'),
									(4,1,'2004-07-01'),
									(5,1,'2003-01-01'),
									(6,1,'2003-01-01'),
									(7,1,'2006-06-01'),
									(8,1,'2009-07-01'),
									(9,1,'2010-07-01'),
									(10,1,'2011-08-01'),
									(11,1,'2011-08-01'),
									(12,1,'2006-09-01'),
									(13,1,'2005-07-01'),
									(14,1,'2009-10-01'),
									(15,1,'2012-10-01'),
									(16,1,'2014-12-01'),
									(17,1,'2018-04-01')
	COMMIT

PRINT '>>> Contract Table Ends';
PRINT '>>> SELECT DATA FROM Contract';
USE Zoo
GO
	SELECT *
	FROM Animal.Contract
	ORDER BY ID

PRINT '>>> Insert Records in CareTaker Table Begins';

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.AnimalCareTaker	(AnimalID,EmployeeID)
									VALUES	(1,6),
											(1,7), 
											(2,8),
											(2,5),
											(3,9),
											(3,10),
											(4,10),
											(4,12),
											(5,11),
											(5,12),
											(6,12),
											(6,9),
											(7,13),
											(7,14),
											(8,14),
											(8,15),
											(9,15),
											(10,10),
											(11,8),
											(11,11)
	COMMIT

PRINT '>>> Care Taker Table Ends';
PRINT '>>> SELECT DATA FROM AnimalCareTaker';
USE Zoo
GO
	SELECT *
	FROM Animal.AnimalCareTaker
	ORDER BY ID

PRINT '>>> Insert Records in Image Table Begins';

-------------------------------------------------------------------
----- FUN DATA OF THE SEMESETER---- (MITUL KHENI)
--- Most interesting website in the world  https://thispersondoesnotexist.com/
--  which use GAN (generative adversarial network) AI network to generate a facial image of a person which does not exists in real life.
--  refresh page everytime to generate new images
--------------------------------------------------------------------

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.EmpImage	(EmployeeID,EmpImage)
							VALUES	(1,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img1.jpg', SINGLE_BLOB) AS image)),
									(2,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img2.jpg', SINGLE_BLOB) AS image)),
									(3,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img3.jpg', SINGLE_BLOB) AS image)),
									(4,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img4.jpg', SINGLE_BLOB) AS image)),
									(5,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img5.jpg', SINGLE_BLOB) AS image)),
									(6,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img6.jpg', SINGLE_BLOB) AS image))
	COMMIT

PRINT '>>> EmployeeImage Table Ends';
PRINT '>>> SELECT DATA FROM Employee Image Table';
USE Zoo
GO
	SELECT *
	FROM Animal.EmpImage
	ORDER BY ID

PRINT '>>> Insert Records in Animal Image Table Begins';
USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.AnimalImage (AnimalID,AnimalImg)
							VALUES	(1,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img1.jpg', SINGLE_BLOB) AS image)),
									(2,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img2.jpg', SINGLE_BLOB) AS image)),
									(3,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img3.jpg', SINGLE_BLOB) AS image)),
									(4,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img4.jpg', SINGLE_BLOB) AS image)),
									(5,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img5.jpg', SINGLE_BLOB) AS image)),
									(6,(SELECT * FROM OPENROWSET (Bulk 'D:\photos\img6.jpg', SINGLE_BLOB) AS image))
	COMMIT
PRINT '>>> AnimalImage Table Ends';
PRINT '>>> SELECT DATA FROM Animal Image Table';
USE Zoo
GO
	SELECT *
	FROM Animal.AnimalImage
	ORDER BY ID

PRINT '>>> Insert Records in Report Table Begins';

USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.ZooReport(ZooID,Income,Outcome,Visitors,Year)
							VALUES	(1,8000000,6700000,11000210,2019),
									(1,8700000,6800000,10000021,2018),
									(1,7800000,6500000,8056457,2017),
									(1,7700000,5600000,9856475,2016),
									(1,8000000,7000000,8756451,2015),
									(2,6000000,5000000,8956466,2019),
									(2,6500000,4800000,9756484,2018),
									(3,7000000,6700000,6956433,2019),
									(4,9000000,5500000,8956457,2019),
									(5,5600000,4800000,9856422,2019),
									(5,5200000,4600000,9956471,2018),
									(6,7800000,6700000,8256496,2019)
	COMMIT

PRINT '>>> Report Table Ends';
PRINT '>>> INSERT OPERATION COMPLETED SUCCESSFULLY';

PRINT '>>> SELECT DATA FROM  Report Table';
USE Zoo
GO
	SELECT *
	FROM Animal.ZooReport
	ORDER BY ID

PRINT'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>';
PRINT'FINAL ASSIGNMENT QUESTIONS BEGINS';
PRINT'QUESTION 1 : SELECET WITH WHERE FOR SINGLE TABLE';

/* For this question I am retriving Species which has status as 'Least concern' 
   in decending order by species total exists number in wild.
*/

USE Zoo
GO
	SELECT *
	FROM Animal.Species
	WHERE Status = 'LC'
	ORDER BY TotalExists DESC

PRINT'>>> Question 2: SELECT FOR MORE THAN 2 TABLES';
/* IN this Query I have select employee FULLNAME and employee's asscoiated animal 
with it's species name and animal name and shown that data ascending order by species name
*/

USE Zoo
GO
	SELECT DISTINCT E.FirstName+' , '+E.LastName AS EmployeeName, S.Name AS SpeciesName, A.AnimalName AS AnimalName
	FROM Animal.Employee AS E
		INNER JOIN Animal.AnimalCareTaker AS ACT
			ON ACT.EmployeeID = E.ID
		INNER JOIN Animal.Animal AS A
			ON A.ID = ACT.AnimalID
		INNER JOIN Animal.Species AS S
			ON S.ID = A.SpeciesID
		WHERE S.Status = 'LC'
		ORDER BY SpeciesName

PRINT'>>> QUESTION 3 : OUTERJOIN -> LEFT JOIN';
/*
In this question I have retrived data of FEMALE Animal including female animals which do not have images
order by its speciesID
*/
USE Zoo
GO
	SELECT A.ID,A.SpeciesID,A.AnimalName,AI.AnimalImg
	FROM Animal.Animal AS A
		LEFT JOIN Animal.AnimalImage AS AI
			ON A.ID = AI.AnimalID
		WHERE A.Gender = 'F'
		ORDER BY A.SpeciesID ASC

PRINT'>>> QUESTION 4 : SELECT WITH LIKE, AN AGGREGATE FUNCTION, GROUPBY, HAVING and 3 RECORDS OUT OF 5 RECORDS, !! Whew !!';

/*
 In this query I have retrive 3 records of employee by postion which does not belongs to any supervisor and DBA positions
 and who has more than 30000 annual salary using NOT,LIKE,SUM,ORDERBY,GROUPBY,HAVING,OFFSET and FETCH commands.

 So, A zoo director can indentify how much they are spending on certain employees.
 with row set I have retrive only 3 records from total 5 records.
 You can check it by run it without offset part.
*/

USE Zoo
GO
	SELECT Position, SUM(Salary) AS YearlySpending 
	FROM Animal.Employee 
	WHERE Position <> 'dba'
	GROUP BY Position
	HAVING SUM(Salary)>30000 AND Position NOT LIKE '%super%'
	ORDER BY Position, SUM(Salary) DESC
		OFFSET 0 ROWS
		FETCH FIRST 3 ROWS ONLY


PRINT'>>>QUESTION 5:  UINION KEYWORD';

/*
I am using UNION ALL command because i have inserted same 6 images for employee and animal.
Thus without 'ALL' keyword it will only return 6 records. 
But i want to show all images from employee as well as animal table thus I am using ALL keyword in UNION.

This query will return all images of employees as well as species 
*/

USE Zoo
GO
	SELECT EmpImage
	FROM Animal.EmpImage
	UNION ALL
	SELECT AnimalImg
	FROM Animal.AnimalImage


PRINT'>>> QUESTION 6: SUBQUERY PART 1 (IN WHERE CONDITION)';
/*
Retrive all records of employee Who has images in image table
sorted by salary in descending order
*/

USE Zoo
GO
	SELECT *
	FROM Animal.Employee
	WHERE ID IN (
				SELECT ID 
				FROM Animal.EmpImage
				WHERE EmpImage IS NOT NULL
				)
	ORDER BY Salary DESC

PRINT'>>> QUESTION 6 : SUBQUERY PART 2 OUTSIDE WHERE CONDITION';
/*
 Retrive Animal records from animal table with thier species Name
 and sort by animal's species name
*/

USE Zoo
GO
	SELECT	ID,
			AnimalName,
			Year,
			Gender, 
			(SELECT Name
				FROM Animal.Species
				WHERE Species.ID = Animal.SpeciesID) AS SpeciesName
	FROM Animal.Animal
	ORDER BY SpeciesName ASC

PRINT'>>> Question II : FUNCTIONS , VIEWS AND STORE PROCEDURES';
PRINT'>>> PART 1 : FUNCTION';
PRINT'>>> FUNCTION FOR COUNT SPECIFIC ANIMAL-TYPE IN A SPECIFIC ZOO';

USE Zoo
GO
	CREATE FUNCTION Animal.Fn_CountAnimals(
		@speciesID INT,
		@zooID INT
	)
	RETURNS INT AS 
		BEGIN 
			DECLARE @totalNumberOfAnimals INT;
			SELECT @totalNumberOfAnimals = COUNT(SpeciesID)
			FROM Animal.Animal
			WHERE SpeciesID= @speciesID AND ZooID = @zooID
			RETURN @totalNumberOfAnimals
		END;

PRINT'>>> CALLING FUNCTION  TO COUNT TOTAL-ANIMALS WHICH HAS ANIMAL ID 2 AND ZOO ID 1';
USE Zoo
GO
	SELECT Animal.Fn_CountAnimals(2,1) AS TotalAnimalInZoo

PRINT'>>> PART 2: ENCRYPTED VIEW USING FUNCTION WHICH CREATED ABOVE FOR COUNT SPECIFIC ANIMAL IN A SPECIFIC ZOO';
USE Zoo
GO
	CREATE VIEW Animal.vAnimalsWithTotalNumbers
	WITH ENCRYPTION
	 AS
		SELECT	A.SpeciesID,
			S.Name,
			(SELECT Animal.Fn_CountAnimals(A.SpeciesID,A.ZooID)) AS TotalAnimalInZoo
		FROM Animal.Animal AS A
			INNER JOIN Animal.Species AS S
			ON S.ID = A.SpeciesID
		GROUP BY A.SpeciesID,S.Name,A.ZooID

PRINT'>>> SELECT DATA FROM VIEW';
USE Zoo
GO
	SELECT * FROM Animal.vAnimalsWithTotalNumbers;

PRINT'>>> PROCEDURE WITH PAPRAMETERS AND DEFAULT VALUE';
USE Zoo
GO
	CREATE PROCEDURE Animal.sp_ZooReport
		@reportYear AS INT = Null,
		@zooID	AS INT = Null
	AS
	BEGIN
		IF @reportYear IS NULL AND @zooID IS NULL
			SELECT Z.Name,Z.City,ZR.Income,ZR.Outcome,ZR.Visitors,ZR.Year
			FROM Animal.ZooReport AS ZR
				INNER JOIN Animal.Zoo AS Z
					ON Z.ID = ZR.ZooID
			ORDER BY ZR.ZooID ASC,ZR.Year DESC

		ELSE IF @reportYear IS NOT NULL AND @zooID IS NULL
			SELECT Z.Name,Z.City,ZR.Income,ZR.Outcome,ZR.Visitors
			FROM Animal.ZooReport AS ZR
				INNER JOIN Animal.Zoo AS Z
					ON Z.ID = ZR.ZooID
			WHERE ZR.Year = @reportYear
			ORDER BY ZR.Year DESC

		ELSE
			SELECT Z.Name,Z.City,ZR.Income,ZR.Outcome,ZR.Visitors
			FROM Animal.ZooReport AS ZR
				INNER JOIN Animal.Zoo AS Z
					ON Z.ID = ZR.ZooID
			WHERE ZR.Year = @reportYear AND ZooID = @zooID
			ORDER BY ZR.Year DESC
	END;


PRINT'>>> EXECUTING PROCEDURE';

PRINT'>>> WITHOUT PARAMETER EXECUTION';
USE Zoo
GO
	EXECUTE Animal.sp_ZooReport;

PRINT'>>> WITH 1 PARAMETER EXECUTION WITH YEAR AS 2019';
USE Zoo
GO
	EXECUTE Animal.sp_ZooReport 2019;

PRINT'>>> WITH 2 PARAMETER EXECUTION WITH YEAR AS 2019 AND ZOO ID AS 1';
USE Zoo
GO
	EXECUTE Animal.sp_ZooReport 2019,1;

PRINT'>>> QUESTION III : MANIPULATION OF MEANING FULL DATA IN MY DATABASE';
PRINT'>>> HOW TO INSERT EMPLOYEE DATA IN TABLE';

/*BE CAREFUL THIS IS ONE T-SQL QUERY EXECUTE AS A WHOLE 
   IT WILL ROLLBACK AUTOMATICALLY WHEN ALL QUERY EXECUTED  */

USE Zoo
GO
	BEGIN TRAN
	  
		INSERT INTO Animal.Employee (FirstName,LastName,Contact,Salary,Position)
			VALUES	('MARK','MORELL','226-988-0030',65000,'DBA'), -- SINGLE VALUE
					('DAVID','ALLISON','226-988-0030',81000,'HEAD OF SECURITY') -- MULTIPLEVALUE
		
		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Employee

		
		UPDATE Animal.Employee 
			SET Position = 'DA'
		WHERE FirstName = 'MARK' AND LastName = 'MORELL'

		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Employee
		
		
		DELETE FROM Animal.Employee
		WHERE FirstName = 'DAVID' AND LastName = 'ALLISON'  -- DONT FORGOT LASTNAME AS WELL.
		
		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Employee
		
		INSERT INTO Animal.Species	(Name,Status,TotalExists)
							VALUES	('Peacock','LC',1547856),
									('Black Panther','EN',72)

		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Species

		/* CHANGE SPECIES STATUS FROM LEAST CONCERN TO ENDANGER FOR PEACOCK*/
		UPDATE Animal.Species 
			SET Status = 'EN'
		WHERE Name = 'Peacock'

		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Species

		/*DELETE MULTIPLE DATA*/
		DELETE FROM Animal.Species
		WHERE Name = 'Peacock' AND Name = 'Black panther'
		
		/*VIEW CHANGES*/
		SELECT * 
		FROM Animal.Species
	
		SELECT *
		FROM Animal.Employee
			INNER JOIN Animal.EmpImage 
				ON EmpImage.EmployeeID = Employee.ID
		WHERE EmpImage.EmpImage IS NOT NULL

	ROLLBACK; --UNDO ALL CHANGES
	
		/*THIS IS HOW YOU CAN DO BASIC OPERATION IN RDBMS, GOOD LUCK !! */

PRINT'>>> ROLLBACK COMPLETED';


PRINT'>>> QUESTION IV : ADD 2 TABLES INTO ZOO DATABASE'
PRINT'>>> ADDING SPECIALITY TABLE INTO DATABASE';
USE Zoo
GO
	CREATE TABLE Animal.Speciality(
		ID INT IDENTITY NOT NULL,
		EmployeeID INT NOT NULL,
		SpeciedID INT NOT NULL,
		
		CONSTRAINT PK_SpecialityID PRIMARY KEY (ID),
		CONSTRAINT FK_SpecialityEmpID FOREIGN KEY (EmployeeID) REFERENCES Animal.Employee(ID),
		CONSTRAINT FK_SpecialitySpeciesID FOREIGN KEY (SpeciedID) REFERENCES Animal.Species(ID)
	)


PRINT'>>> ADDING TOTALDATA TABLE INTO DATABASE';
USE Zoo
GO
	CREATE TABLE Animal.TotalData(
		ID INT IDENTITY NOT NULL,
		ZooID INT NOT NULL,
		TotalAnimal INT NOT NULL,
		TotalEmployee INT NOT NULL,
		TotalSpecies INT NOT NULL,

		CONSTRAINT PK_TotalID PRIMARY KEY (ID),
		CONSTRAINT FK_TotalZooID FOREIGN KEY (ZooID) REFERENCES Animal.Zoo(ID),
		CONSTRAINT CK_TotalCheckAnimal CHECK (TotalAnimal >= 0),
		CONSTRAINT CK_TotalCheckEmployee CHECK (TotalEmployee >= 0),
		CONSTRAINT CK_TotalCheckSpecies CHECK (TotalSpecies >= 0)
	)


PRINT'>>> START INSERTING OPERATION INTO NEWLY TABLES';
PRINT'>>> INSERT DATA INTO SPECIALITY TABLE';
USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.Speciality	(EmployeeID,SpeciedID)
								VALUES	(7,2),
										(8,2),
										(10,10)
	COMMIT


PRINT'>>> VIEW DATA';
USE Zoo
GO
	SELECT *
	FROM Animal.Speciality


PRINT'>>> FOR INSERTING INTO TOTAL TABLE IS COMPLEX THUS IT REQUIRED FUNCTION';
/* I HAVE CREATED 3 SEPERATE FUNCTIONS TO STORE DATA USING ZOO ID AS A PARAMETER */

/* FUNCTION 1 : COUNT TOTAL ANIMALS INTO A PARTICULAR ZOO */
USE Zoo
GO
	CREATE FUNCTION Animal.Fn_TotalAnimals(
		@zooId INT
	)
	RETURNS INT AS
		BEGIN
			DECLARE @totalAnimals INT;
			SELECT @totalAnimals = COUNT(ID)
			FROM Animal.Animal
			WHERE ZooID = @zooId
			RETURN @totalAnimals
		END;

/* FUNCTION 2 : COUNT TOTAL EMPLOYEES INTO A PARTICULAR ZOO */
USE Zoo
GO
	CREATE FUNCTION Animal.Fn_TotalEmployees(
		@zooId INT
	)
	RETURNS INT AS
		BEGIN
			DECLARE @totalEmployees INT;
			SELECT @totalEmployees = COUNT(E.ID)
			FROM Animal.Employee AS E
				INNER JOIN Animal.Contract AS C
				ON C.EmployeeID = E.ID
			WHERE C.ZooID = @zooId
			RETURN @totalEmployees 
		END;

/* FUNCTION 3 : COUNT TOTAL SPECIES INTO A PARTICULAR ZOO */
USE Zoo
GO
	CREATE FUNCTION Animal.Fn_TotalSpecies(
		@zooId INT
	)
	RETURNS INT AS
		BEGIN
			DECLARE @totalSpecies INT;
			SELECT @totalSpecies = COUNT(DISTINCT SpeciesID)
			FROM Animal.Animal
			WHERE ZooID = @zooId
			RETURN @totalSpecies 
		END;


PRINT'>>> INSERT DATA INTO TOTALDATA TABLE';
USE Zoo
GO
	BEGIN TRAN
		INSERT INTO Animal.TotalData(ZooID,TotalAnimal,TotalEmployee,TotalSpecies)
							VALUES	(1,
									(SELECT Animal.Fn_TotalAnimals(1)),
									(SELECT Animal.Fn_TotalEmployees(1)),
									(SELECT Animal.Fn_TotalSpecies(1))
									)
									
	COMMIT;

PRINT'>>> SELECT TOTAL TABLE';
USE Zoo
GO
	SELECT *
	FROM Animal.TotalData


PRINT'>>> QUESTION V : TRIGGER AND TABLE';
PRINT'>>> LOGGING TABLE : EMPLOYEE HISTORY';
PRINT'>>> ADDING EMPLOYEE HISORTY TABLE INTO DATABASE FOR TRIGGER OPERATION';
USE Zoo
GO
	CREATE TABLE Animal.EmployeeHistory (
		ID	INT IDENTITY NOT NULL,
		EmployeeID INT NOT NULL,
		FirstName NVARCHAR(255) NOT NULL,
		LastName NVARCHAR(255) NOT NULL,
		Contact NCHAR(15),
		Salary SMALLMONEY NOT NULL,
		Position VARCHAR(255) NOT NULL,
		EndDate DATE DEFAULT CONVERT(DATE, GETDATE()),
		Operation NVARCHAR(255) DEFAULT 'UPDATE',
		PerformBy NVARCHAR(255) DEFAULT 'Mitul Kheni',
		
		CONSTRAINT PK_EmpHistoryID PRIMARY KEY (ID),
	)
	CREATE NONCLUSTERED INDEX NCI_empID ON Animal.EmployeeHistory(EmployeeID)

PRINT'>>>TRIGGER FOR EMPLOYEE HISOTRY TABLE';
PRINT'>>> FIRST DELETE TRIGGER';
USE Zoo
GO
	CREATE TRIGGER TRIG_StoreDeletedRecord
	ON Animal.Employee
	FOR DELETE
	AS
		DECLARE @empID INT,
				@firstName NVARCHAR(255),
				@lastName NVARCHAR(255),
				@contact NCHAR(15),
				@salary SMALLMONEY,
				@position VARCHAR(255)

		SELECT @empID =  del.ID FROM deleted del;
		SELECT @firstName =  del.FirstName FROM deleted del;
		SELECT @lastName =  del.LastName FROM deleted del;
		SELECT @contact =  del.Contact FROM deleted del;
		SELECT @salary =  del.Salary FROM deleted del;
		SELECT @position =  del.Position FROM deleted del;
		
		BEGIN
		INSERT INTO Animal.EmployeeHistory	(EmployeeID,FirstName,LastName,Contact,Salary,Position,EndDate,Operation,PerformBy)
									VALUES (@empID,
											@firstName,
											@lastName,
											@contact,
											@salary,
											@position,
											(SELECT CONVERT(DATE,GETDATE())),
											'DELETE',
											(SELECT FirstName+' , '+LastName FROM Animal.Employee WHERE ID = 1)
									)
		END;


PRINT'>>> TABLE FOR RECORD UPDATE'
USE Zoo
GO
	CREATE TABLE Animal.SpeciesHistory(
		ID INT IDENTITY NOT NULL,
		SepciesID INT NOT NULL,
		Name VARCHAR(255) NOT NULL,
		Status CHAR(3) NOT NULL,
		TotalExists INT DEFAULT 0,

		CONSTRAINT PK_SpeciesHistoryID PRIMARY KEY (ID),
	)
	CREATE NONCLUSTERED INDEX NCI_SpeciesID ON Animal.SpeciesHistory(SepciesID)


PRINT'>>> TRIGGER 2: TRIGGER FOR SPECIES TABLE';
USE Zoo
GO
	CREATE TRIGGER TRIG_StoreUpdatedRecord
	ON Animal.Species
	AFTER UPDATE,INSERT
	AS
		DECLARE @speciesID INT,
				@speciesName VARCHAR(255),
				@speciesStatus CHAR(3),
				@totalExists INT

		SELECT @speciesID =  ins.ID FROM inserted ins;
		SELECT @speciesName =  ins.Name FROM inserted ins;
		SELECT @speciesStatus =  ins.Status FROM inserted ins;
		SELECT @totalExists=  ins.TotalExists FROM inserted ins;
		
		BEGIN
		INSERT INTO Animal.SpeciesHistory
					(SepciesID,Name,Status,TotalExists)
			SELECT @speciesID,@speciesName,@speciesStatus,@totalExists
			FROM inserted
		END;

PRINT'>>> TRIGGER 1 : FIRED';
/*ADD SOME DUMMY DATA INTO EMPLOYEE TABLE*/
USE  Zoo
GO
	BEGIN TRAN
	INSERT INTO Animal.Employee (FirstName,LastName,Contact,Salary,Position)
						VALUES	('Johnny','Smith','226-988-1100',60000,'Cleaner')
	COMMIT;

/*DELETE SOME DATA FROM EMPLOYEE TABLE*/
USE Zoo
GO
	BEGIN TRAN
		DELETE FROM Animal.Employee 
		WHERE FirstName = 'Johnny' AND LastName = 'Smith';
	COMMIT;

/*SELECT DATA FROM EMPLOYEE HISTORY TABLE*/
USE Zoo
GO
	SELECT * 
	FROM Animal.EmployeeHistory

PRINT'>>> TRIGGER 2 : FIRED';
/*LET'S CHANGE SOME DATA FROM SPECIES TABLE*/
USE Zoo
GO
	BEGIN TRAN
		UPDATE Animal.Species SET TotalExists = 200
		WHERE ID = 12
	COMMIT;

/*LET'S CHECK IN SPECIES HISTORY TABLE*/
PRINT'>>> CHECKING SPECIES HISTORY TABLE FOR LOGGING';
USE Zoo
GO
	SELECT * 
	FROM Animal.SpeciesHistory

/*LET'S INSERT A RECORD INTO SPECIES TABLE*/
USE  Zoo
GO
	BEGIN TRAN
	INSERT INTO Animal.Species  (Name,Status,TotalExists)
						VALUES	('White Panda','EN',45000)
	COMMIT;

PRINT'>>> CHECKING SPECIES HISTORY TABLE FOR LOGGING';
USE Zoo
GO
	SELECT * 
	FROM Animal.SpeciesHistory


PRINT'>>> QUESTION VI : INDEXES';
PRINT'>>> PERFORMANCE INCERESE BY ADDING INDEX IN SOME TABLES INCLUDING EMPLOYEE, ANIMAL, SPECIES, REPORT'
/*
1. INDEX ON REPORT TABLE TO IDENTIFY TOTAL VISIORS OR INCOME,OUTCOME OF A ZOO
2. INDEX ON SPECIES STATUS AND TOTALEXISTS
3. INDEX ON ZOO NAME AND CITY
*/

/*IT IS SOMETIME IMPORTANT TO RETRIVE SPECIES STATUS AND TOTAL NUMBER OF AN ANIMAL ; 
	THUS I'VE DECIDED TO PUT INDEXES ON STATUS AND TOTAL_EXISTS COLUMN IN SPECIES TABLE */

PRINT '>>> INDEX #2.1 IN_SPECIES_STATUS_TOTAL';
PRINT '>>> INDEX FOR MULTIPLE COLUMNS ON SPECIES TABLE';

USE Zoo
GO
	CREATE INDEX In_SpeciesStatusTotal
	ON Animal.Species (Status,TotalExists);


/*IT IS SOMETIME IMPORTANT TO RETRIVE REPORT DETAILS INCLUDING VISITORS,INCOME,OUTCOME OF A ZOO ; 
	THUS I'VE DECIDED TO PUT INDEXES ON VISITOS,INCOME,OUTCOME IN REPORT TABLE */

PRINT '>>> INDEX #2.2 IN_REPORT_TOTAL_NUMBERS';
PRINT '>>> INDEX FOR MULTIPLE COLUMNS ON REPORT TABLE';

USE Zoo
GO
	CREATE INDEX In_ZooReportTotalNumbers
	ON Animal.ZooReport (Income,Outcome,Visitors);

/*IT IS SOMETIME IMPORTANT TO RETRIVE ZOO NAME AND CITY; 
	THUS I'VE DECIDED TO PUT INDEXES ON NAME AND CITY IN REPORT TABLE */

PRINT '>>> INDEX #2.3 IN_ZOO_NAME_CITY';
PRINT '>>> INDEX FOR MULTIPLR COLUMN ON ZOO TABLE';

USE Zoo
GO
	CREATE INDEX In_ZooNameCity
	ON Animal.Zoo (Name,City);


PRINT'>>>*****  ADDING INDEXES ENDS ***********';


PRINT'>>> QUESTION : VII  CONVERSION OF 3NF INTO UNF';
PRINT'>>> ADDING NEW SCHEMA INTO DATABASE : REPORTING';
USE Zoo
GO
	CREATE SCHEMA Reporting


PRINT'>>> ELEPHANT IN THE ROOM : 3NF TO UNF CONVERSION AND ADD INTO SEPERATE TABLE';
PRINT'>>> INSERT ALL IMPORTANT RECORDS INTO REPORTING TABLE OF REPORTING SCHHEMA';
USE Zoo
GO
	SELECT DISTINCT AE.FirstName,
					AE.LastName,
					AE.Contact,
					AE.Salary,
					AE.Position,
					ZO.Name AS ZooName,
					ZO.City AS ZooCity,
					ACO.Name AS CountryName,
					AA.AnimalName AS AnimalName,
					AA.Gender AS AnimalGender,
					AA.Year AS AnimalYear,
					ASP.Name AS SpeciesName,
					ASP.Status AS SpeciesdStatus,
					ASP.TotalExists AS SepciesExists		
			INTO Reporting.Reporting
			FROM  Animal.Employee AS AE
					INNER JOIN Animal.Contract AS AC
						ON AE.ID = AC.EmployeeID
					RIGHT JOIN Animal.Zoo AS ZO
						ON ZO.ID = AC.ZooID
					RIGHT JOIN Animal.Country AS ACO
						ON ZO.CountryID = ACO.ID
					LEFT JOIN Animal.Animal AS AA
						ON ZO.ID = AA.ZooID
					LEFT JOIN Animal.Species AS ASP
						ON ASP.ID = AA.SpeciesID


PRINT'>>> REPORTING TABLE HAS BEEN CREATED SUCCESSFULLY';
PRINT'>>> FETCH ALL DATA FROM REPORTING TABLE';
USE Zoo
GO
	SELECT *
	FROM Reporting.Reporting

PRINT'>>>************************************************';
PRINT'>>>....... THANK YOU .......';
PRINT'>>>************************************************';
	