window.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('.invite-ws-btn')) {
    const form = document.forms['invite-form']
    // 點選按鈕後會顯示DIV
    document.querySelector('.invite-ws-btn').addEventListener('click', () => {
      document.querySelector('.add-people').classList.remove('hidden')
    })
    //點選按鈕後會顯示XX會取消DIV
    document.querySelector('.invite-cancel-btn').addEventListener('click', () => {
      document.querySelector('.add-people').classList.add('hidden')
    })
    const searchInput = form[1]
    const inviteBtn = form[2]
    //如果輸入值符合EMAIL格式就可以送
    searchInput.addEventListener('input',()=>{
      if (searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)) {
        inviteBtn.removeAttribute('disabled')
        inviteBtn.value = 'Add'
        inviteBtn.classList.add('bg-green-500')
        form.addEventListener('submit', ()=>{
          document.querySelector('.add-people').classList.add('hidden')
        })
      }
      //恢復樣式
      else {
        inviteBtn.classList.remove('bg-green-500')
        inviteBtn.value = 'Done'
        inviteBtn.setAttribute('disabled','')
      }
    })
  }
})
