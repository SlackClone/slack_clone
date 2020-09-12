import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["messages", "newMessage"]

  connect() {
    Notification.requestPermission()
    this.subscription = consumer.subscriptions.create({ channel: "ChannelsChannel", id: this.data.get("channel"), workspaceId: this.data.get("id")},
      {
        connected: this.subscribe.bind(this),
        disconnect: this.unsubscribe.bind(this),
        received: this.messaging.bind(this)
      })
    }
  disconnect(){
    consumer.subscriptions.remove(this.subscription)
  }
  subscribe(){
    console.log(`You are in workspace NO.${this.data.get("id")}`)
  }
  unsubscribe(){

  }
  messaging(data){
    console.log(data)
    if(document.hidden){
      this.messagesTarget.insertAdjacentHTML('beforeend', `<div class='flex text-right'><span class='h-0 border-b-0 border-t-2 block w-full border-red-600 my-auto'></span><span class="pl-3">new</span></div>`)
      if (Notification.permission == "granted"){
        const title = `New message in ${data.from}`
        const body = `a message from ${data.user}`
        new Notification(title, {body: body})
      }
    }
    if (data.message){
      this.messagesTarget.insertAdjacentHTML("beforeend", data.message)
    }
  }
  clearMsg(){
    this.newMessageTarget.reset()
  }
}
