-- CreateTable
CREATE TABLE "finance-assets"."asset_wishlists" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "categoryId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "ticker" TEXT NOT NULL,
    "targetPrice" DECIMAL(15,4),
    "currentClosePrice" DECIMAL(15,4),
    "lastMonthClosePrice" DECIMAL(15,4),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "asset_wishlists_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "asset_wishlists_userId_idx" ON "finance-assets"."asset_wishlists"("userId");

-- CreateIndex
CREATE INDEX "asset_wishlists_categoryId_idx" ON "finance-assets"."asset_wishlists"("categoryId");

-- CreateIndex
CREATE INDEX "asset_wishlists_ticker_idx" ON "finance-assets"."asset_wishlists"("ticker");

-- CreateIndex
CREATE UNIQUE INDEX "asset_wishlists_userId_ticker_key" ON "finance-assets"."asset_wishlists"("userId", "ticker");

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_wishlists" ADD CONSTRAINT "asset_wishlists_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "finance-assets"."asset_wishlists" ADD CONSTRAINT "asset_wishlists_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "finance-assets"."asset_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;
