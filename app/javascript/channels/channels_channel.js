import consumer from "./consumer"
document.addEventListener('turbolinks:load', ()=>{
  consumer.subscriptions.create("ChannelsChannel", {
    connected() {
      console.log(`connected to channel ${chatroomId}`)
    },
  
    disconnected() {
    },
  
    received(data) {
      console.log(data.message)
    }
  });
})
