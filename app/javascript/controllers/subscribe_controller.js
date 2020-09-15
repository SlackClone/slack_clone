import { Controller } from "stimulus"
import consumer from "channels/consumer"

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
    console.log(`You are in workspace NO.${this.data.get("id")}`)
  }
  messaging(data){
    if(document.hidden){
      let divideElement = document.querySelector(".divide")
      if (!divideElement){
        this.messagesTarget.insertAdjacentHTML('beforeend', `<div class='flex text-right divide'><span class='h-0 border-b-0 border-t-2 block w-full border-red-600 my-auto'></span><span class="pl-3">new</span></div>`)
      }
    }else{
      this.subscription.perform("update_enter_time")
    }
    this.messagesTarget.insertAdjacentHTML("beforeend", data.message)
  }
  clearMsg(){
    console.log("clear")
    this.newMessageTarget.reset()
  }
}