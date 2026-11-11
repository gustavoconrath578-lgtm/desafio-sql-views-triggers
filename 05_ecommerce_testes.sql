-- Parte 2: exemplos para testar as triggers.
-- Execute DEPOIS do arquivo 04.
USE ecommerce_triggers_desafio;

-- TESTE 1: apagar conta de usuario sem perder os dados originais.
INSERT INTO usuarios (nome, email)
VALUES ('Maria Souza', 'maria.teste@exemplo.com');
SET @id_usuario_teste = LAST_INSERT_ID();

DELETE FROM usuarios WHERE id_usuario = @id_usuario_teste;

-- O usuario nao aparece mais em usuarios, mas fica salvo no backup.
SELECT * FROM usuarios WHERE id_usuario = @id_usuario_teste;
SELECT * FROM usuarios_excluidos
WHERE id_usuario_original = @id_usuario_teste;

-- TESTE 2: inserir colaborador sem informar salario.
-- A trigger atribui o valor demonstrativo de 2000.00.
INSERT INTO colaboradores (nome, email, cargo)
VALUES ('Ana Oliveira', 'ana.teste@exemplo.com', 'Atendente');
SET @id_colaborador_teste = LAST_INSERT_ID();

SELECT * FROM colaboradores
WHERE id_colaborador = @id_colaborador_teste;

-- TESTE 3: atualizar salario e conferir o historico.
UPDATE colaboradores
SET salario_base = 2800.00
WHERE id_colaborador = @id_colaborador_teste;

SELECT * FROM colaboradores
WHERE id_colaborador = @id_colaborador_teste;

SELECT * FROM historico_salarios
WHERE id_colaborador = @id_colaborador_teste;

-- Teste opcional de validacao (remova o comentario para executar):
-- UPDATE colaboradores SET salario_base = -100
-- WHERE id_colaborador = @id_colaborador_teste;
-- O banco deve bloquear a atualizacao.
