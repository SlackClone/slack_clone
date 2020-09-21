window.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('.invite-ws-btn')) {
    const form = document.forms[0]
    const searchInput = form[1]
    const inviteBtn = form[2]
    const background = document.querySelector('.add-people')
    // 點選按鈕後會顯示DIV
    document.querySelector('.invite-ws-btn').addEventListener('click', () => {
      background.classList.remove('hidden')
      searchInput.focus()
    })
    //點選按鈕後會顯示XX會取消DIV
    document.querySelector('.invite-cancel-btn').addEventListener('click', () => {
      background.classList.add('hidden')
    })
    background.addEventListener('click', (e) => {
      if (e.target === background) {
        background.classList.add('hidden')
      }
    })
    //如果輸入值符合EMAIL格式就可以送
    searchInput.addEventListener('input',()=>{
      if (searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)) {
        inviteBtn.removeAttribute('disabled')
        inviteBtn.value = 'Add'
        inviteBtn.classList.add('bg-green-500')
        form.addEventListener('submit', ()=>{
          background.classList.add('hidden')
        })
      } else {
        inviteBtn.classList.remove('bg-green-500')
        inviteBtn.value = '請輸入'
        inviteBtn.setAttribute('disabled','')
      }
    })
  }
})
