import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import ClassicEditor from "ckeditor5-custom-build/build/ckeditor.js"
import { EmojiButton } from '@joeattardi/emoji-button'

export default class extends Controller {
  static targets = ["messages", "newMessage", "threads", "threadcount", "msglist"]

  connect() {
    // Notification.requestPermission()
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

    if ($('#new_message .text-area').length === 1) {return} 
    editor()    // create ckeditor

    if ($('#new_thread').length ===1){
      if ($('#new_thread .text-area').length === 1) {return} 
      threadeditor()
    }
    // console.log(`Messaging channel opened in workspace NO.${this.data.get("id")}`)

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
  }
  
  messaging(data){
    if (data.emoji === undefined){
      if (data.thread_or_not){
        // 留言回覆串

        // 新增留言
        this.threadsTarget.insertAdjacentHTML("beforeend", data.message)
        // 留言串總則數更新(右側)
        let threadCount = this.threadsTarget.childElementCount
        this.threadcountTarget.innerHTML = `有 ${ threadCount } 則回覆`
        // 留言串總則數更新(左側)
        let messageId = this.threadcountTarget.getAttribute("message_id")
        let threadOriginMsg = document.querySelector(`.messages_child[message_id="${messageId}"] .thread-count`)
        threadOriginMsg.innerHTML = `<a class="border-solid border-2 border-blue-600 rounded-md px-1 -ml-2">有 ${ threadCount } 則回覆</a>`
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
    $('.text-area').remove()
    $('.editor').remove()
    $('.file-upload').val("")
    $('#new_message .w-full.px-3.mb-2').append(`<textarea class="editor" placeholder="輸入訊息" style="display: none;"></textarea>`)
    editor()
  }
  clearThreadMsg(){
    $('.thread-text-area').remove()
    $('.thread-editor').remove()
    $('#new_thread .w-full.px-3.mb-2').append(`<textarea class="thread-editor" placeholder="輸入訊息" style="display: none;"></textarea>`)
    threadeditor()
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
        'bulletedList',
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
        'bulletedList',
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
    licenseKey: '',
    
  } )
  .then( editor2 => {
    window.editor2 = editor2;
    threadCustomEditor()
    // findRecord()
  } )

  .catch( error => {
    console.error( 'Oops, something went wrong!' );
  } );
}

function customEditor(){
  // 調整ckeditor格式
  
  // 塞預覽檔案的地方
  $('#new_message .ck-editor__main').append(`<div id="pre-file-zone"></div>`)

  $('#new_message .centered').attr('class', 'w-full px-3 mb-2 thread')
  $('#new_message .ck-editor').attr('class', 'flex flex-col-reverse text-area')
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
      let textarea = $('.ck-editor__editable')    //要塞emoji的地方

      // 假如輸入框是空的時候，直接把emoji放進去
      if (textarea.text() == ""){
        textarea.children().html(emoji)  
      // 已經有其他文字的狀況
      }else {
        // 如果input為element起始點(例如換行的起始點)
        if(inputPosition === 0){
          focusElement.innerHTML = emoji
        }else {
          // 其他狀況要把emoji跟原有字串做拼接
          let textParent = focusParent.innerHTML
          // string是要插入的emoji，index是要插入的位置
          String.prototype.emojiInsert = function(index, string){
            return this.slice(0, index) + string + this.slice(index)
          }
          // textParent為插入emoji後的新字串
          textParent = textParent.emojiInsert(inputPosition, emoji)
          focusParent.innerHTML = textParent
        }
      }
      // 尋找最後一個子元素
      // while(textarea.children().length !== 0){
      //   lastChild = textarea.children().last()
      //   textarea = lastChild
      // }
      // textarea[0].innerHTML += emoji
    })
  })

  $('#new_message .custom_attach').click( (e) => {
    e.preventDefault()
    $('.file-upload').trigger('click')
  })

  $('#new_message .custom_send').click( (e) => {
    e.preventDefault()
    if ($('.ck-editor__editable').text() === "" && $('#new_message .file-upload').val() === ""){return}
    $('.message-content').val($('.ck-editor__editable').html()) 
    $('.message-submit').trigger('click')
  })

  // 為了監聽使用者用滑鼠改變輸入位置時紀錄游標位置
  $('#new_message .ck-editor__editable').mouseup( (e) => {
    focusElement = window.getSelection().focusNode
    window.focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset
  })
  // 為了監聽使用者使用方向鍵移動輸入位置時紀錄游標位置
  $('#new_message .ck-editor__editable').keyup( (e) => {
    focusElement = window.getSelection().focusNode
    focusParent = window.getSelection().focusNode.parentElement
    inputPosition = window.getSelection().focusOffset

    // // p
    // if (e.keyCode == 13 && !e.shiftKey && ($('.ck-editor__editable').children()[0].tagName === 'P' || $('.ck-editor__editable').children()[0].tagName === 'BLOCKQUOTE')){
    //   $('.ck-editor__editable').children(':last-child')[0].remove()
    //   $('.message-content').val($('.ck-editor__editable').html()) 
    //   $('.message-submit').trigger('click')
    //   return
    // }
    // // blockquote
    // // 跟 li 有關的
    // if (e.keyCode == 13 && !e.shiftKey && $('.ck-editor__editable').children()[0].tagName !== "PRE"){
    //   $('.ck-editor__editable').children().find('li:last-child')[0].remove()
    //   $('.message-content').val($('.ck-editor__editable').html()) 
    //   $('.message-submit').trigger('click')
    //   return
    // }
    // if (e.shiftKey && ($('.ck-editor__editable').children()[0].tagName === "OL" || $('.ck-editor__editable').children()[0].tagName === "UL")){
    //   // e.preventDefault()
    //   // e.keyCode = 13
    //   // $('.ck-editor__editable').children(':first-child')[0].insertAdjacentHTML('afterend', `<br>`)
    //   // $('.ck-editor__editable').children(':first-child')[0].insertAdjacentHTML('beforeend', `<li><br data-cke-filler="true"></li>`)
    //   return
    // }
    // // plain text
    // if (e.keyCode == 13 && !e.shiftKey){
    //   $('.ck-editor__editable').children().find('br:last-child')[0].remove()
    //   $('.message-content').val($('.ck-editor__editable').html()) 
    //   $('.message-submit').trigger('click')
    //   return
    // }
  })
}

function threadCustomEditor(){
  // 調整ckeditor格式
  
  $('#new_thread .centered').attr('class', 'w-full px-3 mb-2')
  $('#new_thread .ck-editor').attr('class', 'flex flex-col-reverse thread-text-area')
  $('#new_thread .ck-tooltip__text').attr('class', 'hidden')
  // 避免一直生成
  
  $('#new_thread .ck-toolbar__items').addClass('ck-thread-editor')
  $('#new_thread .ck-toolbar_grouping > .ck-thread-editor').append('<div class="thread-ckeditor" style="margin-left: auto; "></div>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_emoji ck" style="margin-right: 12px;"></button>')
  $('#new_thread .thread-ckeditor > .thread_emoji').append('<i class="far fa-smile ck ck-icon"></i>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_attach ck" style="margin-right: 12px;" type="file"></button>')
  $('#new_thread .thread-ckeditor > .thread_attach').append('<i class="fas fa-paperclip ck ck-icon" type="file"></i>')
  $('#new_thread .thread-ckeditor').append('<button class="thread_send ck" style=" margin-right: 12px;" type="submit"></button>')
  $('#new_thread .thread-ckeditor > .thread_send').append('<i class="far fa-paper-plane ck ck-icon"></i>')
  
  $('.thread_emoji').click( (e) => {
    e.preventDefault()
  })

  $('.thread_attach').click( (e) => {
    e.preventDefault()
    $('.tfile-upload').trigger('click')
  })

  $('.thread_send').click( (e) => {
    e.preventDefault()
    $('.thread-content').val($('#new_thread .ck-editor__editable').html()) 
    $('.thread-submit').trigger('click')
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

  
