// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import CountdownController from "countdown_controller"
application.register("countdown", CountdownController)
eagerLoadControllersFrom("controllers", application)
