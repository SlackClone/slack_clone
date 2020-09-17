import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["count"]

  connect() {
    this.subscription = consumer.subscriptions.create({channel: "UnreadChannel", workspaceId: this.data.get("workspace")},
        {
          connected: this.subscribe.bind(this),       
          disconnected: this.unsubscribe.bind(this),
          received: this.unreadCounting.bind(this)
        }
      )
    }
  disconnect(){
    consumer.subscriptions.remove(this.subscription)
  }
  subscribe(){
    console.log("Unread message watching")
  }
  unsubscribe(){
  }
  unreadCounting(data){
    const recipientElement = document.querySelector(`[unread-id="${data.user}"]`)
    // 判斷是否為接收方，是的話才做未讀訊息數目的廣播
    if (!!recipientElement){
      // 若一開始為空字串，直接指定為1
      if (recipientElement.innerHTML == ""){
        recipientElement.classList.add("text-red-300")
        recipientElement.innerHTML = 1 
      }else{
        recipientElement.innerHTML = parseInt(recipientElement.innerHTML) + 1
      }
    }
  }
}
