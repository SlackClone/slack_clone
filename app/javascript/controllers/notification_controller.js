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
    const channelTitle = `New message in ${data.channel_id}`
    const directMsgTitle = `New message from ${data.user}`
    const body = `a message from ${data.user}`
    const channelId = data.channel_id
    const directMsgId = data.direct_msg_id
    const userNow = this.data.get("user")
    console.log(typeof directMsgId)
    console.log(typeof channelId)
    if (userNow === data.user || userNow === data.from){
      return
    }else{
      if (typeof directMsgId === "undefined"){
        new Notification(channelTitle, {body: body})
      }else if (typeof channelId === "undefined"){
        new Notification(directMsgTitle)
      }
    }
  }
}
