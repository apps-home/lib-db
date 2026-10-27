-- CreateEnum
CREATE TYPE "finance-assets"."TransactionType" AS ENUM ('OPENING', 'BUY', 'SELL', 'SPLIT', 'REVERSE_SPLIT', 'BONUS');

-- CreateEnum
CREATE TYPE "finance-assets"."TransactionSource" AS ENUM ('MANUAL', 'IMPORT');

-- CreateTable
CREATE TABLE "finance-assets"."asset_transactions" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "finance-assets"."TransactionType" NOT NULL,
    "source" "finance-assets"."TransactionSource" NOT NULL DEFAULT 'MANUAL',
    "date" DATE NOT NULL,
    "quantity" DECIMAL(20,8),
    "price" DECIMAL(15,6),
    "fees" DECIMAL(15,2) NOT NULL DEFAULT 0,
    "factor" DECIMAL(12,6),
    "exchangeRate" DECIMAL(12,6),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "asset_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "asset_transactions_assetId_date_idx" ON "finance-assets"."asset_transactions"("assetId", "date");

-- CreateIndex
CREATE INDEX "asset_transactions_userId_date_idx" ON "finance-assets"."asset_transactions"("userId", "date");

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_transactions" ADD CONSTRAINT "asset_transactions_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "finance-assets"."assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_transactions" ADD CONSTRAINT "asset_transactions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
