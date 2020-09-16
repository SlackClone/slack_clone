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
    const channelId = this.data.get("channel")
    const directMsgId = this.data.get("direct")
    const userNow = this.data.get("user")
    console.log(directMsgId)
    console.log(channelId)
    if (userNow === data.user || userNow === data.from){
      return
    }else{
      if (directMsgId === "0"){
        new Notification(channelTitle, {body: body})
      }else if (channelId === "0"){
        new Notification(directMsgTitle)
      }else{
      }
    }
  }
}
