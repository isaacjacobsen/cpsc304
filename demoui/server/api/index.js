import { Router } from 'express'

import users from './users'
import queries from './queries'

const router = Router()

// Add USERS Routes
router.use(users)
router.use(queries)

export default router
