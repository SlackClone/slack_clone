import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import ClassicEditor from "ckeditor5-custom-build/build/ckeditor.js"
window.$ = $
console.log('!!')
export default class extends Controller {
  static targets = ["messages", "newMessage" ]

  connect() {
    Notification.requestPermission()

    this.subscription = consumer.subscriptions.create({channel: "ChannelsChannel", channelId: this.data.get("channel"), directId: this.data.get("direct")},
      {
        connected: this.subscribe.bind(this),
        received: this.messaging.bind(this)
      })
  }

  disconnect(){
    consumer.subscriptions.remove(this.subscription)
  }

  subscribe(){
    customEditor()
    console.log(`Messaging channel opened in workspace NO.${this.data.get("id")}`)
  }
  
  messaging(data){
    if (data.emoji === undefined){
      if (document.hidden) {
        let divideElement = document.querySelector(".divide")
        if (!divideElement) {
          this.messagesTarget.insertAdjacentHTML('beforeend', `<div class='flex text-right divide'><span class='h-0 border-b-0 border-t-2 block flex-grow border-red-600 my-auto'></span><span class="pl-3">new</span></div>`)
        }
      } else {
        this.subscription.perform("update_enter_time")
      }
      this.messagesTarget.insertAdjacentHTML("beforeend", data.message)
      window.initShare()

      $('.text-area').remove()
      $('.editor').remove()
      $('.w-full.px-3.mb-2').append(`<textarea class="editor" placeholder="輸入訊息" style="display: none;"></textarea>`)
      editor()
    }else{
      // console.log(data.emoji)
      // console.log(data.html)
      console.log(data.id)
      let emoji = document.getElementById(`message-reaction-${data.id}`)
      // console.log(emoji)
      // emoji.insertAdjacentHTML('beforeend', data.html)
      // emoji.append(data.html)
      emoji.innerHTML = data.html
    }
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
  .then( editor => {
    window.editor = editor;
    customEditor()
  } )
  .catch( error => {
    console.error( 'Oops, something went wrong!' );
  } );
}

function customEditor(){
  // 調整ckeditor格式
  $('.centered').attr('class', 'w-full px-3 mb-2')
  $('.ck-editor').attr('class', 'flex flex-col-reverse text-area')
  
  $('.ck-toolbar_grouping >.ck-toolbar__items').append('<div class="custom-ckeditor" style="margin-left: auto; "></div>')
  $('.custom-ckeditor').append('<button class="custom_emoji ck" style="margin-right: 12px;"></button>')
  $('.custom_emoji').append('<i class="far fa-smile ck ck-icon"></i>')
  $('.custom-ckeditor').append('<button class="custom_attach ck" style="margin-right: 12px;" type="file"></button>')
  $('.custom_attach').append('<i class="fas fa-paperclip ck ck-icon" type="file"></i>')
  $('.custom-ckeditor').append('<button class="custom_send ck" style=" margin-right: 12px;" type="submit"></button>')
  $('.custom_send').append('<i class="far fa-paper-plane ck ck-icon"></i>')
  
  $('.custom_emoji').click( (e) => {
    e.preventDefault()
  })

  $('.custom_attach').click( (e) => {
    e.preventDefault()
    $('.file-upload').trigger('click')
  })

  $('.custom_send').click( (e) => {
    e.preventDefault()
    $('.message-content').val($('.ck-editor__editable').html()) 
    $('.message-submit').trigger('click')
  })

  $('.ck-editor__editable').keydown( (e) => {
    if (e.keyCode == 13 && $('.ck-editor__editable').children()[0].tagName === "P"){
      if (e.shiftKey){return}
      $('.ck-editor__editable').children().find(':last-child').remove()
      $('.message-content').val($('.ck-editor__editable').html()) 
      $('.message-submit').trigger('click')
    }
  })
}
