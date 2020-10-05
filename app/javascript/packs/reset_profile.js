var avatar_small = document.querySelectorAll('.avatar_small')
var avatar_large = document.querySelector('#avatar_large')
  console.log('c')
  document.querySelector('#profile_form').reset()
  fetch("/users/profiles/avatar")
    .then(response => response.json())
    .then(({small,medium,large }) => {
      avatar_small.forEach((e)=>{
        if (small == null && large == null) {
          e.src = "https://ca.slack-edge.com/T018LF2LHK3-U018XMDF20Y-g206a10ded6a-32"
          avatar_large.src = "https://ca.slack-edge.com/T0196R42HU4-U018Z8Q6XU5-g15b03dc0178-192"
        } else {
          e.src = small
          avatar_large.src = large
          document.querySelector('.remove-avatar').classList.remove('hidden')
        }
      })
      
    })
  profileInfo()

function profileInfo(){
  fetch("/users/profiles/edit")
  .then(response => response.json())
  .then(({full_name,phone_number,user}) => {
    document.querySelector("input[name='profile[phone_number]']").value = phone_number
    document.querySelector("input[name='profile[full_name]']").value = full_name
    document.querySelector("input[name='user[nickname]']").value = user["nickname"]
  })
}
