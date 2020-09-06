import consumer from "./consumer"
document.addEventListener('turbolinks:load', ()=>{
  const element = document.querySelector(".chatroomName")
  const chatroomId = element.getAttribute("id")
  consumer.subscriptions.create("ChannelsChannel", {
    connected() {
      console.log(`connected to channel ${chatroomId}`)
    },
  
    disconnected() {
    },
  
    received(data) {
      // console.log(data)
      const messageContainer = document.querySelector('.messages')
      messageContainer.innerHTML = messageContainer.innerHTML + data.message
    }
  });
})
