import { PrismaNeon } from '@prisma/adapter-neon'

let _driver: PrismaNeon | null = null

export function getDriver(): PrismaNeon {
	if (!_driver) {
		const connectionString = process.env.DATABASE_URL

		if (!connectionString) {
			throw new Error('DATABASE_URL environment variable is not set')
		}

		_driver = new PrismaNeon({ connectionString })
	}
	return _driver
}

// For backwards compatibility
export const driver = new Proxy({} as PrismaNeon, {
	get(_target, prop) {
		return (getDriver() as any)[prop]
	}
})
