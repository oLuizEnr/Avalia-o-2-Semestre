CREATE DATABASE Escola
USE Escola

CREATE TABLE dFuncion�rios (
	Funcion�rioID INT NOT NULL PRIMARY KEY,
	NomeFuncion�rio VARCHAR(20) NOT NULL,
	Telefone VARCHAR(15) UNIQUE,
	S�lario DECIMAL(7, 2) NOT NULL,
	CargoID INT NOT NULL,
	TutorEscolaridade INT
)

INSERT INTO dFuncion�rios (Funcion�rioID, NomeFuncion�rio, Telefone, S�lario, CargoID, TutorEscolaridade)
VALUES (1, 'Alessando Freitas', '(11) 98670-0087', 4500, 1, NULL),
	   (2, 'M�rcia Andrade', '(11) 93459-8880', 5400, 2, 1),
	   (3, 'Alessando Freitas', '(11) 90680-9891', 6000, 2, 2),
	   (4, 'Laura Almeida', '(11) 92760-5578', 5800, 3, NULL)

CREATE TABLE dAlunos (
	AlunoRM INT PRIMARY KEY NOT NULL,
	NomeAluno VARCHAR(30) NOT NULL,
	EscolaridadeID INT NOT NULL,
	Ocorr�ncias INT NOT NULL
)

INSERT INTO dAlunos (AlunoRM, NomeAluno, EscolaridadeID, Ocorr�ncias)
VALUES
	('12345', 'Luiza Fernandes', 1, 0),
	('54321', 'Felipe Antonio', 1, 1),
	('67890', 'Jo�o Maur�cio', 1, 0),
	('3470', 'Kevin Matos', 2, 2),
	('09876', 'Maria Castela', 2, 0),
	('09390', 'Leticia Joaquina', 2, 3)

CREATE TABLE dCargos (
	CargoID INT NOT NULL PRIMARY KEY,
	NomeCargo VARCHAR(20) NOT NULL
)

INSERT INTO dCargos (CargoID, NomeCargo)
VALUES
	(1, 'Diretoria'),
	(2, 'Professor'),
	(3, 'Outros')

CREATE TABLE dEscolaridade (
	EscolaridadeID INT NOT NULL PRIMARY KEY,
	NomeEscolaridade VARCHAR(20) NOT NULL
)

INSERT INTO dEscolaridade
VALUES
	(1, 'Fundamental'),
	(2, 'M�dio'),
	(3, 'Superior')

ALTER TABLE dAlunos
ADD CONSTRAINT FK_dAlunos_dEscolaridade FOREIGN KEY (EscolaridadeID)
REFERENCES dEscolaridade(EscolaridadeID)

ALTER TABLE dFuncion�rios
ADD CONSTRAINT FK_dFuncion�rios_dCargos FOREIGN KEY (CargoID)
REFERENCES dCargos(CargoID)

ALTER TABLE dFuncion�rios
ADD CONSTRAINT FK_dFuncion�rios_dEscolaridade FOREIGN KEY (TutorEscolaridade)
REFERENCES dEscolaridade(EscolaridadeID)

SELECT * FROM dFuncion�rios
SELECT * FROM dAlunos
SELECT * FROM dCargos
SELECT * FROM dEscolaridade

--1) Views
CREATE VIEW
--

--2) Subqueries
SELECT
	AlunoRM
FROM
	dAlunos
WHERE Ocorr�ncias < (
	SELECT
		Ocorr�ncias
	FROM
		dAlunos
	WHERE
		EscolaridadeID = 1
);
--

--3) CTE (Common Table Expression)
WITH Informa��esPorCargo
AS (
	SELECT
		NomeCargo,
		COUNT(dFuncion�rios.Funcion�rioID) AS 'Qtd. Funcion�rios Cargo',
		AVG(dFuncion�rios.S�lario) AS 'M�dia S�larial Cargo'
	FROM
		dCargos
	JOIN dFuncion�rios
		ON dFuncion�rios.CargoID = dCargos.CargoID
	GROUP BY
		NomeCargo
)

SELECT * FROM Informa��esPorCargo
-- Com este uso dos CTEs, consigo r�pidamente e sem precisar guardar infos verificar certas informa��es por cargo na escola.

--4) Windows Functions
SELECT
	EscolaridadeID,
	AlunoRM,
	SUM(Ocorr�ncias) OVER(PARTITION BY EscolaridadeID) AS 'Ocorr�nciasPorEsc.'
FROM
	dAlunos
-- Identifica as escolaridades, os alunos que est�o incluidos nelas e a quantidade de ocorr�ncias por escolaridade

--5) Functions
--

--6) Loops
--

--7) Procedures
--

--8) Triggers
CREATE TRIGGER Funcion�rioNovo
ON dFuncion�rios
AFTER INSERT
AS
BEGIN
	DECLARE
		@Funcion�rioNovo VARCHAR;
	SELECT
		@Funcion�rioNovo = NomeFuncion�rio FROM dFuncion�rios ORDER BY Funcion�rioID;
	PRINT @Funcion�rioNovo  + 'Foi Adcionado! N�o esque�a de dar a ele boas vindas.'
END
GO
-- Usa um trigger para enviar uma mensagem confirmando a adi��o de um o novo funcion�rio automaticamente.

DROP DATABASE Escola
DROP TABLE dEscolaridade
DROP TABLE dAlunos