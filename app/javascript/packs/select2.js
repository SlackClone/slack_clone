import $ from "jquery"
import 'select2'
import 'select2/dist/css/select2.css';

$(document).ready(function() {
  $('#user_list').select2({
    placeholder: "輸入欲邀請成員",
    allowClear: true
  })
  $('#ws_user').select2({
    placeholder: "輸入欲邀請成員",
    allowClear: true,
  })
  // 打一包ws的user的json給select2
  $('.create-ch-btn').click((e)=>{
    let workspaceId =($('.create-ch-btn')[0].href).split('/')
    fetch(`/workspaces/${workspaceId[4]}/workspace_users`)
    .then(response => response.json())
    .then((data) => {
      data.forEach((e)=>{
        let opt = document.createElement('option')
        opt.textContent = e[0]
        opt.value = e[1]
        $('#ws_user').append(opt)
      })
    })
  })


  $('#user_list').on("change", function() {
    console.log()
    if($('#user_list').select2("val").length != 0) {
      $('.invite-btn').removeAttr('disabled')
      $('.invite-btn').removeClass('cursor-not-allowed text-gray-700 bg-gray-400')
      $('.invite-btn').addClass('bg-sladock text-white cursor-pointer')
    } else {
      $('.invite-btn').attr('disabled','')
      $('.invite-btn').removeClass('bg-sladock text-white cursor-pointer') 
      $('.invite-btn').addClass('cursor-not-allowed text-gray-700 bg-gray-400')
           
    }
  })
  $('.invite-ch-btn').click(() => {
    $('.ch-background').removeClass('hidden')
    $('#user_list').focus()

  })
  $('.invite-cancel-btn').click(() => {
    $('.ch-background').addClass('hidden')
  })
  $('.ch-background').click((e) => {
    if (e.target === $('.ch-background')[0])
    $('.ch-background').addClass('hidden')
  })
})





