import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import ClassicEditor from "ckeditor5-custom-build/build/ckeditor.js"
import { EmojiButton } from '@joeattardi/emoji-button'

export default class extends Controller {
  static targets = ["messages", "threads", "threadcount", "msglist"]

  connect() {
    let msgThreadCount = document.querySelectorAll('span.children-count')
    msgThreadCount.forEach((item) => {
      if(item.innerHTML != 0){
        item.parentElement.classList.remove("hidden")
      }
    })
    this.subscription = consumer.subscriptions.create({channel: "ChannelsChannel", channelId: this.data.get("channel"), directId: this.data.get("direct"), messageId: this.data.get("thread")},
      {
        connected: this.subscribe.bind(this),
        received: this.messaging.bind(this)
      })
  }

  disconnect(){
    consumer.subscriptions.remove(this.subscription)
  }

  subscribe(){
    // 回傳目前游標指導的位置，focusNode則是該node，詳情去找Window.getSelection API
    window.focusElement = window.getSelection().focusNode
    // 回傳游標在Node的哪個位置
    window.inputPosition = window.getSelection().focusOffset
    // window.test = window.getSelection()
    if (window.location.pathname.includes("threads") && $('#new_thread .thread-text-area').length === 0){
      threadeditor()
    }
    if ($('#new_message .text-area').length === 0){
      editor()    // create ckeditor
    }
    $('.file-upload').change( (e) => {
      $('#new_message #pre-file-zone').empty()
      let reader = new FileReader();
      let targetFile = e.target.files[0]
      let fileName = targetFile.name
      let fileType = targetFile.type
      if (fileType.includes("image")){
        reader.readAsDataURL(targetFile);
        reader.onload = ()=>{
          let dataURL = reader.result;
          $('#new_message #pre-file-zone').append(`<img id="img-pre" width="120">`)
          document.querySelector('#new_message #img-pre').src = dataURL;
          $('#new_message #pre-file-zone').append(`<a src="#" id="pre-file-name">${fileName}</a>`)
        }
      }else {
        $('#new_message #pre-file-zone').append(`<a src="#" id="pre-file-name">${fileName}</a>`)
      }
    })

    $('.tfile-upload').change( (e) => {
      $('#new_thread #pre-thread-file-zone').empty()
      let reader = new FileReader();
      let targetFile = e.target.files[0]
      let fileName = targetFile.name
      let fileType = targetFile.type
      if (fileType.includes("image")){
        reader.readAsDataURL(targetFile);
        reader.onload = ()=>{
          let dataURL = reader.result;
          $('#new_thread #pre-thread-file-zone').append(`<img id="img-pre-thread" width="120">`)
          document.querySelector('#new_thread #img-pre-thread').src = dataURL;
          $('#new_thread #pre-thread-file-zone').append(`<a src="#" id="pre-thread-file-name">${fileName}</a>`)
        }
      }else {
        $('#new_message #pre-file-zone').append(`<a src="#" id="pre-file-name">${fileName}</a>`)
      }
    })
  }
  
  messaging(data){
    if (data.emoji === undefined){
      if (data.thread_or_not){
        // 留言回覆串
        let newthread = document.querySelector(`div[message-string="${data.ancestry_id}"]`)
        let messageAncestry = document.querySelector(`.messages_child[message_id="${data.ancestry_id}"] span.children-count`)

        // 新增留言
        if (!!newthread){
          newthread.insertAdjacentHTML("beforeend", data.message)
        }
        
        if (!!messageAncestry){
          if (messageAncestry.innerHTML == 0){
            messageAncestry.parentElement.classList.remove('hidden')
            messageAncestry.innerHTML = 1
          }else{
            messageAncestry.innerHTML = parseInt(messageAncestry.innerHTML) + 1
          }
        }
        let threadCount = this.threadsTarget.childElementCount    
        this.threadcountTarget.innerHTML = `有 ${ threadCount } 則回覆`
      } else {
        // 一般留言
        if(document.hidden){
          let divideElement = document.querySelector(".divide")
          if (!divideElement){
            this.messagesTarget.insertAdjacentHTML('beforeend', `<div class='flex text-right divide'><span class='h-0 border-b-0 border-t-2 block flex-grow border-red-600 my-auto'></span><span class="pl-3">new</span></div>`)
          }
        }else{
          this.subscription.perform("update_enter_time")
        }
        this.messagesTarget.insertAdjacentHTML("beforeend", data.message)
        window.initShare()
      }
    }else{
      let emoji = document.getElementById(`message-reaction-${data.id}`)
      emoji.innerHTML = data.html
    }
  }
  clearmsg(){
    clearMessage()
  }
  clearThreadMsg(){
    clearThreadMessage()
  }
}

function editor(){
  ClassicEditor
  .create( document.querySelector( '.editor' ), {	
    toolbar: {
      items: [
        'bold',
        'underline',
        'italic',
        'strikethrough',
        'code',
        'link',
        // 'bulletedList',
        'numberedList',
        'blockQuote',
        'codeBlock',
        '|',
        'undo',
        'redo',
      ]
    },
    language: 'en',
    image: {
      toolbar: [
        'imageTextAlternative',
        'imageStyle:full',
        'imageStyle:side'
      ]
    },
    mention: {
      feeds: [
          {
              marker: '@',
              feed: getWorkspaceUser,
              itemRenderer: customItemRenderer,
          },
      ]
  },
    licenseKey: '',
    
  } )
  .then( editor1 => {
    window.editor1 = editor1;
    customEditor()
    findRecord()
  } )

  .catch( error => {
    console.error( 'Oops, something went wrong!' );
  } );
}

function threadeditor(){
  ClassicEditor
  .create( document.querySelector( '.thread-editor' ), {	
    toolbar: {
      items: [
        'bold',
        'underline',
        'italic',
        'strikethrough',
        'code',
        'link',
        // 'bulletedList',
        'numberedList',
        // 'blockQuote',
        // 'codeBlock',
        // '|',
        // 'undo',
        // 'redo',
      ]
    },
    language: 'en',
    image: {
      toolbar: [
        'imageTextAlternative',
        'imageStyle:full',
        'imageStyle:side'
      ]
    },
    mention: {
      feeds: [
          {
              marker: '@',
              feed: getWorkspaceUser,
              itemRenderer: customItemRenderer,
          },
      ]
  },
    licenseKey: '',
  } )
  .then( editor2 => {
    window.editor2 = editor2;
    threadCustomEditor()
  } )

  .catch( error => {
    console.error( 'Oops, something went wrong!' );
  } );
}

function customEditor(){
  // 調整ckeditor格式
  
  // 塞預覽檔案的地方
  $('#new_message .ck-editor__main').append(`<div id="pre-file-zone"></div>`)

  $('#new_message .centered').attr('class', 'w-full px-3 mb-2')
  $('#new_message .ck-editor').attr('class', 'flex flex-col-reverse text-area border border-black rounded')
  $('#new_message .ck-tooltip__text').attr('class', 'hidden')
  // emoji 
  
  $('#new_message .ck-toolbar__items').addClass('ck-custom-editor')
  $('#new_message .ck-toolbar_grouping > .ck-custom-editor').append('<div class="custom-ckeditor" style="margin-left: auto; "></div>')
  $('#new_message .custom-ckeditor').append('<button class="custom_emoji ck" style="margin-right: 12px;"></button>')
  $('#new_message .custom-ckeditor > .custom_emoji').append('<i class="far fa-smile ck ck-icon"></i>')
  $('#new_message .custom-ckeditor').append('<button class="custom_attach ck" style="margin-right: 12px;" type="file"></button>')
  $('#new_message .custom-ckeditor > .custom_attach').append('<i class="fas fa-paperclip ck ck-icon" type="file"></i>')
  $('#new_message .custom-ckeditor').append('<button class="custom_send ck" style=" margin-right: 12px;" type="submit"></button>')
  $('#new_message .custom-ckeditor > .custom_send').append('<i class="far fa-paper-plane ck ck-icon"></i>')


  $('#new_message .custom_emoji').click( (e) => {
    e.preventDefault()

    const picker = new EmojiButton({
      autoHide: true,
      showCategoryButtons: false	
    })

    const target = e.currentTarget
    picker.togglePicker(target)
  
    picker.on('emoji', selection => {
      const emoji = selection.emoji
      let textarea = $('#new_message .ck-editor__editable')    //要塞emoji的地方
      // 假如輸入框是空的時候，直接把emoji放進去
      if (textarea.text() == ""){
        textarea.children().text(emoji)  
      // 已經有其他文字的狀況
      }else {
        // 如果input為element起始點(例如換行的起始點)
        if(inputPosition === 0 || $('#new_message .mention').length < 0){
          focusElement.textContent = emoji
        }else if($('#new_message .mention').length > 0) {
          let lastChild
          while(textarea.children().length !== 0){
            lastChild = textarea.children().last()
            textarea = lastChild
          }
          textarea.parent()[0].textContent += emoji
        }else {
          // 其他狀況要把emoji跟原有字串做拼接
          let textParent = focusParent.textContent
          // string是要插入的emoji，index是要插入的位置
          String.prototype.emojiInsert = function(index, string){
            return this.slice(0, index) + string + this.slice(index)
          }
          // textParent為插入emoji後的新字串
          textParent = textParent.emojiInsert(inputPosition, emoji)
          focusParent.innerHTML = textParent
        }
      }
    })
  })

  $('#new_message .custom_attach').click( (e) => {
    e.preventDefault()
    $('#new_message .file-upload').trigger('click')
  })

  $('.custom_send').click( (e) => {
    e.preventDefault()
    if ($('#new_message .ck-editor__editable').text() === "" && $('#new_message .file-upload').val() === ""){return}
    $('.message-content').val($('#new_message .ck-editor__editable').html()) 
    $('.message-submit').trigger('click')
  })

  // 為了監聽使用者用滑鼠改變輸入位置時紀錄游標位置
  $('#new_message .ck-editor__editable').mouseup( (e) => {
    focusElement = window.getSelection().focusNode
    window.focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset
    // console.log(focusElement)
    // console.log(inputPosition)
    // console.log(focusParent)

  })
  // 為了監聽使用者使用方向鍵移動輸入位置時紀錄游標位置
  $('#new_message .ck-editor__editable').keyup( (e) => {
    focusElement = window.getSelection().focusNode
    focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset

    let textarea = $('#new_message .ck-editor__editable')
    let lastChild
    while(textarea.children().length !== 0){
      lastChild = textarea.children().last()
      textarea = lastChild
    }

    if (!isMobileDevice()){
      let liTab = $('#new_message .ck-editor__editable li')
      let codeTab = $('#new_message .ck-editor__editable code')
      let preTab = $('#new_message .ck-editor__editable pre')
      let olTab = $('#new_message .ck-editor__editable ol')
      if (e.keyCode == 13 && !e.shiftKey && olTab.length == 0){

        if (liTab.length !== 0){
          liTab[liTab.length - 1].remove()
          console.log("li here")
          if ($('#new_message .ck-editor__editable').text() === "" && $('#new_message .file-upload').val() === ""){return}
          $('.message-content').val($('#new_message .ck-editor__editable').html()) 
          $('.message-submit').trigger('click')
          clearMessage()
          return
        }
  
        if (codeTab.length !== 0 && preTab.length == 0){
          codeTab[codeTab.length - 1].remove()
          if ($('#new_message .ck-editor__editable').text() === "" && $('#new_message .file-upload').val() === ""){return}
          $('.message-content').val($('#new_message .ck-editor__editable').html()) 
          $('.message-submit').trigger('click')
          clearMessage()
          return
        }
  
        textarea.remove()
        if ($('#new_message .ck-editor__editable').text() === "" && $('#new_message .file-upload').val() === ""){return}
        $('.message-content').val($('#new_message .ck-editor__editable').html())
        $('.message-submit').trigger('click')
        clearMessage()
        return
      }
  
      // if (e.shiftKey && e.keyCode == 13 && olTab.length !== 0){
      //   // $('#new_message [data-placeholder="輸入訊息"]').insertAdjacentHTML('beforeend',`<li><br data-cke-filler="true"></li>`)
      //   console.log(olTab[0])
      //   olTab[0].insertAdjacentHTML('beforeend',`<li></li>`)
      // }
    }
    
  })
}

function threadCustomEditor(){
  // 調整ckeditor格式
  
  $('#new_thread .ck-editor__main').append(`<div id="pre-thread-file-zone"></div>`)


  $('#new_thread .centered').attr('class', 'w-full px-3 mb-2')
  $('#new_thread .ck-editor').attr('class', 'flex flex-col-reverse thread-text-area border border-black rounded')
  $('#new_thread .ck-tooltip__text').attr('class', 'hidden')
  $('#new_thread .ck-toolbar_grouping').addClass('border rounded')
  // 避免一直生成
  
  $('#new_thread .ck-toolbar__items').addClass('ck-thread-editor')
  $('#new_thread .ck-toolbar_grouping > .ck-thread-editor').append('<div class="thread-ckeditor" style="margin-left: auto; "></div>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_emoji ck" style="margin-right: 12px;"></button>')
  $('#new_thread .thread-ckeditor > .thread_emoji').append('<i class="far fa-smile ck ck-icon"></i>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_attach ck" style="margin-right: 12px;" type="file"></button>')
  $('#new_thread .thread-ckeditor > .thread_attach').append('<i class="fas fa-paperclip ck ck-icon" type="file"></i>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_send ck" style=" margin-right: 12px;" type="submit"></button>')
  $('#new_thread .thread-ckeditor > .thread_send').append('<i class="far fa-paper-plane ck ck-icon"></i>')
  
  $('#new_thread .thread_emoji').click( (e) => {
    e.preventDefault()
    const picker = new EmojiButton({
      autoHide: true,
      showCategoryButtons: false	
    })

    const target = e.currentTarget
    picker.togglePicker(target)
  
    picker.on('emoji', selection => {
      const emoji = selection.emoji
      let textarea = $('#new_thread .ck-editor__editable')    //要塞emoji的地方

      // 假如輸入框是空的時候，直接把emoji放進去
      if (textarea.text() == ""){
        textarea.children().html(emoji)  
      // 已經有其他文字的狀況
      }else {
        // 如果input為element起始點(例如換行的起始點)
        if(inputPosition === 0 || $('#new_thread .mention').length < 0){
          focusElement.textContent = emoji
        }else if($('#new_thread .mention').length > 0 ){
          let lastChild
          while(textarea.children().length !== 0){
            lastChild = textarea.children().last()
            textarea = lastChild
          }
          textarea.parent()[0].textContent += emoji
        }else {
          // 其他狀況要把emoji跟原有字串做拼接
          let textParent = focusParent.textContent
          // string是要插入的emoji，index是要插入的位置
          String.prototype.emojiInsert = function(index, string){
            return this.slice(0, index) + string + this.slice(index)
          }
          // textParent為插入emoji後的新字串
          textParent = textParent.emojiInsert(inputPosition, emoji)
          focusParent.innerHTML = textParent
        }
      }
    })
  })

  $('#new_thread .thread_attach').click( (e) => {
    e.preventDefault()
    $('.tfile-upload').trigger('click')
  })

  $('#new_thread .thread_send').click( (e) => {
    e.preventDefault()
    if ($('#new_thread .ck-editor__editable').text() === "" && $('#new_thread .tfile-upload').val() === ""){return}
    $('.thread-content').val($('#new_thread .ck-editor__editable').html()) 
    $('.thread-submit').trigger('click')
  })

  // 為了監聽使用者用滑鼠改變輸入位置時紀錄游標位置
  $('#new_thread .ck-editor__editable').mouseup( (e) => {
    focusElement = window.getSelection().focusNode
    window.focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset
  })

  // 為了監聽使用者使用方向鍵移動輸入位置時紀錄游標位置
  $('#new_thread .ck-editor__editable').keyup( (e) => {
    focusElement = window.getSelection().focusNode
    focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset

    let threadTextArea = $('#new_thread .ck-editor__editable')
    let lastThreadChild
    while(threadTextArea.children().length !== 0){
      lastThreadChild = threadTextArea.children().last()
      threadTextArea = lastThreadChild
    }

    if (!isMobileDevice()){
      let liThreadTab = $('#new_thread .ck-editor__editable li')
      let codeThreadTab = $('#new_thread .ck-editor__editable code')
      let preThreadTab = $('#new_thread .ck-editor__editable pre')
      let olThreadTab = $('#new_thread .ck-editor__editable ol')
      if (e.keyCode == 13 && !e.shiftKey && olThreadTab.length == 0){

        if (liThreadTab.length !== 0){
          liThreadTab[liThreadTab.length - 1].remove()
          if ($('#new_thread .ck-editor__editable').text() === "" && $('#new_thread .file-upload').val() === ""){return}
          $('.thread-content').val($('#new_thread .ck-editor__editable').html()) 
          $('.thread-submit').trigger('click')
          clearThreadMessage()
          return
        }
  
        if (codeThreadTab.length !== 0 && preThreadTab.length == 0){
          codeThreadTab[codeThreadTab.length - 1].remove()
          if ($('#new_thread .ck-editor__editable').text() === "" && $('#new_thread .file-upload').val() === ""){return}
          $('.thread-content').val($('#new_thread .ck-editor__editable').html()) 
          $('.thread-submit').trigger('click')
          cclearThreadMessage()
          return
        }
  
        threadTextArea.remove()
        if ($('#new_thread .ck-editor__editable').text() === "" && $('#new_thread .tfile-upload').val() === ""){return}
        $('.thread-content').val($('#new_thread .ck-editor__editable').html())
        $('.thread-submit').trigger('click')
        clearThreadMessage()
        return
      }  
    }
  })
}
// 如果localStorage裡有東西的話就將value塞給表單的input，跳回來input原本的值不會不見   
function findRecord(){
  const records = JSON.parse(localStorage.getItem('drafts')) || []
  const msgForm = document.forms["new_message"]
  const chId = msgForm.dataset.cid
  const target = records.find((e)=> {return e.cid == chId})
  if (target) {
    document.querySelector('.ck-content').children[0].textContent = target.value
  }
}

  
function customItemRenderer( item ) {
    const itemElement = document.createElement( 'span' );
    // const avatar = document.createElement( 'img' );
    const userNameElement = document.createElement( 'span' );
    const fullNameElement = document.createElement( 'span' );

    itemElement.classList.add( 'mention__item' );

    // avatar.src = `../../assets/img/${ item.avatar }.jpg`;

    userNameElement.classList.add( 'mention__item__user-name' );
    userNameElement.textContent = item.id;

    fullNameElement.classList.add( 'mention__item__full-name' );
    fullNameElement.textContent = item.name;

    // itemElement.classList.add('flex justify-between')
    // itemElement.appendChild( avatar );
    itemElement.appendChild( userNameElement );
    itemElement.appendChild( fullNameElement );

    return itemElement;
}

const getWorkspaceUser = async () => {
  const workspaceId = $('h3.chatroomName').attr("workspace_id")
  const response = await fetch(`/workspaces/${workspaceId}/all_user.json`)
  const workspaceUser = await response.json()
  return workspaceUser
}

function clearMessage(){
  $('.text-area').remove()
  $('.editor').remove()
  $('.file-upload').val("")
  $('#new_message .w-full.px-3.mb-2').append(`<textarea class="editor" placeholder="輸入訊息" style="display: none;"></textarea>`)
  editor()
}

function clearThreadMessage(){
  $('.thread-text-area').remove()
  $('.thread-editor').remove()
  $('.tfile-upload').val("")
  $('#new_thread .w-full.px-3.mb-2').append(`<textarea class="thread-editor" placeholder="輸入訊息" style="display: none;"></textarea>`)
  threadeditor()
}

function isMobileDevice() {
  const mobileDevice = ['Android', 'webOS', 'iPhone', 'iPad', 'iPod', 'BlackBerry', 'Windows Phone']
  let isMobileDevice = mobileDevice.some(e => navigator.userAgent.match(e))
  return isMobileDevice
}