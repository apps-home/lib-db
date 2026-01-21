import { PrismaPg } from '@prisma/adapter-pg'

export const driver = new PrismaPg({
	connectionString: process.env.DATABASE_URL
})
