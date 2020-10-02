var avatar_small = document.querySelectorAll('.avatar_small')
var avatar_large = document.querySelector('#avatar_large')
  console.log('c')
  document.querySelector('#profile_form').reset()
  fetch("/users/profiles/avatar")
    .then(response => response.json())
    .then(({small,medium,large }) => {
      avatar_small.forEach((e)=>{
        e.src = small
      })
      avatar_large.src = large
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
