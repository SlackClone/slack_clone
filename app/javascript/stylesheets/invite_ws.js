
window.addEventListener('DOMContentLoaded', function(){
  if (document.querySelector('.invite-ws-btn')) {
    //索取workspaceId
    const workspaceId = window.location.href.match(/\d*$/)
    const url = `http://localhost:3000//api/v1/users_workspaces.json?workspace=${workspaceId[0]}`
    const inviteBtn = document.querySelector('.invite-btn')
    const users = []
    fetch(url)
    .then(blob => blob.json())
    .then(data => users.push(...data))
  
    const memberGroup = document.querySelector('.member-group')
    //點選按鈕後會顯示DIV
    document.querySelector('.invite-ws-btn').addEventListener('click', function(){
      document.querySelector('.add-people').classList.remove('hidden')
    })
    //點選按鈕後會顯示XX會取消DIV
    document.querySelector('.invite-cancel-btn').addEventListener('click', function(){
      document.querySelector('.add-people').classList.add('hidden')
    })
    //INPUT事件
    const searchInput = document.querySelector('.search')
    searchInput.addEventListener('input',displayMatches)
    //顯示出符合規則的值並innerHTML
    function displayMatches() {
      const matchArray = findMatches(this.value,users)
      const html = matchArray.map(place => {
        const regex = new RegExp(this.value, 'g')
        const nickname = place.nickname.replace(regex, `<span class="hl">${this.value}</span>`)
        return `
          <div class="bg-gray-200 flex justify-between items-center px-3">
            <p class="name font-bold">${nickname}</p>
            <span class="text-xs text-gray-600">Already in this channel</span>
          </div> `
      }).join('')
      
      //如果INPUT的值不為空而且html不為空的時候顯示memberGroup
      if (searchInput.value && html !== '') {
        memberGroup.classList.remove('hidden')
        memberGroup.innerHTML = html
        //如果INPUT的值符合EMAIL格式的話顯示memberGroup並將submit按鈕enabled並更換樣式
      } else if (searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)) {
        memberGroup.classList.add('hidden')
        inviteBtn.removeAttribute('disabled')
        inviteBtn.value = 'Add'
        inviteBtn.classList.add('bg-blue-500','text-white')
        inviteBtn.addEventListener('click',function(){
          document.querySelector('.add-people').classList.add('hidden')
        })
        //如果INPUT的值不符合EMAIL格式的話顯示memberGroup而且HTML為空的時候隱藏memberGroup且顯示找不到的SPAN
      } else if (!searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/) && html == '') {
        memberGroup.classList.remove('hidden')
        memberGroup.innerHTML = `<span class="hl">No one found matching ${searchInput.value}</span>`
      } else {
        //輸入然後再一次清空的時候將CLASS加回去
        memberGroup.classList.add('hidden')
        memberGroup.innerHTML = ''
      }
    }
    // 找到符合規則的user
    function findMatches(wordToMatch,users) {
      return cleanParams(users).filter(place => {
        // here we need to figure out if the city or state matches what was searched
        const regex = new RegExp(wordToMatch, 'g')
        if (place.nickname) {
          return place.nickname.match(regex) || place.email.match(regex)
        }
      });
    }
    //只有當前的workspace的人才可以被顯示出來
    function cleanParams(users) {
      return users.filter((e)=>e.workspace_ids.find((e) => e == workspaceId[0]))
    }
  }
})
