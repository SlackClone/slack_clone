window.addEventListener('DOMContentLoaded',function(){ 
  const records = JSON.parse(localStorage.getItem('drafts')) || []
  const btn = document.querySelector('.draft-btn')
  renderRecords(records)
  // 在進入channel or directmsg時先判斷input是不是有值，有的話就顯示草稿區
  if(localStorage.drafts && localStorage.drafts != "[]"){
    btn.classList.remove('hidden')
  } 
  if(document.querySelector('.centered')) {
    const msgForm = document.forms["new_message"]
    const chId = msgForm.dataset.cid
    const wsId = msgForm.dataset.wid
    const name = msgForm.dataset.name
    const locationUrl = window.location.href
    const ckText = document.querySelector('.centered')
    //監聽表單input有的話就將此訊息保留在localStorge
    ckText.addEventListener('keyup',()=>{
      const ckInput = document.querySelector('.ck-content')
      const date = new Date()
      const newDraft = {
        wid: wsId,
        cid: chId,
        name: name,
        category: categoryUrl(locationUrl),
        value: ckInput.textContent,
        time: `${date.getHours()}:${date.getMinutes()}`
      }
        // 更新localStorage
        updateRecords(newDraft)      
    })

    // 監聽所有物件的點擊事件，判斷input有值的話只要點擊其他地方，草稿區的BTN就會出現
    document.addEventListener('click',()=>{
      if(localStorage.drafts != "[]"){
        btn.classList.remove('hidden')
      } else {
        btn.classList.add('hidden')
      }
    })
    // 監聽submit，如果發送出去要將localStorage那一筆刪除
    msgForm.addEventListener('submit',function(){
      var submitItem = findRecord()
      let removeRecord = records.filter((e)=>{ return e.cid != submitItem.cid})
      localStorage.setItem('drafts',JSON.stringify(removeRecord))
    })
    // 找到符合在某channel或某directmsgs的那筆資料
    function findRecord(){
      return records.find((e)=> {return e.cid == chId})
    }
    // 更新findRecord
    function updateRecords(items){
      let entry = findRecord()
      // 如果那筆資料存在於 localStorage ，那就更新那筆資料的 value
      if (entry) {
        entry.value = document.querySelector('.ck-content').textContent
         // 如果那筆資料存在於 localStorage ，但value是空的就刪除那筆
        if(entry.value == ""){
          for(let i=0;i<records.length;i++){
            if (records[i] == entry){
              records.splice(i,1)
            }
          }
        } 
      } else {
        // 如果不存在，那就直接把這筆資料塞到陣列裡
        records.push(items)
      }
      // 最後更新 localStorage
      localStorage.setItem('drafts',JSON.stringify(records))
    }
  }
  // 將localStorage上的資料render到draft_show.html.erb
  function renderRecords(records) {
    if (document.querySelector('.draft-area')) {
      const area = document.querySelector('.draft-area')
      area.innerHTML = "";
      const children = records.map(val => createItem(val))
      children.forEach( function(child) {
        area.appendChild(child)
      })  
      count()
    }
  }
  function createItem(records) {
    const template = document.querySelector('#draft-group')
    const url = template.content.querySelector('a')
    const channelId = template.content.querySelector('p')
    const span = template.content.querySelectorAll('span')
    const box = template.content.querySelectorAll('.box')
    const edit = template.content.querySelectorAll('.draft-edit')
    const time = span[0]
    const content = template.content.querySelector('.content')
    url.href = identifyUrl(records)
    edit.forEach((e)=>{e.href= url.href })
    content.textContent = records.value
    channelId.textContent = `#${records.name}`
    box.forEach((e)=>{e.dataset.name = records.name})
    time.textContent = records.time
    return document.importNode(template.content,true)
  }

  function count(){
    const count = document.querySelector('.count-draft')
    const box = document.querySelectorAll('.box')
    if( box.length == 1){
      count.textContent = `${box.length} draft`
    } else if( box.length > 1 ) {
      count.textContent = `${box.length} drafts`
    }
  }

  function categoryUrl(url){
    const regex = new RegExp(/\d*\/channels\/\d*/)
    if(url.match(regex)){
      return url = "channels"
    } else {
      return url = "directmsgs"
    }
  }

  function identifyUrl({category, wid, cid }){
    if(category == "channels"){
      return `/workspaces/${wid}/channels/${cid}`
    } else {
      return `/workspaces/${wid}/directmsgs/${cid}`
    }
  }

  document.querySelectorAll('.draft-delete').forEach((e)=>{
    e.addEventListener('click',(e)=>{
      const box = e.currentTarget.parentNode.parentNode.parentNode
      let removeRecord = JSON.parse(localStorage.getItem('drafts')) || []
      removeRecord = removeRecord.filter((e)=> {return e.name != box.dataset.name })
      localStorage.setItem('drafts',JSON.stringify(removeRecord))
      box.classList.add('hidden')
    })
  })
  document.querySelector('.sign-out').addEventListener('click',()=>{
    localStorage.removeItem('drafts')
  })
})
