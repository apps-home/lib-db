/*
  Warnings:

  - Made the column `ticker` on table `assets` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "finance-assets"."assets" ADD COLUMN     "averagePrice" DECIMAL(15,4),
ADD COLUMN     "broker" TEXT,
ADD COLUMN     "isActive" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "quantity" DECIMAL(15,8),
ALTER COLUMN "ticker" SET NOT NULL;
