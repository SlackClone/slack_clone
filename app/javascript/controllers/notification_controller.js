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
    
  }
  subscribe(){
    console.log("hi")
  }
  unsubscribe(){

  }
  notification(data){
    console.log("really?")
  }
}
