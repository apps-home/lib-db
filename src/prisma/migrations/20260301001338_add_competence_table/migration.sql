-- CreateTable
CREATE TABLE "finance-assets"."asset_category_competences" (
    "id" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,

    CONSTRAINT "asset_category_competences_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "asset_category_competences_categoryId_year_key" ON "finance-assets"."asset_category_competences"("categoryId", "year");

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_category_competences" ADD CONSTRAINT "asset_category_competences_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "finance-assets"."asset_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
