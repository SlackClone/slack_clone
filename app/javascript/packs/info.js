import $ from "jquery"

$(document).ready(function() {
$('.info-cancel').click(()=>{
  $('.info').addClass('hidden')
})
$('.edit_profile').click(()=>{
  $('.info').toggleClass("hidden")
})

})