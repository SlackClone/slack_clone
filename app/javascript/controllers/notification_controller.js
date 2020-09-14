import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = []

  connect() {
    this.subscription = consumer.subscriptions.create({channel: "NotificationChannel", channelId: this.data.get("channel"), workspaceId: this.data.get("workspace"), directId: this.data.get("direct")},
        {
          connected: this.subscribe.bind(this),       
          disconnected: this.unsubscribe.bind(this),
          received: this.notification.bind(this)
        }
      )
    }
  disconnect(){
    consumer.subscriptions.remove(this.subscription)
  }
  subscribe(){
    console.log("Notification On")
  }
  unsubscribe(){
  }
  notification(data){
    const channelTitle = `New message in ${data.from}`
    const directMsgTitle = `New message from ${data.from}`
    const body = `a message from ${data.user}`
    const channelId = `${data.channel_id}`
    const directMsgId = `${data.direct_msg_id}`
    const newMsgMark = document.getElementById(`${channelId}`)
    // sharpSignal.classList.add("bg-red-400")
    
    if (Notification.permission =="granted"){
      if (directMsgId === 'undefined'){
        console.log("someone?")
        new Notification(channelTitle, {body: body})
      }else if (channelId === 'undefined'){
        console.log("anyone?")
        new Notification(directMsgTitle)
      }
    }
  }
}
