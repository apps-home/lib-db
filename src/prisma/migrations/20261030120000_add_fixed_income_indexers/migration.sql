-- CreateEnum
CREATE TYPE "finance-assets"."FixedIncomeIndexer" AS ENUM ('CDI', 'IPCA', 'PRE');

-- CreateEnum
CREATE TYPE "finance-assets"."EconomicIndicator" AS ENUM ('CDI', 'IPCA');

-- AlterTable
ALTER TABLE "finance-assets"."assets" ADD COLUMN "indexer" "finance-assets"."FixedIncomeIndexer",
ADD COLUMN "indexerRate" DECIMAL(10,4),
ADD COLUMN "investedAt" DATE,
ADD COLUMN "maturityAt" DATE;

-- CreateTable
CREATE TABLE "finance-assets"."indicator_rates" (
    "id" TEXT NOT NULL,
    "indicator" "finance-assets"."EconomicIndicator" NOT NULL,
    "date" DATE NOT NULL,
    "ratePct" DECIMAL(12,8) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "indicator_rates_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "indicator_rates_indicator_date_key" ON "finance-assets"."indicator_rates"("indicator", "date");
