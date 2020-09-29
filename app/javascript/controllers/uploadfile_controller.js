import { Controller } from "stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "newForm", "messageable" ]
  
  connect(){
    $('.file-share').on("change", () => {
      let s= $("#message_messageable_id").val();
      let e = $(`[value="${s}"]`)
      this.messageableTarget.value = e.attr("channel_type")
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
}
