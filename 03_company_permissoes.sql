-- Parte 1: usuarios e permissoes das views.
-- Execute com uma conta administradora (com CREATE USER e GRANT).
-- TROQUE AS SENHAS DE EXEMPLO ANTES DE EXECUTAR.
-- Esta atividade usa contas 'localhost' para acesso no computador local.

CREATE USER IF NOT EXISTS 'gerente_views'@'localhost'
  IDENTIFIED BY 'TROQUE_SENHA_GERENTE_123!';
CREATE USER IF NOT EXISTS 'funcionario_views'@'localhost'
  IDENTIFIED BY 'TROQUE_SENHA_FUNCIONARIO_123!';

-- O gerente pode consultar as cinco views, inclusive os dados
-- dos departamentos e gerentes, mas nao recebe acesso direto as tabelas.
GRANT SELECT ON company_views_desafio.vw_empregados_depto_localidade
  TO 'gerente_views'@'localhost';
GRANT SELECT ON company_views_desafio.vw_departamentos_gerentes
  TO 'gerente_views'@'localhost';
GRANT SELECT ON company_views_desafio.vw_projetos_empregados
  TO 'gerente_views'@'localhost';
GRANT SELECT ON company_views_desafio.vw_projetos_departamentos_gerentes
  TO 'gerente_views'@'localhost';
GRANT SELECT ON company_views_desafio.vw_empregados_dependentes_gerentes
  TO 'gerente_views'@'localhost';
GRANT SELECT ON company_views_desafio.vw_funcionarios_basico
  TO 'gerente_views'@'localhost';

-- O funcionario so pode consultar nomes de funcionarios.
-- NAO damos acesso as outras views ou as tabelas department e employee.
GRANT SELECT ON company_views_desafio.vw_funcionarios_basico
  TO 'funcionario_views'@'localhost';

-- Conferir as permissoes
SHOW GRANTS FOR 'gerente_views'@'localhost';
SHOW GRANTS FOR 'funcionario_views'@'localhost';

-- Exemplo de consulta ao conectar com o usuario funcionario_views:
-- SELECT * FROM company_views_desafio.vw_funcionarios_basico;
-- A consulta abaixo deve ser NEGADA para esse usuario:
-- SELECT * FROM company_views_desafio.vw_departamentos_gerentes;
