import { driver } from './client'
import { PrismaClient } from './prisma/generated/prisma/client'

export * from './prisma/generated/prisma/client'

const globalForPrisma = global as unknown as { prisma: PrismaClient }

let prismaInstance: PrismaClient | undefined

function getPrismaClient(): PrismaClient {
	if (process.env.NODE_ENV !== 'production') {
		if (!globalForPrisma.prisma) {
			globalForPrisma.prisma = new PrismaClient({ adapter: driver })
		}
		return globalForPrisma.prisma
	}
	if (!prismaInstance) {
		prismaInstance = new PrismaClient({ adapter: driver })
	}
	return prismaInstance
}

export const prisma = new Proxy({} as PrismaClient, {
	get(_target, prop) {
		const client = getPrismaClient()

		const value = (client as any)[prop]
		if (typeof value === 'function') {
			return value.bind(client)
		}
		return value
	}
})
