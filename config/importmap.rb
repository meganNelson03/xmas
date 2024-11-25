# Pin npm packages by running ./bin/importmap

pin "application"

pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery/dist/jquery.js"
# pin "masonryjs", to: 'https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js', preload: true
pin "infinitescroll", to: "https://unpkg.com/infinite-scroll@4/dist/infinite-scroll.pkgd.min.js", preload: true
pin "select2", to: "https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"
pin "slickjs", to: "https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"

pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.0.3-1/lib/assets/compiled/rails-ujs.js"

pin "@fortawesome/fontawesome-free", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-free@6.0.0/js/fontawesome.js"
pin "@fortawesome/fontawesome-svg-core", to: "https://ga.jspm.io/npm:@fortawesome/fontawesome-svg-core@1.3.0/index.es.js"
pin "@fortawesome/free-brands-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-brands-svg-icons@6.0.0/index.es.js"
pin "@fortawesome/free-regular-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-regular-svg-icons@6.0.0/index.es.js"
pin "@fortawesome/free-solid-svg-icons", to: "https://ga.jspm.io/npm:@fortawesome/free-solid-svg-icons@6.0.0/index.es.js"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@stimulus-components/rails-nested-form", to: "@stimulus-components--rails-nested-form.js" # @5.0.0
