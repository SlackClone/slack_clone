window.addEventListener('DOMContentLoaded', () => {

    const inviteBtn = document.querySelector('.invite-ch-btn')
    const inviteSubmitBtn = document.querySelector('.invite-btn')
    const background = document.querySelector('.ch-background')
    const workspaceId = inviteBtn.dataset.id
    const channelId = inviteBtn.dataset.channelid
    const url = `/workspaces/${workspaceId}/channels/${channelId}.json`
    const users = []
    fetch(url)
      .then(blob => blob.json())
      .then(data => users.push(...data))
    const data = document.querySelector('.search-data')
    
    //點選按鈕後會顯示DIV
    inviteBtn.addEventListener('click', () => {
      background.classList.remove('hidden')
    })
    //點選按鈕後會顯示XX會取消DIV
    document.querySelector('.invite-cancel-btn').addEventListener('click', () => {
      background.classList.add('hidden')
    })
    background.addEventListener('click', (e) => {
      if (e.target === background)
      background.classList.add('hidden')
    })
    //INPUT事件
    const searchInput = document.querySelector('.search')
    searchInput.addEventListener('input',displayMatches)
    //顯示出符合規則的值並innerHTML
    function displayMatches() {
      const matchArray = findMatches(this.value,users)
      const html = matchArray.map(place => {
      const nickname = place["0"]
      return `
        <a href="/channels/${channelId}/users_channels" onclick="" class="bg-gray-200 flex justify-between items-center px-3">${nickname}
        </a> `
      }).join('')
      const match = matchArray.map(place =>place["0"])
      // `
      //   <div class="bg-gray-200 flex justify-between items-center px-3">
      //     <p class="name font-bold"><span class="hl">${nickname}</span></p>
      //     <span class="text-xs text-gray-600">Already in this channel</span>
      //   </div> `
      //如果INPUT的值不為空而且html不為空的時候顯示data
      if (html !== '' && match.find(e=>e ===searchInput.value) ) {
        data.classList.remove('hidden')
        data.innerHTML = html
        inviteSubmitBtn.value = 'Add'
        inviteSubmitBtn.removeAttribute('disabled')
        inviteSubmitBtn.classList.add('bg-blue-500','text-white')
        inviteSubmitBtn.addEventListener('click', () => {
          background.classList.add('hidden')
        })
        //如果INPUT的值不符合EMAIL格式的話顯示data而且HTML為空的時候隱藏data且顯示找不到的SPAN
      } else if (searchInput.value && html == '') {
        data.classList.remove('hidden')
        data.innerHTML = `<span>No one found matching ${searchInput.value}</span>`
      } else if (searchInput.value && html !== '') {
        data.classList.remove('hidden')
        data.innerHTML = html
      } else {
        //輸入然後再一次清空的時候將CLASS加回去
        data.classList.add('hidden')
        data.innerHTML = ''
        inviteSubmitBtn.classList.remove('bg-blue-500','text-white')
        inviteSubmitBtn.value = 'Done'
        inviteSubmitBtn.setAttribute('disabled','')
      }
    }
    // 找到符合規則的user
    function findMatches(wordToMatch,users) {
      return users.filter(place => {
        // here we need to figure out if the city or state matches what was searched
        const regex = new RegExp(wordToMatch, 'g')
        if( place["0"]) {
          return place["0"].match(regex)
        }
      });
    }
})
    // function channelParams(users) {
    //   console.log(users)
    //   return users.filter((e)=>e.channels.find((e)=> e.id == channelId))
    // }