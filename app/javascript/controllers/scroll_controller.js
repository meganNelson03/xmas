import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "scrollButton" ]

  connect() {
    document.addEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    var rootElement = document.documentElement
    var scrollTotal = rootElement.scrollHeight - rootElement.clientHeight
  
    if ((rootElement.scrollTop / scrollTotal ) > 0.30 ) {
      scrollButton.classList.add("showBtn")
    } else {
      scrollButton.classList.remove("showBtn")
    }
  }

  scrollToTop() {
    var rootElement = document.documentElement
    rootElement.scrollTo({
      top: 0,
      behavior: 'smooth'
    })
  }
}
