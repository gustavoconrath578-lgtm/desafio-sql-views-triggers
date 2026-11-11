# Desafio de Banco de Dados - Views e Triggers

Este projeto foi feito para praticar o uso de **views**, permissões de usuários e **triggers** no MySQL.

## Parte 1 - Views

Usei o banco de exemplo Company e criei cinco views para consultar:

- Quantidade de empregados por departamento e cidade;
- Departamentos e seus gerentes;
- Projetos com mais empregados;
- Projetos, departamentos e gerentes;
- Empregados que têm dependentes e se também são gerentes.

Também criei uma view simples com nomes de funcionários para demonstrar as permissões. O usuário **gerente** pode consultar todas as views, enquanto o usuário **funcionário** só pode consultar a lista básica, sem acesso aos departamentos ou gerentes.

## Parte 2 - Triggers

No exemplo de e-commerce, criei três gatilhos:

- **BEFORE DELETE:** salva os dados do usuário em outra tabela antes de apagar a conta.
- **BEFORE INSERT:** coloca um salário inicial de exemplo para o colaborador quando ele é cadastrado sem salário.
- **BEFORE UPDATE:** verifica o novo salário e guarda o salário antigo e o novo em um histórico.

Assim, os dados importantes não são perdidos e fica mais fácil acompanhar as mudanças feitas no sistema.

## Como executar

Os scripts foram preparados para **MySQL 8**, no MySQL Workbench ou em outro cliente compatível. Execute nesta ordem:

1. `00_company_exemplo.sql` - cria as tabelas e alguns dados de teste;
2. `01_company_views.sql` - cria as views;
3. `02_company_consultas.sql` - consulta as views;
4. `03_company_permissoes.sql` - cria usuários e define os acessos;
5. `04_ecommerce_tabelas_triggers.sql` - cria as tabelas e triggers do e-commerce;
6. `05_ecommerce_testes.sql` - testa exclusão e alteração de dados.

**Observações:** os bancos foram criados apenas para demonstração. Se você já tiver o banco Company ou o banco de e-commerce do curso, pode adaptar os nomes das tabelas e colunas. O primeiro script de cada banco deve ser executado uma vez em um banco novo. No arquivo de permissões, troque as senhas de exemplo antes de executar e use uma conta com permissão para criar usuários.

Os valores de salários e os registros usados são fictícios e servem somente para testar o funcionamento das triggers.
