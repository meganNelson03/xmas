import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "msg", "progress" ]

  connect() {
    $(this.progressTarget).animate(
      { width: '100%' },
       2500, () => this.move()
    );
  }

  move() {
    this.msgTarget.classList.add("move")
  }
}
