-- AlterEnum
ALTER TYPE "finance-assets"."BenchmarkType" ADD VALUE 'IFIX';
ALTER TYPE "finance-assets"."BenchmarkType" ADD VALUE 'BTC_BRL';

-- O S&P 500 passou a usar o índice de retorno total (^SP500TR, com dividendos).
-- Os meses gravados com o índice de preço são buscados de novo sob demanda.
DELETE FROM "finance-assets"."benchmark_returns" WHERE "benchmark" = 'SP500_BRL';
