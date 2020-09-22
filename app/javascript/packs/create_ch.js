import $ from 'jquery';
window.jQuery = $
window.$ = $

$(document).ready(()=>{

  $('.create-ch-btn').click((e)=> {
    e.preventDefault()
    $('.create-ch-bg').removeClass('hidden')
  })

  $('.create-cancel-btn').click(()=> {
    $('.create-ch-bg').addClass('hidden')
  })

})