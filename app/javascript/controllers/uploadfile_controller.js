import { Controller } from "stimulus"
// import Rails from "@rails/ujs";
// const event = new CustomEvent("new-file-click")
// window.dispatchEvent(event)
export default class extends Controller {
  static targets = [ "newForm" ]
  
  connect(){
    console.log("upload ready!")
    // console.log(this.newFileBtnTarget)
  }

  newFormShowUp(){
    console.log(this.newFormTarget) 
    this.newFormTarget.classList.remove("hidden")
  }
  submitForm(){
    this.newFormTarget.classList.add("hidden")
  }

  closeForm(){
    this.newFormTarget.classList.add("hidden")
  }
  // addChannel(){
  //   let element = this.symbolTarget
  //   let channel_id = this.element.getAttribute("data-channels-id")
  //   Rails.ajax({
  //     url: `/channels/${channel_id}/users_channels`,
  //     type: 'post',
  //     success: () => {
  //       element.textContent = "-"
  //       element.setAttribute("data-action", "click->channels#removeChannel")
  //       element.setAttribute("data-method", "delete")
  //     },
  //     error: (err) => {
  //       console.log(err);
  //     }
  //   })
  // }
  // removeChannel(){
  //   let element = this.symbolTarget
  //   let channel_id = this.element.getAttribute("data-channels-id")
  //   Rails.ajax({
  //     url: `/channels/${channel_id}/users_channels`,
  //     type: 'delete',
  //     success: () => {
  //       element.textContent = "+"
  //       element.setAttribute("data-action", "click->channels#addChannel")
  //       element.setAttribute("data-method", "post")
  //     },
  //     error: (err) => {
  //       console.log(err);
  //     }
  //   })
  // }
}
