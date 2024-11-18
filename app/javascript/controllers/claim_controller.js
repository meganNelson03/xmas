import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "item" ]
  static classes = [ "hover", "hoverOut" ]

  blur() {
    this.itemTarget.classList.add(this.hoverClass)
  }

  unblur() {
    this.itemTarget.classList.remove(this.hoverClass)
  }
}
