import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = []

  connect() {
    // 私訊頻道旁邊紀錄未讀訊息則數的span
    let directUnreadCount = document.querySelectorAll('span.count')
    // 開場先把有未讀訊息的解除隱藏
    directUnreadCount.forEach((item) => {
      if(item.innerHTML != ""){
        item.classList.remove("hidden")
      }
    })
    this.subscription = consumer.subscriptions.create({channel: "NotificationChannel", workspaceId: this.data.get("workspace")},
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
    const channelTitle = `New message in ${data.channel_name}`
    const directMsgTitle = `New message from ${data.user_nickname}`
    const body = `a message from ${data.user_nickname}`
    const channelId = data.channel_id
    const directMsgId = data.direct_msg_id
    const userNow = this.data.get("user")
    const channelName = document.querySelector(`[channel_id="${data.channel_id}"]`)
    const recipientElement = document.querySelector(`[unread-id="${data.user_id}"]`)

    if (userNow === data.user_nickname){
      return
    }else{
      if (typeof directMsgId === "undefined" && channelId != this.data.get("channel")){
        // 瀏覽器訊息通知
        new Notification(channelTitle, {body: body})
        // 聊天室群組字體提示
        channelName.classList.add("font-bold")
      }else if (typeof channelId === "undefined" && directMsgId != this.data.get("channel")){
        // 瀏覽器訊息通知
        new Notification(directMsgTitle)
        // 私聊未讀訊息則數顯示
        if (!!recipientElement){
          
          // 若一開始為空字串，直接指定為1
          if (recipientElement.innerHTML == ""){
            recipientElement.classList.remove("hidden")
            recipientElement.classList.add("text-red-600")
            recipientElement.innerHTML = 1 
          }else{
            recipientElement.innerHTML = parseInt(recipientElement.innerHTML) + 1
          }
        }
      }
    }
  }
}
