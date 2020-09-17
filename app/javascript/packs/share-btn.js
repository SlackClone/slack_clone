import $ from 'jquery';
window.jQuery = $
window.$ = $



$(document).ready(function () {
  $('.share-btn').click(function (event) {
    event.preventDefault();
    $('.popup').show();
  });
  $('.cancel').click(function (event) {
    event.preventDefault();
    $('.popup').hide();
  });

});