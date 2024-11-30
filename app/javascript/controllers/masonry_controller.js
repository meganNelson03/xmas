import { Controller } from "@hotwired/stimulus"

let masonryElement;

export default class extends Controller {
  static targets = [ "item" ]
  static classes = [ "hover", "hoverOut" ]

  connect() {
    this.initMasonry()
  }

  disconnect() {
    masonryElement.destroy()
  }

  initMasonry() {
    masonryElement = new Masonry( '.masonry', {
      itemSelector: '.item-box',
    });

    let infScroll = new InfiniteScroll('.masonry', {
      path: '.pagination__next',
      checkLastPage: '.pagination__next',
      append: '.item-box',
      history: false,
      outlayer: masonryElement,
      hideNav: '.pagination__next'
    });

    infScroll.on( 'load', function( body ) {
      $('.loader').fadeOut()
    });

    infScroll.on('request', function( path, fetchPromise ) {
      $('.loader').css('opacity', '1')
      $('.loader').fadeIn('fast');
    });
  }
}
