import $ from 'jquery';


$(document).ready(function () {
  $('.clickopen').click(function (event) {
    $('.open').slideToggle();
    event.stopPropagation();
  })
  $('.open').click(function (event) {
    event.stopPropagation();
  });
  $('html').click(function (e) {
    if (e.target != $('.open')) {
      $('.open').slideUp();
    }
  })
});


$('.upload-btn').click(() => {
  $('#upload-input').trigger('click')
})
