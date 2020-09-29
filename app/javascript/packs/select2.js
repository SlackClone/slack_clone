import $ from "jquery"
import 'select2'
import 'select2/dist/css/select2.css'


$(document).ready(function() {
  $('#user_list').select2({
    placeholder: "輸入欲邀請成員",
    allowClear: true
  })

  // $('#message_messageable_id').select2({
  //   closeOnSelect: false

  // })


  $('#user_list').on("change", function() {
    if($('#user_list').select2("val") != []) {
      $('.invite-btn').val('add')
      $('.invite-btn').removeAttr('disabled')
      $('.invite-btn').addClass('bg-blue-500','text-white')
    }
  })
  $('.invite-ch-btn').click(() => {
    $('.ch-background').removeClass('hidden')
  })
  $('.invite-cancel-btn').click(() => {
    $('.ch-background').addClass('hidden')
  })
  $('.ch-background').click((e) => {
    if (e.target === $('.ch-background')[0])
    $('.ch-background').addClass('hidden')
  })
})





