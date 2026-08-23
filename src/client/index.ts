import { PrismaNeon } from '@prisma/adapter-neon'

let _driver: PrismaNeon | null = null

export function getDriver(): PrismaNeon {
	if (!_driver) {
		const connectionString = process.env.DATABASE_URL

		_driver = new PrismaNeon({ connectionString })
	}
	return _driver
}

export const driver = new Proxy({} as PrismaNeon, {
	get(_target, prop) {
		return (getDriver() as any)[prop]
	}
})
