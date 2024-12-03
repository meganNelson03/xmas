import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'slider', 'modal', 'nextButton' ]
  static classes = [ 'modalDisplay' ]

  connect() {
    this.modalTarget.addEventListener('hide.bs.modal', function(event) {
      $('.modal-carousel').removeClass('d-block')
    })

    this.initModal()
    this.initSlider()
  }

  accept(event) {
    event.target.innerHTML = 'Accepted'
    this.progressSlide()
  }

  deny(event) {
    event.target.innerHTML = 'Denied'
    this.progressSlide()
  }

  progressSlide() {
    const sauce = this

    if (!$(this.sliderTarget).find('.slick-active').hasClass('last-slide')) {
      setTimeout(function() {
        $(sauce.sliderTarget).slick('slickNext');
      }, 500)
    } else {
      setTimeout(function() {
        $('.modal-carousel').modal('hide').remove()
      }, 500)
    }
  }

  options () {
    return {
      infinite: false,
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      draggable: false,
      swipe: false,
      swipeToSlide: false,
      touchMove: false
    };
  }

  unblur() {
    this.modalTarget.classList.add(this.modalDisplayClass)
  }

  initModal() {
    $(this.modalTarget).modal('show');
  }

  initSlider() {
    $(this.sliderTarget).slick(this.options())
    this.unblur()
  }
}
