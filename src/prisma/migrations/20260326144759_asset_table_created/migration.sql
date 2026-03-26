-- CreateEnum
CREATE TYPE "finance-assets"."CategoryType" AS ENUM ('VARIABLE_BR', 'VARIABLE_US', 'CRYPTO', 'FIXED');

-- AlterTable
ALTER TABLE "finance-assets"."asset_categories" ADD COLUMN     "type" "finance-assets"."CategoryType" NOT NULL DEFAULT 'FIXED';

-- CreateTable
CREATE TABLE "finance-assets"."assets" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ticker" TEXT,
    "currentClosePrice" DECIMAL(15,4),
    "lastMonthClosePrice" DECIMAL(15,4),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "assets_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "assets_categoryId_idx" ON "finance-assets"."assets"("categoryId");

-- CreateIndex
CREATE INDEX "asset_categories_userId_idx" ON "finance-assets"."asset_categories"("userId");

-- CreateIndex
CREATE INDEX "asset_category_competences_categoryId_idx" ON "finance-assets"."asset_category_competences"("categoryId");

-- CreateIndex
CREATE INDEX "asset_records_categoryId_idx" ON "finance-assets"."asset_records"("categoryId");

-- AddForeignKey
ALTER TABLE "finance-assets"."assets" ADD CONSTRAINT "assets_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "finance-assets"."asset_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
