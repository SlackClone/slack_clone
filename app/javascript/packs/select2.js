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
  $('.create-ch-btn').click(()=>{
    let workspaceId = (window.location.href).split('/')
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





