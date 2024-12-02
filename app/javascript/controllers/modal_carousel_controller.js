import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'slider', 'modal', 'nextButton' ]
  static classes = [ 'modalDisplay' ]

  connect() {
    console.log("connected")

    this.modalTarget.addEventListener('hide.bs.modal', function(event) {
      $('.modal-carousel').removeClass('d-block')
    })

    if (this.isMobile() || this.isSmallScreen()) {
      this.initMobileSlider()
    } else {
      this.initModal()
      this.initSlider()
    }
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
      infinite: true,
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      draggable: false
    };
  }

  unblur() {
    this.modalTarget.classList.add(this.modalDisplayClass)
  }

  initMobileSlider() {
    var groupId = $(this.currentGroupTarget).data('current-group-id')
  
    var index = $(this.sliderTarget).find(`[data-slide-index="${groupId}"`).data('slick-index')

    $(this.sliderTarget).slick(this.options()).slick('slickGoTo', index);
  }

  initModal() {
    $(this.modalTarget).modal('show');
  }

  initSlider() {
    $(this.sliderTarget).slick(this.options())
    this.unblur()
  }

  isSmallScreen() {
    return $(window).width() < 989
  }

  isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  }
}
