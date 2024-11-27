// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
Rails.start();

import "jquery"
import "controllers"
import "popper"
import "bootstrap"

import './external/masonry'
import "select2"
import "slickjs"

import {far} from "@fortawesome/free-regular-svg-icons"
import {fas} from "@fortawesome/free-solid-svg-icons"
import {fab} from "@fortawesome/free-brands-svg-icons"
import {library} from "@fortawesome/fontawesome-svg-core"
import "@fortawesome/fontawesome-free"
library.add(far, fas, fab)

try {
$(document).on("ready turbo:load", function(){
  $('[data-toggle="tooltip"]').tooltip();

  $('.carousel').on('afterChange', function(event, slick, currentSlide, nextSlide){
    var elt = slick.$slides.get(currentSlide);

    var href = console.log($(elt).find('a').attr('href'))
    var groupId = $(elt).find('a').data('group-id')

    console.log("href:")
    console.log(href)

    $.ajax({
      type: 'GET',
      url: href,
      data: {
        group_id: groupId
      }
    });
  });

  $('.multiselect-field').select2({});
  
  if ($('.masonry').length) { 
    let msnry = new Masonry( '.masonry', {
      itemSelector: '.item-box',
    });

    let infScroll = new InfiniteScroll('.masonry', {
      path: '.pagination__next',
      append: '.item-box',
      history: false,
      outlayer: msnry,
      hideNav: '.pagination__next'
    });

    infScroll.on( 'load', function( body ) {
      $('[data-toggle="tooltip"]').tooltip()
      $('.loader').fadeOut()
    });

    infScroll.on('request', function( path, fetchPromise ) {
      $('.loader').css('opacity', '1')
      $('.loader').fadeIn('fast');
    });
  }
});

} catch (error) {
  console.log(error)
}