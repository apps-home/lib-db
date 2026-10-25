-- CreateEnum
CREATE TYPE "finance-assets"."DividendType" AS ENUM ('DIVIDEND', 'JCP', 'INCOME', 'OTHER');

-- CreateEnum
CREATE TYPE "finance-assets"."DividendSource" AS ENUM ('MANUAL', 'SYNC');

-- AlterEnum
ALTER TYPE "finance-assets"."CategoryType" ADD VALUE 'FII';

-- CreateTable
CREATE TABLE "finance-assets"."asset_dividends" (
    "id" TEXT NOT NULL,
    "assetId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "finance-assets"."DividendType" NOT NULL DEFAULT 'DIVIDEND',
    "source" "finance-assets"."DividendSource" NOT NULL DEFAULT 'MANUAL',
    "amount" DECIMAL(15,2) NOT NULL,
    "rateAmount" DECIMAL(15,4),
    "quantity" DECIMAL(15,8),
    "exchangeRate" DECIMAL(10,4),
    "comDate" TIMESTAMP(3),
    "paymentDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "asset_dividends_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "asset_dividends_userId_paymentDate_idx" ON "finance-assets"."asset_dividends"("userId", "paymentDate");

-- CreateIndex
CREATE INDEX "asset_dividends_assetId_idx" ON "finance-assets"."asset_dividends"("assetId");

-- CreateIndex
CREATE UNIQUE INDEX "asset_dividends_assetId_type_paymentDate_key" ON "finance-assets"."asset_dividends"("assetId", "type", "paymentDate");

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_dividends" ADD CONSTRAINT "asset_dividends_assetId_fkey" FOREIGN KEY ("assetId") REFERENCES "finance-assets"."assets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_dividends" ADD CONSTRAINT "asset_dividends_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
