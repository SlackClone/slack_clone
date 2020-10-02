import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"

export default class extends Controller {
  static targets = ["messages", "newMessage"]

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
    $('.centered').attr('class', 'w-full px-3 mb-2')
    $('.ck-editor').attr('class', 'flex flex-col-reverse flex-grow')
    $('.ck-editor__editable').attr('name', 'message[content]')
    // $('.ck-toolbar__items').addClass("relative")
    $('.ck-toolbar__items').append('<i class="fas fa-paper-plane ck ck-button " type="button"></i>')
    console.log($('.ck-toolbar__items')[0])
    
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
   clearMsg(){
     this.newMessageTarget.reset()
    }
  }
  



