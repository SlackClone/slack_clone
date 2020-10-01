import { Controller } from "stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "uploadForm", "messageable" ]
  
  connect(){
    $('.file-upload').on("change", () => {
      let channelId= $("#message_messageable_id").val()
      let optionElement = $(`[value="${channelId}"]`)
      this.messageableTarget.value = optionElement.attr("channel_type")
    })

    $('.file-share').on("change", () => {
      let channelId= $("#message_messageable_id").val()
      let optionElement = $(`[value="${channelId}"]`)
      this.messageableTarget.value = optionElement.attr("channel_type")
    })
  }

  submitForm(){
    this.uploadFormTarget.classList.add("hidden")
    this.uploadFormTarget.childNodes[1].reset()
  }

  closeForm(){
    this.uploadFormTarget.classList.add("hidden")
    this.uploadFormTarget.childNodes[1].reset()
  }

  newFormShowUp(){
    this.uploadFormTarget.classList.remove("hidden")
    this.uploadFormTarget.childNodes[1].classList.remove("file-share")
    this.uploadFormTarget.childNodes[1].classList.add("file-upload")

    let workspaceId = $('.file_area').attr("workspace_id")

    $('.file-upload').attr("action", "/workspaces/"+workspaceId+"/uploadedfiles")
    $('.file-upload').find("input[name='message[attachfiles_attributes][0][document]']").attr("class", "")
  }

  shareFormShowUp(e){
    e.preventDefault()
    this.uploadFormTarget.classList.remove("hidden")
    this.uploadFormTarget.childNodes[1].classList.remove("file-upload")
    this.uploadFormTarget.childNodes[1].classList.add("file-share")
    let fileId = e.currentTarget.getAttribute("file_id")
    let workspaceId = $('.file_area').attr("workspace_id")
    $('.file-share').find("input[name='message[attachfiles_attributes][0][document]']").attr("class", "hidden")
    $('.file-share').attr("action", "/workspaces/"+workspaceId+"/uploadedfiles/"+fileId+"/share")
  }
}