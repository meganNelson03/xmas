import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'slider', 'currentGroup' ]
  static classes = []

  connect() {
    if (this.isMobile() || this.isSmallScreen()) {
      this.initMobileSlider()
    } else {
      this.initSlider()
    }
  }

  options () {
    return {
      infinite: true,
      slidesToShow: 3,
      slidesToScroll: 1,
      prevArrow:"<button class='carousel-prev arrow'><span class='fa-stack fa-1x claim-icon'><i class='fa-solid fa-circle fa-stack-2x icon-bg green'></i><i class='fa-solid fa-chevron-left fa-stack-1x fa-inverse icon-fg'></i></span></button>",
      nextArrow:"<button class='carousel-next arrow'><span class='fa-stack fa-1x claim-icon'><i class='fa-solid fa-circle fa-stack-2x icon-bg green'></i><i class='fa-solid fa-chevron-right fa-stack-1x fa-inverse icon-fg'></i></span></button>",
      responsive: [
        {
          breakpoint: 1024,
          settings: {
              slidesToShow: 1,
              slidesToScroll: 1,
          }
        },
        {
          breakpoint: 989,
          settings: {
              slidesToShow: 2,
              slidesToScroll: 1,
          }
        },
        {
          breakpoint: 767,
          settings: {
              slidesToShow: 1,
              slidesToScroll: 1
          }
        }
      ]
    };
  }

  initMobileSlider() {
    var groupId = $(this.currentGroupTarget).data('current-group-id')
  
    var index = $(this.sliderTarget).find(`[data-slide-index="${groupId}"`).data('slick-index')


    $(this.sliderTarget).slick(this.options()).slick('slickGoTo', index);
  }

  initSlider() {
    $(this.sliderTarget).slick(this.options())
  }

  isSmallScreen() {
    console.log($(window).width())
    return $(window).width() < 989
  }

  isMobile() {
    return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  }
}
