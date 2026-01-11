// packages/lib-db/src/index.ts

// Importa direto da dependência instalada
import { PrismaClient } from "@prisma/client";

// Re-exporta tudo
export * from "@prisma/client";

// Singleton para Dev (Next.js Hot Reloading Friendly)
const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };

let prismaInstance: PrismaClient | undefined;

// Função para obter ou criar o PrismaClient de forma lazy
function getPrismaClient(): PrismaClient {
	if (process.env.NODE_ENV !== "production") {
		if (!globalForPrisma.prisma) {
			globalForPrisma.prisma = new PrismaClient();
		}
		return globalForPrisma.prisma;
	}
	if (!prismaInstance) {
		prismaInstance = new PrismaClient();
	}
	return prismaInstance;
}

// Exporta como getter usando Proxy para inicialização verdadeiramente lazy
// Isso evita que o PrismaClient seja criado no momento do import
export const prisma = new Proxy({} as PrismaClient, {
	get(_target, prop) {
		const client = getPrismaClient();
		const value = (client as any)[prop];
		if (typeof value === "function") {
			return value.bind(client);
		}
		return value;
	},
});
