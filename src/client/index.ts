import { PrismaPg } from '@prisma/adapter-pg'

let _driver: PrismaPg | null = null

export function getDriver(): PrismaPg {
	if (!_driver) {
		const databaseUrl = process.env.DATABASE_URL

		_driver = new PrismaPg({
			connectionString: databaseUrl
		})
	}
	return _driver
}

// For backwards compatibility
export const driver = new Proxy({} as PrismaPg, {
	get(_target, prop) {
		return (getDriver() as any)[prop]
	}
})
