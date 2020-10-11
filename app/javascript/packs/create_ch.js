import $ from 'jquery';

$(document).ready(()=>{

  $('.create-ch-btn').click((e)=> {
    e.preventDefault()
    $('.create-ch-bg').removeClass('hidden')
  })

  $('.create-cancel-btn').click(()=> {
    $('.create-ch-bg').addClass('hidden')
  })
  // 點擊背景也能取消表單
  $('.create-ch-bg').click((e)=> {
    if (e.target == $('.create-ch-bg')[0]){
      $('.create-ch-bg').addClass('hidden')
    }
  })
})