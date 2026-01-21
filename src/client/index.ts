import { PrismaPg } from '@prisma/adapter-pg'

const databaseUrl = process.env.DATABASE_URL

if (!databaseUrl) {
	throw new Error('DATABASE_URL environment variable is not defined')
}

export const driver = new PrismaPg({
	connectionString: databaseUrl
})
