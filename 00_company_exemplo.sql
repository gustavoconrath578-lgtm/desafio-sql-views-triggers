-- Parte 1: exemplo completo do banco Company para testar as views.
-- ATENCAO: use em um banco de demonstracao. Execute uma unica vez.
-- Caso ja tenha o banco Company da disciplina, adapte as views ao seu esquema.

CREATE DATABASE IF NOT EXISTS company_views_desafio
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company_views_desafio;

CREATE TABLE department (
  Dnumber INT PRIMARY KEY,
  Dname VARCHAR(80) NOT NULL,
  Mgr_ssn CHAR(9) NULL
) ENGINE = InnoDB;

CREATE TABLE dept_locations (
  Dnumber INT NOT NULL,
  Dlocation VARCHAR(80) NOT NULL,
  PRIMARY KEY (Dnumber, Dlocation),
  CONSTRAINT fk_local_depto FOREIGN KEY (Dnumber)
    REFERENCES department(Dnumber)
) ENGINE = InnoDB;

-- A localidade de cada empregado foi incluida no exemplo para que
-- a contagem por departamento E cidade represente pessoas reais em cada cidade.
CREATE TABLE employee (
  Ssn CHAR(9) PRIMARY KEY,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  Dno INT NOT NULL,
  Localidade VARCHAR(80) NOT NULL,
  CONSTRAINT fk_emp_local FOREIGN KEY (Dno, Localidade)
    REFERENCES dept_locations(Dnumber, Dlocation)
) ENGINE = InnoDB;

ALTER TABLE department
  ADD CONSTRAINT fk_depto_gerente FOREIGN KEY (Mgr_ssn)
  REFERENCES employee(Ssn);

CREATE TABLE project (
  Pnumber INT PRIMARY KEY,
  Pname VARCHAR(100) NOT NULL,
  Dnum INT NOT NULL,
  CONSTRAINT fk_projeto_depto FOREIGN KEY (Dnum)
    REFERENCES department(Dnumber)
) ENGINE = InnoDB;

CREATE TABLE works_on (
  Essn CHAR(9) NOT NULL,
  Pno INT NOT NULL,
  Hours DECIMAL(4,1) NOT NULL DEFAULT 0,
  PRIMARY KEY (Essn, Pno),
  CONSTRAINT fk_trabalho_emp FOREIGN KEY (Essn)
    REFERENCES employee(Ssn),
  CONSTRAINT fk_trabalho_proj FOREIGN KEY (Pno)
    REFERENCES project(Pnumber)
) ENGINE = InnoDB;

CREATE TABLE dependent (
  Essn CHAR(9) NOT NULL,
  Dependent_name VARCHAR(80) NOT NULL,
  Relationship VARCHAR(40),
  PRIMARY KEY (Essn, Dependent_name),
  CONSTRAINT fk_dependente_emp FOREIGN KEY (Essn)
    REFERENCES employee(Ssn)
) ENGINE = InnoDB;

INSERT INTO department (Dnumber, Dname) VALUES
(1, 'Administracao'),
(2, 'Tecnologia'),
(3, 'Recursos Humanos');

INSERT INTO dept_locations (Dnumber, Dlocation) VALUES
(1, 'Curitiba'),
(2, 'Curitiba'),
(2, 'Londrina'),
(3, 'Maringa');

INSERT INTO employee (Ssn, Fname, Lname, Dno, Localidade) VALUES
('000000001', 'Ana', 'Lima', 1, 'Curitiba'),
('000000002', 'Paulo', 'Souza', 2, 'Curitiba'),
('000000003', 'Joana', 'Silva', 2, 'Londrina'),
('000000004', 'Lucas', 'Costa', 2, 'Curitiba'),
('000000005', 'Beatriz', 'Alves', 3, 'Maringa'),
('000000006', 'Marcelo', 'Rocha', 3, 'Maringa'),
('000000007', 'Cristina', 'Medeiros', 2, 'Londrina');

UPDATE department
SET Mgr_ssn = CASE Dnumber
  WHEN 1 THEN '000000001'
  WHEN 2 THEN '000000002'
  WHEN 3 THEN '000000005'
END;

INSERT INTO project (Pnumber, Pname, Dnum) VALUES
(10, 'Sistema de Estoque', 2),
(20, 'Portal Interno', 2),
(30, 'Treinamento', 3),
(40, 'Controle Financeiro', 1);

INSERT INTO works_on (Essn, Pno, Hours) VALUES
('000000002', 10, 15),
('000000003', 10, 10),
('000000004', 10, 20),
('000000007', 10, 12),
('000000002', 20, 8),
('000000003', 20, 16),
('000000007', 20, 10),
('000000005', 30, 10),
('000000006', 30, 14),
('000000001', 40, 20);

INSERT INTO dependent (Essn, Dependent_name, Relationship) VALUES
('000000002', 'Clara', 'Filha'),
('000000002', 'Davi', 'Filho'),
('000000004', 'Julia', 'Filha'),
('000000005', 'Pedro', 'Filho');
