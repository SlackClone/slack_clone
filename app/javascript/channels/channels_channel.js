import consumer from "./consumer"

consumer.subscriptions.create("ChannelsChannel", {
  connected() {
    console.log(123)
  },
  
  disconnected() {
  },
  
  received(data) {
    console.log(data)
    const messageContainer = document.querySelector('.messages')
    messageContainer.innerHTML = messageContainer.innerHTML + data.message
  }
});
