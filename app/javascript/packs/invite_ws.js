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
    // background.addEventListener('keydown', (e) => {
    //   console.log(background)
    //   if(e.keyCode === 27) {
    //     background.classList.add('hidden')
    //   }
    // })
    //如果輸入值符合EMAIL格式就可以送
    searchInput.addEventListener('input',()=>{
      if (searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)) {
        inviteBtn.removeAttribute('disabled')
        inviteBtn.classList.remove('bg-gray-400')
        inviteBtn.classList.remove('text-gray-700')
        inviteBtn.classList.remove('cursor-not-allowed')
        inviteBtn.classList.add('bg-sladock')
        inviteBtn.classList.add('text-white')
        inviteBtn.classList.add('cursor-pointer')
        form.addEventListener('submit', ()=>{
          background.classList.add('hidden')
        })
      } else {
        inviteBtn.classList.remove('bg-sladock')
        inviteBtn.classList.remove('text-white')
        inviteBtn.classList.remove('cursor-pointer')
        inviteBtn.classList.add('text-gray-700')
        inviteBtn.classList.add('bg-gray-400')
        inviteBtn.classList.add('cursor-not-allowed')
        inviteBtn.setAttribute('disabled','')
      }
    })
  }
})
