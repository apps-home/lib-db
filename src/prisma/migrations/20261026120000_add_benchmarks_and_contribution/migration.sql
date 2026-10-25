-- CreateEnum
CREATE TYPE "finance-assets"."BenchmarkType" AS ENUM ('CDI', 'IBOV', 'SP500_BRL');

-- AlterTable
ALTER TABLE "finance-assets"."asset_records" ADD COLUMN "contributionAmount" DECIMAL(15,2);

-- CreateTable
CREATE TABLE "finance-assets"."benchmark_returns" (
    "id" TEXT NOT NULL,
    "benchmark" "finance-assets"."BenchmarkType" NOT NULL,
    "year" INTEGER NOT NULL,
    "month" INTEGER NOT NULL,
    "returnPct" DECIMAL(12,6) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "benchmark_returns_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "benchmark_returns_benchmark_year_month_idx" ON "finance-assets"."benchmark_returns"("benchmark", "year", "month");

-- CreateIndex
CREATE UNIQUE INDEX "benchmark_returns_benchmark_year_month_key" ON "finance-assets"."benchmark_returns"("benchmark", "year", "month");
