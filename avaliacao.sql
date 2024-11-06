CREATE DATABASE Escola
USE Escola

CREATE TABLE dFuncionários (
	FuncionárioID INT NOT NULL PRIMARY KEY,
	NomeFuncionário VARCHAR(20) NOT NULL,
	Telefone VARCHAR(15) UNIQUE,
	Sálario DECIMAL(7, 2) NOT NULL,
	CargoID INT NOT NULL,
	TutorEscolaridade INT
)

INSERT INTO dFuncionários (FuncionárioID, NomeFuncionário, Telefone, Sálario, CargoID, TutorEscolaridade)
VALUES (1, 'Alessando Freitas', '(11) 98670-0087', 4500, 1, NULL),
	   (2, 'Márcia Andrade', '(11) 93459-8880', 5400, 2, 1),
	   (3, 'Alessando Freitas', '(11) 90680-9891', 6000, 2, 2),
	   (4, 'Laura Almeida', '(11) 92760-5578', 5800, 3, NULL)

CREATE TABLE dAlunos (
	AlunoRM INT PRIMARY KEY NOT NULL,
	NomeAluno VARCHAR(30) NOT NULL,
	EscolaridadeID INT NOT NULL,
	Ocorrências INT NOT NULL
)

INSERT INTO dAlunos (AlunoRM, NomeAluno, EscolaridadeID, Ocorrências)
VALUES
	('12345', 'Luiza Fernandes', 1, 0),
	('54321', 'Felipe Antonio', 1, 1),
	('67890', 'João Maurício', 1, 0),
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
	(2, 'Médio'),
	(3, 'Superior')

ALTER TABLE dAlunos
ADD CONSTRAINT FK_dAlunos_dEscolaridade FOREIGN KEY (EscolaridadeID)
REFERENCES dEscolaridade(EscolaridadeID)

ALTER TABLE dFuncionários
ADD CONSTRAINT FK_dFuncionários_dCargos FOREIGN KEY (CargoID)
REFERENCES dCargos(CargoID)

ALTER TABLE dFuncionários
ADD CONSTRAINT FK_dFuncionários_dEscolaridade FOREIGN KEY (TutorEscolaridade)
REFERENCES dEscolaridade(EscolaridadeID)

SELECT * FROM dFuncionários
SELECT * FROM dAlunos
SELECT * FROM dCargos
SELECT * FROM dEscolaridade

--1) Views
CREATE VIEW GastoEscolar AS
SELECT
	NomeCargo,
	SUM(dFuncionários.Sálario) AS 'Gasto da Escola'
FROM
	dCargos
INNER JOIN dFuncionários
	ON dFuncionários.CargoID = dCargos.CargoID
GROUP BY
	NomeCargo
-- Consegue visualizar quanto a escola está gastando com cada cargo

--2) Subqueries
SELECT
	NomeAluno,
	Ocorrências,
	AlunoRM
FROM
	dAlunos
WHERE Ocorrências < (SELECT AVG(Ocorrências)
FROM dAlunos)
-- Todos os alunos que tem uma quantidade de ocorrências menor que a média

--3) CTE (Common Table Expression)
WITH InformaçõesPorCargo
AS (
	SELECT
		NomeCargo,
		COUNT(dFuncionários.FuncionárioID) AS 'Qtd. Funcionários Cargo',
		AVG(dFuncionários.Sálario) AS 'Média Sálarial Cargo'
	FROM
		dCargos
	JOIN dFuncionários
		ON dFuncionários.CargoID = dCargos.CargoID
	GROUP BY
		NomeCargo
)

SELECT * FROM InformaçõesPorCargo
-- Com este uso dos CTEs, consigo rápidamente e sem precisar guardar infos verificar certas informações por cargo na escola.

--4) Windows Functions
SELECT
	EscolaridadeID,
	AlunoRM,
	SUM(Ocorrências) OVER(PARTITION BY EscolaridadeID) AS 'OcorrênciasPorEsc.'
FROM
	dAlunos
-- Identifica as escolaridades, os alunos que estão incluidos nelas e a quantidade de ocorrências por escolaridade

--5) Functions
CREATE FUNCTION
RETURNS
AS
BEGIN
END
--

--6) Loops
--

--7) Procedures
IF EXISTS(SELECT 1 FROM Sys.objects WHERE TYPE = 'P' AND NAME = 'ADD_AlUNO')
BEGIN
	DROP PROCEDURE ADD_ALUNO
END
GO
CREATE PROCEDURE ADD_ALUNO
	@AlunoRM INT,
	@NomeAluno VARCHAR(20),
	@EscolaridadeID INT,
	@Ocorrências INT
AS
	INSERT INTO dAlunos (AlunoRM, NomeAluno, EscolaridadeID, Ocorrências)
	VALUES (@AlunoRM, @NomeAluno, @EscolaridadeID, @Ocorrências);

	SELECT * FROM dAlunos
GO

EXEC ADD_ALUNO
@AlunoRM = 20,
@NomeAluno = 'Matador de onça',
@EscolaridadeID = 2,
@Ocorrências = 100;
-- Procedure que atualiza a tabela dos alunos, adcionando novos

--8) Triggers
CREATE TRIGGER FuncionárioNovo
ON dFuncionários
AFTER INSERT
AS
BEGIN
	DECLARE
		@FuncionárioNovo VARCHAR(20);
	SELECT
		@FuncionárioNovo = NomeFuncionário FROM dFuncionários ORDER BY FuncionárioID;
	PRINT @FuncionárioNovo  + ' Foi Adcionado! Não esqueça de dar a ele boas vindas.'
END
GO

INSERT INTO dFuncionários
VALUES (10, 'John Wick', '(11) 90606-2228', 2100, 3, NULL)
-- Usa um trigger para enviar uma mensagem confirmando a adição de um o novo funcionário automaticamente.

DROP DATABASE Escola
DROP TABLE dEscolaridade
DROP TABLE dFuncionários
