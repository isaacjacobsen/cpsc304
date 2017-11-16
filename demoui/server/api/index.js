import { Router } from 'express'

import users from './users'
import employees from './employees'

const router = Router()

// Add USERS Routes
router.use(users)

router.use(employees)

export default router
