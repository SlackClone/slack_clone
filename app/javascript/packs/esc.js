window.addEventListener('DOMContentLoaded',function(){
  let createChBg = document.querySelector('.create-ch-bg')
  let inviteChBg = document.querySelector('.ch-background')
  let addChBg = document.querySelector('.add-people')
  let profileBg = document.querySelector('.profile-background')
  let inviteChBtn = document.querySelector('.invite-ch-btn')
  let bgGroup = [createChBg,inviteChBg,addChBg,profileBg]
  if(inviteChBtn) {
    inviteChBtn.addEventListener('click',(e)=>{
      inviteChBg.addEventListener('keydown',(e)=>{
        if(e.keyCode === 27) {
          inviteChBg.classList.add('hidden')
        }
      })
    })
  }
  
  cancelForm(bgGroup)

  function cancelForm(bgGroup){
    bgGroup.forEach((bg) => {
      if (bg != null) {
        bg.addEventListener('keydown', function(e){
          if(e.keyCode === 27) {
            bg.classList.add('hidden')
          }
        })
      }
    })
  }

})

