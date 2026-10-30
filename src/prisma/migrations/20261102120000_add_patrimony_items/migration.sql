-- CreateEnum
CREATE TYPE "finance-assets"."PatrimonyItemType" AS ENUM ('REAL_ESTATE', 'VEHICLE', 'EQUIPMENT', 'OTHER_ASSET', 'LIABILITY');

-- CreateTable
CREATE TABLE "finance-assets"."patrimony_items" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "finance-assets"."PatrimonyItemType" NOT NULL,
    "currentValue" DECIMAL(15,2) NOT NULL,
    "purchaseValue" DECIMAL(15,2),
    "acquiredAt" DATE,
    "notes" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "patrimony_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "patrimony_items_userId_isActive_idx" ON "finance-assets"."patrimony_items"("userId", "isActive");

-- AddForeignKey
ALTER TABLE "finance-assets"."patrimony_items" ADD CONSTRAINT "patrimony_items_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
