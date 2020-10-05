import $ from 'jquery';
$(document).ready(function() {
  // 關閉右側INFO
  $('.info-cancel').click(()=>{
    $('.info').addClass('hidden')
  })
  // 開啟編輯彈跳視窗 
  $('.edit_profile').click(()=>{
    $('.open').slideUp();
    $('.profile-background').removeClass("hidden")
  })
  //上傳按鈕按下跳轉至剪裁葉面
  $('.avatar-btn').click(()=>{
    $('#avatar').click()
    $('#avatar').change(()=>{
      $('.profile-form').addClass("hidden")
      $('.resize-area').removeClass("hidden")
    })
  })
  $('.avatar-update-btn').click(()=>{
    // 關閉彈跳視窗
    $('.profile-background').addClass("hidden")
    // 重新點選會回到一開始的編輯表單
    $('.profile-form').removeClass("hidden")
    // 將剪裁的頁面隱藏
    $('.resize-area').addClass("hidden")
  })
  // 叉叉按鈕
  $('.profile-cancel-btn').click(()=>{
    $('.profile-background').addClass("hidden")
    $('.resize-area').addClass("hidden")
    $('.profile-form').removeClass("hidden")
  })
  // 按下SAVE關閉視窗
  $('.profile-btn').click(()=>{    
    $('.profile-background').addClass("hidden")
  })
  // 移除照片更換為預設照片(假象)
  $('.remove-avatar').click(()=>{
    $('.remove-avatar').addClass('hidden')
    const large_url = "https://ca.slack-edge.com/T0196R42HU4-U018Z8Q6XU5-g15b03dc0178-192"
    const small_url = "https://ca.slack-edge.com/T018LF2LHK3-U018XMDF20Y-g206a10ded6a-32"
    $('#avatar_large').attr('src',large_url)
    $('.avatar_small').attr('src',small_url)
  })
  // 抓取PROFILE資料到表單裡
  fetch("/users/profiles/edit")
    .then(response => response.json())
    .then(({full_name,phone_number,user}) => {
      
      $("input[name='profile[full_name]'").val(full_name)
      $("input[name='profile[phone_number]']").val(phone_number)
      $("input[name='user[nickname]']").val(user["nickname"])
    })  
  })
