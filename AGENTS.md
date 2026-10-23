# Modelagem do Banco de Dados (Prisma Schema — @lib/db)

> Submódulo Git compartilhado (`packages/lib-db`) responsável pela camada de persistência e ORM (Prisma 7 + PostgreSQL).

---

## 1. Scripts e Operações do Banco

A partir da raiz do monorepo:

| Comando | Descrição |
|---|---|
| `pnpm --filter @lib/db build` | Gera o Prisma Client (`prisma generate`) e compila o TypeScript (`tsc`). |
| `pnpm --filter @lib/db migrate` | Executa e gera novas migrations em desenvolvimento (`prisma migrate dev`). |
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
| `assets` | Ativo individual dentro de uma categoria. Campos: `id`, `categoryId`, `name`, `ticker`, `currentClosePrice`, `lastMonthClosePrice`. |
| `asset_wishlists` | Ativos monitorados / lista de desejos do usuário. Campos: `id`, `userId`, `categoryId`, `name`, `ticker`, `targetPrice`, `currentClosePrice`, `lastMonthClosePrice`, `notes`, `createdAt`, `updatedAt`. |
| `asset_records` | Registro histórico mensal do valor consolidado de uma categoria. Campos: `id`, `categoryId`, `month`, `year`, `amount`, `exchangeRate`, `dividendAmount`. |
| `asset_category_competences` | Registra em quais **anos** uma categoria possui registros, otimizando queries de filtro temporal. Campos: `id`, `categoryId`, `year`. |

### Enum: `CategoryType`

| Valor | Descrição |
|---|---|
| `VARIABLE_BR` | Renda Variável — Mercado Brasileiro (Brapi) |
| `VARIABLE_US` | Renda Variável — Mercado Americano (Alpha Vantage) |
| `CRYPTO` | Criptomoedas (CoinGecko) |
| `FIXED` | Renda Fixa (sem cotação de mercado) |

