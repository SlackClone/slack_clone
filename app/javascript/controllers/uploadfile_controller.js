import { Controller } from "stimulus"
import $ from "jquery"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "newForm", "messageable", "shareForm" ]
  
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
    this.shareFormTarget.classList.add("hidden")
  }

  closeForm(){
    this.newFormTarget.classList.add("hidden")
    this.shareFormTarget.classList.add("hidden")
  }

  shareFormShowUp(e){
    let fileId = e.currentTarget.getAttribute("file_id")
    let workspaceId = $('.file_area').attr("workspace_id")
    e.preventDefault()
    this.shareFormTarget.classList.remove("hidden")
    console.log(this.shareFormTarget)
    // $('.file-share').find("textarea")[0].value  
    // $('.file-share')[0][3].value)
    // Rails.ajax({
    //   url: `/workspaces/${workspaceId}/uploadedfiles/${fileId}/share.json`,
    //   type: 'post',
    //   success: (result) => {
    //     console.log(result)
    //   },
    //   error: (fault) => {
    //     console.log(fault)
    //   }
      
    // })

  }
}