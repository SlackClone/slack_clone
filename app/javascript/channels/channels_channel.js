import consumer from "./consumer"

consumer.subscriptions.create("ChannelsChannel", {
  connected() {
  },
  
  disconnected() {
  },
  
  received(data) {
    // console.log(data)
    const messageContainer = document.querySelector('.messages')
    messageContainer.innerHTML = messageContainer.innerHTML + data.message
  }
});
