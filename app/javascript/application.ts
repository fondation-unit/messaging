import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window["Stimulus"] = application;

export { application };

// Controllers
import MessagingController from "./controllers/messaging_controller";

application.register("messaging", MessagingController);
