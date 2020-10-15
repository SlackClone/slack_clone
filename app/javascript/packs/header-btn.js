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
  $('.edit_profile').click(()=>{
    $('.full-name-input').focus()
  })
});


$('.upload-btn').click(() => {
  $('#upload-input').trigger('click')
})

