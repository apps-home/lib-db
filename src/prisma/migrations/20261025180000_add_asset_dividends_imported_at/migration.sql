-- AlterTable
ALTER TABLE "finance-assets"."assets" ADD COLUMN "dividendsImportedAt" TIMESTAMP(3);

-- Ativos que já têm proventos importados não precisam ser buscados de novo
UPDATE "finance-assets"."assets"
SET "dividendsImportedAt" = NOW()
WHERE EXISTS (
  SELECT 1 FROM "finance-assets"."asset_dividends" d WHERE d."assetId" = "assets"."id"
);
