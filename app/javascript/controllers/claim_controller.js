import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "item" ]
  static classes = [ "hover", "hoverOut" ]

  blur() {
    if (!this.isMobile()) {
      this.itemTarget.classList.add(this.hoverClass)
    }
  }

  unblur() {
    this.itemTarget.classList.remove(this.hoverClass)
  }

  isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  }
}
