import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["channels"]
  connect() {
    this.show()
  }
  show() {
    // 開關右側
    const rightInfo = document.querySelector(".right_info")

    rightInfo.classList.toggle("hidden")  

    // 更改左邊 channel 網址
    const threadCount = document.getElementById("thread-count")
    const messageId = threadCount.getAttribute("message_id")
    const channelId = threadCount.getAttribute("channel_id")
    const allChannel = document.querySelectorAll(".channel-each")
    allChannel.forEach((a) => {
      a.setAttribute('href', `/channels/${ channelId }/messages/${ messageId }/threads`)
    });
    document.history.pushState('', '', `/channels/${ channelId }/messages/${ messageId }/threads`)
    
    // console.log(messageId)
    // console.log(channelId)
    // console.log(`/channels/${ channelId }/messages/${ messageId }/threads`)
    // this.channelsTarget.
    // getAttribute('href') = `/channels/${ channelId }/messages/${ messageId }/threads`

    console.log(this.channelsTarget.getAttribute('href'))

    

  }
}
