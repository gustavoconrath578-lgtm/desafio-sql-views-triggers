-- Parte 1: cinco views solicitadas e uma view basica de acesso.
USE company_views_desafio;

-- 1. Quantidade de empregados por departamento e localidade.
-- Cada empregado tem uma Localidade cadastrada, evitando contagem duplicada.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_empregados_depto_localidade AS
SELECT d.Dnumber AS numero_departamento,
       d.Dname AS departamento,
       dl.Dlocation AS localidade,
       COUNT(e.Ssn) AS total_empregados
FROM dept_locations AS dl
JOIN department AS d ON d.Dnumber = dl.Dnumber
LEFT JOIN employee AS e
  ON e.Dno = dl.Dnumber AND e.Localidade = dl.Dlocation
GROUP BY d.Dnumber, d.Dname, dl.Dlocation;

-- 2. Departamentos e seus gerentes.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_departamentos_gerentes AS
SELECT d.Dnumber AS numero_departamento,
       d.Dname AS departamento,
       CONCAT(e.Fname, ' ', e.Lname) AS gerente
FROM department AS d
LEFT JOIN employee AS e ON e.Ssn = d.Mgr_ssn;

-- 3. Projetos com quantidade de empregados envolvidos.
-- A ordenacao decrescente sera feita na consulta da view.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_projetos_empregados AS
SELECT p.Pnumber AS numero_projeto,
       p.Pname AS projeto,
       COUNT(DISTINCT w.Essn) AS total_empregados
FROM project AS p
LEFT JOIN works_on AS w ON w.Pno = p.Pnumber
GROUP BY p.Pnumber, p.Pname;

-- 4. Projetos, departamentos e gerentes.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_projetos_departamentos_gerentes AS
SELECT p.Pnumber AS numero_projeto,
       p.Pname AS projeto,
       d.Dname AS departamento,
       CONCAT(e.Fname, ' ', e.Lname) AS gerente
FROM project AS p
JOIN department AS d ON d.Dnumber = p.Dnum
LEFT JOIN employee AS e ON e.Ssn = d.Mgr_ssn;

-- 5. Empregados com dependentes, indicando se sao gerentes.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_empregados_dependentes_gerentes AS
SELECT e.Ssn AS id_empregado,
       CONCAT(e.Fname, ' ', e.Lname) AS empregado,
       COUNT(dep.Dependent_name) AS total_dependentes,
       CASE WHEN EXISTS (
         SELECT 1 FROM department AS d WHERE d.Mgr_ssn = e.Ssn
       ) THEN 'Sim' ELSE 'Nao' END AS e_gerente
FROM employee AS e
JOIN dependent AS dep ON dep.Essn = e.Ssn
GROUP BY e.Ssn, e.Fname, e.Lname;

-- View adicional: somente nome do funcionario, sem dados de
-- departamento, localidade, dependentes ou gerentes.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW vw_funcionarios_basico AS
SELECT e.Fname AS nome, e.Lname AS sobrenome
FROM employee AS e;
