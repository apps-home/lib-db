-- AlterTable
ALTER TABLE "finance-assets"."asset_categories" ADD COLUMN     "targetPercentage" DECIMAL(5,2);

-- AlterTable
ALTER TABLE "finance-assets"."asset_records" ADD COLUMN     "dividendAmount" DECIMAL(15,2);

-- CreateIndex
CREATE INDEX "user_email_idx" ON "better-auth"."user"("email");

-- CreateIndex
CREATE INDEX "asset_categories_userId_type_idx" ON "finance-assets"."asset_categories"("userId", "type");

-- CreateIndex
CREATE INDEX "asset_category_competences_categoryId_year_idx" ON "finance-assets"."asset_category_competences"("categoryId", "year");

-- CreateIndex
CREATE INDEX "asset_records_categoryId_month_idx" ON "finance-assets"."asset_records"("categoryId", "month");

-- CreateIndex
CREATE INDEX "asset_records_categoryId_year_idx" ON "finance-assets"."asset_records"("categoryId", "year");

-- CreateIndex
CREATE INDEX "asset_records_categoryId_month_year_idx" ON "finance-assets"."asset_records"("categoryId", "month", "year");

-- CreateIndex
CREATE INDEX "assets_ticker_idx" ON "finance-assets"."assets"("ticker");

-- CreateIndex
CREATE INDEX "assets_categoryId_ticker_idx" ON "finance-assets"."assets"("categoryId", "ticker");
