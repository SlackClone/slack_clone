window.addEventListener('DOMContentLoaded',function(){
  let createChBg = document.querySelector('.create-ch-bg')
  let inviteChBg = document.querySelector('.ch-background')
  let addChBg = document.querySelector('.add-people')
  let profileBg = document.querySelector('.profile-background')
  let inviteChBtn = document.querySelector('.invite-ch-btn')
  let bgGroup = [createChBg,inviteChBg,addChBg,profileBg]

  cancelForm(bgGroup)

  function cancelForm(bgGroup){
    bgGroup.forEach((bg) => {
      if (bg != null) {
        window.addEventListener('keyup', function(e){
          if(e.keyCode === 27) {
            bg.classList.add('hidden')
          }
        })
      }
    })
  }

})

