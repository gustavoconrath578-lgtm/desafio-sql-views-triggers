-- Parte 2: ecommerce com triggers de exclusao, insercao e atualizacao.
-- Banco de exemplo separado para nao alterar dados reais.
-- Execute uma vez em um banco novo, com MySQL 8.

CREATE DATABASE IF NOT EXISTS ecommerce_triggers_desafio
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce_triggers_desafio;

CREATE TABLE usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

-- Copia dos usuarios que pediram exclusao.
CREATE TABLE usuarios_excluidos (
  id_backup INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario_original INT NOT NULL,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL,
  criado_em DATETIME NOT NULL,
  excluido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;

CREATE TABLE colaboradores (
  id_colaborador INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  cargo VARCHAR(80) NOT NULL,
  salario_base DECIMAL(10,2) DEFAULT NULL
) ENGINE = InnoDB;

-- Historico para acompanhar mudancas de salario.
CREATE TABLE historico_salarios (
  id_historico INT AUTO_INCREMENT PRIMARY KEY,
  id_colaborador INT NOT NULL,
  salario_anterior DECIMAL(10,2) NOT NULL,
  salario_novo DECIMAL(10,2) NOT NULL,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_historico_colaborador FOREIGN KEY (id_colaborador)
    REFERENCES colaboradores(id_colaborador)
) ENGINE = InnoDB;

DELIMITER $$

-- BEFORE DELETE: guarda uma copia antes de apagar um usuario.
CREATE TRIGGER trg_usuarios_before_delete
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
  INSERT INTO usuarios_excluidos
    (id_usuario_original, nome, email, criado_em)
  VALUES
    (OLD.id_usuario, OLD.nome, OLD.email, OLD.criado_em);
END$$

-- BEFORE INSERT: define um salario inicial de exemplo para novos colaboradores.
CREATE TRIGGER trg_colaboradores_before_insert
BEFORE INSERT ON colaboradores
FOR EACH ROW
BEGIN
  IF NEW.salario_base IS NULL THEN
    SET NEW.salario_base = 2000.00;
  ELSEIF NEW.salario_base <= 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Salario inicial precisa ser maior que zero';
  END IF;
END$$

-- BEFORE UPDATE: valida salario e registra mudancas no historico.
CREATE TRIGGER trg_colaboradores_before_update
BEFORE UPDATE ON colaboradores
FOR EACH ROW
BEGIN
  IF NEW.salario_base IS NULL OR NEW.salario_base <= 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Salario base precisa ser maior que zero';
  END IF;

  IF NEW.salario_base <> OLD.salario_base THEN
    INSERT INTO historico_salarios
      (id_colaborador, salario_anterior, salario_novo)
    VALUES
      (OLD.id_colaborador, OLD.salario_base, NEW.salario_base);
  END IF;
END$$

DELIMITER ;
