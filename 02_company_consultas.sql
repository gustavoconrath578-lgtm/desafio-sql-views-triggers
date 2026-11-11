-- Consultas para conferir as cinco views.
USE company_views_desafio;

-- 1. Numero de empregados por departamento e cidade
SELECT * FROM vw_empregados_depto_localidade
ORDER BY departamento, localidade;

-- 2. Departamentos e gerentes
SELECT * FROM vw_departamentos_gerentes
ORDER BY departamento;

-- 3. Projetos com mais empregados primeiro
SELECT * FROM vw_projetos_empregados
ORDER BY total_empregados DESC, projeto;

-- 4. Projetos, departamentos e gerentes
SELECT * FROM vw_projetos_departamentos_gerentes
ORDER BY projeto;

-- 5. Empregados que possuem dependentes e se sao gerentes
SELECT * FROM vw_empregados_dependentes_gerentes
ORDER BY empregado;

-- View simples para funcionarios
SELECT * FROM vw_funcionarios_basico ORDER BY nome, sobrenome;
