-- CreateTable
CREATE TABLE "finance-assets"."market_assets" (
    "id" TEXT NOT NULL,
    "ticker" TEXT NOT NULL,
    "type" "finance-assets"."CategoryType" NOT NULL,
    "name" TEXT NOT NULL,
    "currentClosePrice" DECIMAL(15,4),
    "lastMonthClosePrice" DECIMAL(15,4),
    "priceUpdatedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "market_assets_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "market_assets_ticker_type_key" ON "finance-assets"."market_assets"("ticker", "type");

-- AlterTable
ALTER TABLE "finance-assets"."assets" ADD COLUMN "marketAssetId" TEXT;
ALTER TABLE "finance-assets"."asset_wishlists" ADD COLUMN "marketAssetId" TEXT;

-- Catálogo a partir dos tickers já cadastrados (ativos e wishlist), um por
-- ticker + tipo. Renda fixa não tem cotação de mercado e fica de fora.
-- A cotação vem do registro atualizado mais recentemente.
INSERT INTO "finance-assets"."market_assets"
  ("id", "ticker", "type", "name", "currentClosePrice", "lastMonthClosePrice", "priceUpdatedAt", "createdAt", "updatedAt")
SELECT DISTINCT ON (src."ticker", src."type")
  gen_random_uuid()::text,
  src."ticker",
  src."type",
  src."name",
  src."currentClosePrice",
  src."lastMonthClosePrice",
  CASE WHEN src."currentClosePrice" IS NOT NULL THEN src."updatedAt" END,
  NOW(),
  NOW()
FROM (
  SELECT UPPER(TRIM(a."ticker")) AS "ticker", c."type", a."name",
         a."currentClosePrice", a."lastMonthClosePrice", a."updatedAt"
  FROM "finance-assets"."assets" a
  JOIN "finance-assets"."asset_categories" c ON c."id" = a."categoryId"
  WHERE c."type" <> 'FIXED' AND TRIM(a."ticker") <> ''
  UNION ALL
  SELECT UPPER(TRIM(w."ticker")), c."type", w."name",
         w."currentClosePrice", w."lastMonthClosePrice", w."updatedAt"
  FROM "finance-assets"."asset_wishlists" w
  JOIN "finance-assets"."asset_categories" c ON c."id" = w."categoryId"
  WHERE c."type" <> 'FIXED' AND TRIM(w."ticker") <> ''
) src
ORDER BY src."ticker", src."type", (src."currentClosePrice" IS NULL), src."updatedAt" DESC;

-- Liga os registros existentes ao catálogo
UPDATE "finance-assets"."assets" a
SET "marketAssetId" = m."id"
FROM "finance-assets"."asset_categories" c, "finance-assets"."market_assets" m
WHERE c."id" = a."categoryId"
  AND m."type" = c."type"
  AND m."ticker" = UPPER(TRIM(a."ticker"));

UPDATE "finance-assets"."asset_wishlists" w
SET "marketAssetId" = m."id"
FROM "finance-assets"."asset_categories" c, "finance-assets"."market_assets" m
WHERE c."id" = w."categoryId"
  AND m."type" = c."type"
  AND m."ticker" = UPPER(TRIM(w."ticker"));

-- Em ativos com cotação de mercado o preço passa a vir do catálogo; a coluna
-- fica só como preço manual (renda fixa e ativos sem ticker)
UPDATE "finance-assets"."assets" SET "currentClosePrice" = NULL WHERE "marketAssetId" IS NOT NULL;

-- AlterTable
ALTER TABLE "finance-assets"."assets" DROP COLUMN "lastMonthClosePrice";
ALTER TABLE "finance-assets"."asset_wishlists" DROP COLUMN "currentClosePrice",
DROP COLUMN "lastMonthClosePrice";

-- CreateIndex
CREATE INDEX "assets_marketAssetId_idx" ON "finance-assets"."assets"("marketAssetId");

-- CreateIndex
CREATE INDEX "asset_wishlists_marketAssetId_idx" ON "finance-assets"."asset_wishlists"("marketAssetId");

-- AddForeignKey
ALTER TABLE "finance-assets"."assets" ADD CONSTRAINT "assets_marketAssetId_fkey" FOREIGN KEY ("marketAssetId") REFERENCES "finance-assets"."market_assets"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_wishlists" ADD CONSTRAINT "asset_wishlists_marketAssetId_fkey" FOREIGN KEY ("marketAssetId") REFERENCES "finance-assets"."market_assets"("id") ON DELETE SET NULL ON UPDATE CASCADE;
