import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    publishableKey: String
  }

  static targets = [
    "authorizeButton",
    "paymentElement",
    "submitButton",
    "message"
  ]

  async authorize() {
    this.stripe = Stripe(this.publishableKeyValue)

    const response = await fetch("/payment_authorization", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      }
    })

    const data = await response.json()

    this.elements = this.stripe.elements({
      clientSecret: data.client_secret
    })

    this.paymentElement = this.elements.create("payment")
    this.paymentElement.mount(this.paymentElementTarget)

    this.authorizeButtonTarget.style.display = "none"
    this.submitButtonTarget.style.display = "block"
  }

  async submit() {
    this.submitButtonTarget.disabled = true
    this.messageTarget.textContent = "Processing..."

    const { error, setupIntent } = await this.stripe.confirmSetup({
      elements: this.elements,
      redirect: "if_required"
    })

    if (error) {
      this.messageTarget.textContent = error.message
      this.submitButtonTarget.disabled = false
      return
    }

    window.location.href =
      `/payment_authorization/confirm?setup_intent_id=${setupIntent.id}`
  }
}
