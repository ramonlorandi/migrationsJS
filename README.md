# 1. Visão Geral

Este projeto implementa um pipeline completo de CI/CD utilizando GitHub Actions, Vercel e PostgreSQL (Railway).
O objetivo é demonstrar a separação de ambientes, automação de deploys e execução de migrations, mantendo páginas HTML independentes e sem conexão direta com o banco de dados.

A aplicação consiste em uma página HTML estática fornecida pelo professor, acompanhada por scripts de migrations responsáveis pela criação e preenchimento das tabelas no banco de dados.

## Foram configurados três ambientes independentes:

Produção (branch: main)

Pré-Produção (branch: preprod)

Desenvolvimento (branch: dev)

## Cada ambiente possui:

Um projeto separado na Vercel

Um banco de dados distinto na Neon

Um pipeline próprio no GitHub Actions

---

# 2. Estrutura dos Ambientes
Produção

## Branch: main

Deploy automático em cada push e pull request

Executa migrations no banco de produção

Publicação automática no projeto Vercel de produção

Pré-Produção

## Branch: preprod

Deploy manual via GitHub Actions

Deploy programado diariamente às 00:00

Executa migrations no banco de pré-produção

Publicação no projeto Vercel de pré-produção

Desenvolvimento

## Branch: dev

Deploy exclusivamente manual

Executa migrations no banco de desenvolvimento

Publicação no projeto Vercel de desenvolvimento

---

# 3. Estrutura das Migrations

As migrations criam três tabelas, cada uma com cinco colunas, incluindo chaves primárias. Após a criação, sete registros são inseridos em cada tabela.

O processo é executado via Node.js utilizando o pacote pg e um script de execução dedicado.

## Arquivo principal de migration:

```bash
/migrations/001_create_tables.sql
```

## Script executor:

```bash
/scripts/migrate.js
```

## O script:

Lê o arquivo SQL

Conecta ao banco da respectiva branch

Executa transactions (BEGIN, COMMIT, ROLLBACK)

Finaliza a conexão

---

# 4. Deploy nos Ambientes

Os ambientes Vercel não utilizam integração com Git.
Toda publicação ocorre via CLI dentro do GitHub Actions.

O deploy é executado com:

```bash
npx vercel pull --yes --environment=production --token "$VERCEL_TOKEN"
npx vercel deploy --prod --yes --token "$VERCEL_TOKEN"
```

Ou, nos ambientes que não são produção:

npx vercel deploy --yes --token "$VERCEL_TOKEN"

Cada pipeline aponta para o ID do projeto da Vercel do ambiente correspondente.

---

# 5. Pipelines (GitHub Actions)
## 5.1. Pipeline de Produção (deploy-prod.yml)

Disparado automaticamente em push e pull request na branch main

Instala dependências

Executa migrations no banco de produção

Realiza deploy para o projeto Vercel de produção

##5.2. Pipeline de Pré-Produção (deploy-preprod.yml)

Disparo manual (workflow_dispatch)

Execução diária às 03:00 via cron

Instala dependências

Executa migrations no banco de pré-produção

Publica o ambiente de pré-produção no projeto Vercel associado

## 5.3. Pipeline de Desenvolvimento (deploy-dev.yml)

Disparo exclusivamente manual

Instala dependências

Executa migrations no banco de desenvolvimento

Realiza deploy para o projeto Vercel de desenvolvimento
