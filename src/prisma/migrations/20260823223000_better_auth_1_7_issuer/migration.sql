-- AlterTable
ALTER TABLE "better-auth"."account" ADD COLUMN IF NOT EXISTS "issuer" TEXT;

-- Backfill existing accounts
UPDATE "better-auth"."account"
SET "issuer" = 'local:credential'
WHERE "issuer" IS NULL;

-- AlterTable
ALTER TABLE "better-auth"."account" ALTER COLUMN "issuer" SET NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX IF NOT EXISTS "account_issuer_accountId_key" ON "better-auth"."account"("issuer", "accountId");
