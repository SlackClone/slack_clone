import { Controller } from "stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "newForm", "messageable" ]
  
  connect(){

    $('.file-share').on("change", () => {
      let channelId= $("#message_messageable_id").val();
      let optionElement = $(`[value="${channelId}"]`)
      this.messageableTarget.value = optionElement.attr("channel_type")
    })
  }
  newFormShowUp(){
    this.newFormTarget.classList.remove("hidden")
  }
  submitForm(){
    this.newFormTarget.classList.add("hidden")
  }
  closeForm(){
    this.newFormTarget.classList.add("hidden")
  }
  shareFormShowUp(e){
    e.preventDefault()
    this.newFormTarget.classList.remove("hidden")

    let fileId = e.currentTarget.getAttribute("file_id")
    let originalUrl = $('.file-share').attr("action")
    
    $('.file-share').attr("action", originalUrl+'/'+fileId)
  }
}