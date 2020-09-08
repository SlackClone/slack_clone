import consumer from "./consumer"
document.addEventListener('turbolinks:load', () => {
  const elementChannel = document.getElementById('channel-id')
  const chatroomId = elementChannel.getAttribute("date-channel-id")
  consumer.subscriptions.create({channel:"ChannelsChannel", channel_id:`${chatroomId}`}, {
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
