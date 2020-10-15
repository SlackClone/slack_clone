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
    $("input[name='profile[full_name]").focus()
  })
});


$('.upload-btn').click(() => {
  $('#upload-input').trigger('click')
})

