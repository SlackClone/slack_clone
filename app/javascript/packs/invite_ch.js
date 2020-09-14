window.addEventListener('DOMContentLoaded', () => {
  if (document.querySelector('.invite-ch-btn')) {
    //索取workspaceId
    const workspaceId = window.location.href.match(/[\/\d\/]/).index
    const url = `/api/v1/users_workspaces.json?workspace=${workspaceId}`
    const inviteBtn = document.querySelector('.invite-ch-btn')
    const users = []
    fetch(url)
      .then(blob => blob.json())
      .then(data => users.push(...data))
    const data = document.querySelector('.search-data')
    //點選按鈕後會顯示DIV
    inviteBtn.addEventListener('click', () => {
      document.querySelector('.ch-background').classList.remove('hidden')
    })
    //點選按鈕後會顯示XX會取消DIV
    document.querySelector('.invite-cancel-btn').addEventListener('click', () => {
      document.querySelector('.ch-background').classList.add('hidden')
    })
    //INPUT事件
    const searchInput = document.querySelector('.search')
    searchInput.addEventListener('input',displayMatches)
    //顯示出符合規則的值並innerHTML
    function displayMatches() {
      const matchArray = findMatches(this.value,users)
      const html = matchArray.map(place => {
      const nickname = place.nickname
      return `
        <div class="bg-gray-200 flex justify-between items-center px-3">
          <p class="name font-bold"><span class="hl">${nickname}</span></p>
          <span class="text-xs text-gray-600">Already in this channel</span>
        </div> `
      }).join('')
      
      //如果INPUT的值不為空而且html不為空的時候顯示data
      if (searchInput.value && html !== '') {
        data.classList.remove('hidden')
        data.innerHTML = html
        //如果INPUT的值符合EMAIL格式的話顯示data並將submit按鈕enabled並更換樣式
      } else if (searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/)) {
        data.classList.add('hidden')
        inviteBtn.removeAttribute('disabled')
        inviteBtn.value = 'Add'
        inviteBtn.classList.add('bg-blue-500','text-white')
        inviteBtn.addEventListener('click', () => {
          document.querySelector('.ch-background').classList.add('hidden')
        })
        //如果INPUT的值不符合EMAIL格式的話顯示data而且HTML為空的時候隱藏data且顯示找不到的SPAN
      } else if (!searchInput.value.match(/^[^@\s]+@[^@\s]+\.[^@\s]+$/) && html == '') {
        data.classList.remove('hidden')
        data.innerHTML = `<span>No one found matching ${searchInput.value}</span>`
      } else {
        //輸入然後再一次清空的時候將CLASS加回去
        data.classList.add('hidden')
        data.innerHTML = ''
        inviteBtn.classList.remove('bg-blue-500','text-white')
        inviteBtn.value = 'Done'
        inviteBtn.setAttribute('disabled','')
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
      return users.filter((e)=>e.workspace_ids.find((e) => e == workspaceId))
    }
  }
})
