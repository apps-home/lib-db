// index.ts dentro do submodule
// Importa do output definido no schema
import { PrismaClient } from './prisma/generated/client';

// Re-exporta a classe e os tipos para serem usados fora
export { PrismaClient };
export * from './prisma/generated/client';

// Singleton para evitar múltiplas conexões em dev (opcional, mas recomendado)
export const prisma = new PrismaClient();