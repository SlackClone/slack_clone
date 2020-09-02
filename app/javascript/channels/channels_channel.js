import consumer from "./consumer"
document.addEventListener('turbolinks:load', ()=>{
  const element = document.querySelector(".chatroomName")
  const chatroomId = element.getAttribute("id")
  // console.log(chatroomId)
  consumer.subscriptions.create("ChannelsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log(`connected to channel ${chatroomId}`)
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data.message)
    }
  });
})
