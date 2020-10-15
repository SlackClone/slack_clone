import $ from 'jquery';

$(document).ready(()=>{

  $('.create-ch-btn').click((e)=> {
    e.preventDefault()
    $('.create-ch-bg').removeClass('hidden')
    $('.create-ch-input').focus()
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
  $('.create-ch-input').on('input', ()=>{
    let input = $('.create-ch-input')
    if (input.val() != "" && !(matchChannel(input.val()))) {
      $('.create-ch-submit').removeAttr('disabled')
      $('.create-ch-submit').removeClass('cursor-not-allowed text-gray-700 bg-gray-400')
      $('.create-ch-submit').addClass('bg-sladock text-white cursor-pointer')
      $('.error-span').addClass('hidden')
    } else if(matchChannel(input.val())){
      $('.create-ch-submit').attr('disabled','')
      $('.create-ch-submit').removeClass('bg-sladock text-white cursor-pointer') 
      $('.create-ch-submit').addClass('cursor-not-allowed text-gray-700 bg-gray-400')
      $('.error-span').removeClass('hidden')  
    } else {
      $('.create-ch-submit').attr('disabled','')
      $('.create-ch-submit').removeClass('bg-sladock text-white cursor-pointer') 
      $('.create-ch-submit').addClass('cursor-not-allowed text-gray-700 bg-gray-400')
      $('.error-span').addClass('hidden')  
    }
  })

    function matchChannel(input){
      let arr = []
      $('.channel-each').each((e)=>{
        arr.push($('.channel-each')[e].textContent)
      })
      return arr.find((e) => e == input)
    }



  })
