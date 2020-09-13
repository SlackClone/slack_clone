import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = []

  connect() {
    this.subscription = consumer.subscriptions.create({channel: "NotificationChannel", id: this.data.get("id"), workspaceId: this.data.get("workspace")},
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
    const title = `New message in ${data.from}`
    const body = `a message from ${data.user}`
    const channelId = `${data.id}`
    const sharpSignal = document.getElementById(`${channelId}`)
    
    sharpSignal.classList.add("bg-red-400")
    
    if (Notification.permission =="granted"){
      new Notification(title, {body: body})
    }
  }
}
