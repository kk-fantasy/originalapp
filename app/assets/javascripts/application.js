import Rails from "@rails/ujs"
Rails.start()
//= require rails-ujs

document.addEventListener('turbo:load', function() {
    $('#search').autocomplete({
      source: '/search_suggestions',
      minLength: 2
    });
  });
  //= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete
//= require_tree .
