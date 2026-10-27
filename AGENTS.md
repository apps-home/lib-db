# Modelagem do Banco de Dados (Prisma Schema — @lib/db)

> Submódulo Git compartilhado (`packages/lib-db`) responsável pela camada de persistência e ORM (Prisma 7 + PostgreSQL).

---

## 1. Scripts e Operações do Banco

A partir da raiz do monorepo:

| Comando | Descrição |
|---|---|
| `pnpm --filter @lib/db build` | Gera o Prisma Client (`prisma generate`) e compila o TypeScript (`tsc`). |
| `pnpm --filter @lib/db migrate` | Executa e gera novas migrations em desenvolvimento (`prisma migrate dev`). |
| `pnpm --filter @lib/db migrate:deploy` | Aplica migrations pendentes em produção/CI (`prisma migrate deploy`). |
| `pnpm --filter @lib/db migrate:status` | Verifica status das migrations no banco configurado (`prisma migrate status`). |
| `pnpm --filter @lib/db push` | Sincroniza o schema diretamente no banco sem criar migration (`prisma db push`). |
| `pnpm --filter @lib/db studio` | Abre a interface web do Prisma Studio para inspeção dos dados. |

Localização do Schema: `packages/lib-db/src/prisma/schema.prisma`  
Cliente Gerado: `packages/lib-db/src/prisma/generated/prisma`

---

## 2. Consumo no Monorepo

O pacote exporta o Prisma Client gerado e utilitários:
- No backend (`apps/service`), a conexão é gerenciada pelo `PrismaService` (`apps/service/src/infra/prisma/prisma.service.ts`), que estende o `PrismaClient` de `@lib/db`.
- Sempre que houver alteração no `schema.prisma`, execute `pnpm --filter @lib/db build` para atualizar os tipos compartilhados.

---

## 3. Schemas e Tabelas

O schema é dividido em dois namespaces PostgreSQL: `better-auth` (autenticação) e `finance-assets` (domínio de negócio).

### Schema: `better-auth`

| Tabela | Descrição |
|---|---|
| `user` | Usuário da plataforma. Campos: `id`, `name`, `email`, `emailVerified`, `image`, `createdAt`, `updatedAt`. |
| `session` | Sessões ativas. Armazena `token`, `expiresAt`, `ipAddress`, `userAgent` e FK para `user`. |
| `account` | Contas OAuth vinculadas ao usuário (e.g., Google). Armazena `providerId`, `accessToken`, `refreshToken`, `scope`, `password`. |
| `verification` | Tokens temporários para verificação de e-mail e outros fluxos. Campos: `identifier`, `value`, `expiresAt`. |

### Schema: `finance-assets`

| Tabela | Descrição |
|---|---|
| `asset_categories` | Classe de ativos do usuário. Campos: `id`, `userId`, `name`, `type` (enum `CategoryType`), `currency` (padrão `BRL`). |
| `assets` | Ativo individual dentro de uma categoria. Campos: `id`, `categoryId`, `name`, `ticker`, `currentClosePrice`, `lastMonthClosePrice`, `dividendsImportedAt` (quando o histórico de proventos foi importado; `null` = pendente), `indexer` (`FixedIncomeIndexer`, renda fixa com saldo calculado; `null` = manual), `indexerRate`, `investedAt`, `maturityAt`. |
| `asset_wishlists` | Ativos monitorados / lista de desejos do usuário. Campos: `id`, `userId`, `categoryId`, `name`, `ticker`, `targetPrice`, `currentClosePrice`, `lastMonthClosePrice`, `notes`, `createdAt`, `updatedAt`. |
| `asset_records` | Registro histórico mensal do valor consolidado de uma categoria. Campos: `id`, `categoryId`, `month`, `year`, `amount`, `exchangeRate`, `dividendAmount`, `contributionAmount`. |
| `benchmark_returns` | Retorno mensal em % de CDI, Ibovespa, IFIX, S&P 500 e bitcoin em R$, todos de retorno total (cache global). Campos: `id`, `benchmark` (`BenchmarkType`), `year`, `month`, `returnPct`. Único por `(benchmark, year, month)`. |
| `indicator_rates` | CDI diário e IPCA mensal do Banco Central (cache global). Campos: `id`, `indicator` (`EconomicIndicator`), `date`, `ratePct`. Único por `(indicator, date)`. |
| `asset_category_competences` | Registra em quais **anos** uma categoria possui registros, otimizando queries de filtro temporal. Campos: `id`, `categoryId`, `year`. |
| `asset_dividends` | Provento recebido por um ativo. Campos: `id`, `assetId`, `userId`, `type` (`DividendType`), `source` (`DividendSource`), `amount` (total bruto na moeda da categoria), `taxAmount` (impostos retidos, opcional; líquido = `amount − taxAmount`), `rateAmount` (por cota), `quantity`, `exchangeRate` (para BRL, em moedas estrangeiras), `comDate`, `paymentDate`. Único por `(assetId, type, paymentDate)`. |
| `asset_transactions` | Operação de um ativo (compra, venda, saldo inicial, desdobramento, grupamento, bonificação). Campos: `id`, `assetId`, `userId`, `type` (`TransactionType`), `source` (`TransactionSource`), `date`, `quantity`, `price`, `fees`, `factor`, `exchangeRate`, `notes`. Com operações, quantidade e preço médio do ativo são calculados a partir delas. |

### Enums

| Enum | Valores |
|---|---|
| `DividendType` | `DIVIDEND`, `JCP`, `INCOME` (rendimento de FII), `OTHER` |
| `DividendSource` | `MANUAL` (lançado pelo usuário), `SYNC` (sincronizado de Brapi/Polygon) |
| `BenchmarkType` | `CDI`, `IBOV`, `SP500_BRL`, `IFIX`, `BTC_BRL` |
| `FixedIncomeIndexer` | `CDI` (% do CDI), `IPCA` (IPCA + taxa real), `PRE` (prefixado) |
| `EconomicIndicator` | `CDI` (diário), `IPCA` (mensal) |
| `TransactionType` | `OPENING` (saldo inicial), `BUY`, `SELL`, `SPLIT` (desdobramento), `REVERSE_SPLIT` (grupamento), `BONUS` (bonificação) |
| `TransactionSource` | `MANUAL`, `IMPORT` (extrato importado) |

### Enum: `CategoryType`

| Valor | Descrição |
|---|---|
| `VARIABLE_BR` | Renda Variável — Mercado Brasileiro (Brapi) |
| `FII` | Fundos Imobiliários (Brapi) |
| `VARIABLE_US` | Renda Variável — Mercado Americano (Alpha Vantage) |
| `CRYPTO` | Criptomoedas (CoinGecko) |
| `FIXED` | Renda Fixa (sem cotação de mercado) |

