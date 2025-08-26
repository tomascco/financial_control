/**
 * Toast Notification System
 *
 * Usage:
 * 1. Using the global helper function:
 *    showToast('Your message here', 'type', duration)
 *
 * 2. Using custom events:
 *    document.dispatchEvent(new CustomEvent('show-toast', {
 *      detail: { message: 'Your message', type: 'info', duration: 5000 }
 *    }))
 *
 * Types: 'info', 'success', 'warning', 'error'
 * Duration: milliseconds (0 = persistent, requires manual dismiss)
 *
 * Examples:
 * - showToast('Hello World!') // Default info toast, 5 second duration
 * - showToast('Success!', 'success', 3000) // Success toast, 3 second duration
 * - showToast('Error occurred', 'error', 0) // Persistent error toast
 */

// Toast notification system
class ToastManager {
  constructor() {
    this.container = document.querySelector('#notifications-container')
    this.template = this.container?.querySelector('template')
    this.setupEventListener();
  }

  setupEventListener() {
    document.addEventListener('financial-control:show-toast', (event) => {
      this.showToast(event.detail)
    })
  }

  showToast({ message, type = 'info', duration = 2000 }) {
    if (!this.container || !this.template) {
      return
    }

    // Clone the template
    const toastElement = this.template.content.cloneNode(true)
    const alertDiv = toastElement.querySelector('.alert')
    const messageSpan = toastElement.querySelector('span')

    // Set the message
    messageSpan.textContent = message

    // Configure toast based on type
    switch (type) {
      case 'success':
        alertDiv.classList.add('alert-success')
        break
      case 'warning':
        alertDiv.classList.add('alert-warning')
        break
      case 'error':
        alertDiv.classList.add('alert-error')
        break
      case 'info':
      default:
        alertDiv.classList.add('alert-info')
        break
    }

    // Add to container
    this.container.appendChild(toastElement)

    // Animate in
    requestAnimationFrame(() => {
      alertDiv.classList.add('opacity-100', 'transition-all', 'duration-300', 'ease-out')
    })

    // Auto remove after duration
    if (duration > 0) {
      setTimeout(() => {
        this.removeToast(alertDiv)
      }, duration)
    }
  }

  removeToast(alertDiv) {
    alertDiv.classList.add('opacity-0', 'translate-y-2', 'transition-all', 'duration-300', 'ease-in')
    setTimeout(() => {
      alertDiv.remove()
    }, 300)
  }
}

// helper function to show toasts
async function showToast(message, type = 'info', duration = 5000) {
  document.dispatchEvent(new CustomEvent('financial-control:show-toast', {
    detail: { message, type, duration }
  }))
}

export { ToastManager, showToast }
