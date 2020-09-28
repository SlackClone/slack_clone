import $ from 'jquery';
window.jQuery = $
window.$ = $

$(document).ready(function() {
  $('.info-cancel').click(()=>{
    $('.info').addClass('hidden')
  })
  $('.edit_profile').click(()=>{
    $('.open').slideUp();
    $('.profile-background').removeClass("hidden")
  })

  $('.avatar-btn').click(()=>{
    $('#avatar').click()
  })
  $('.profile-cancel-btn').click(()=>{
    $('.profile-background').addClass("hidden")
  })
  $('.profile-btn').click(()=>{    
    $('.profile-background').addClass("hidden")
  })

  fetch("http://localhost:3000/users/profiles/edit")
    .then(response => response.json())
    .then(({full_name,phone_number}) => {
      console.log(full_name)
      $("input[name='profile[full_name]'").val(full_name)
      $("input[name='profile[phone_number]']").val(phone_number)
    })
    

})