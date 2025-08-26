// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { ToastManager } from "./toast_manager"

// Re-initialize after Turbo navigation
document.addEventListener('turbo:load', () => { new ToastManager() })
