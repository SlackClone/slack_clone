import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ 'symbol' ]
  
  addChannel(){
    let channel_id = this.element.getAttribute("data-channels-id")
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels.json`,
      type: 'post',
      success: (result) => {
        let element = this.symbolTarget
        console.log(element)
        if (result["status"]){
          element.textContent = "+"
        } else {
          element.textContent = "-"
          element.setAttribute("data-action", "click->channels#removeChannel")
          element.setAttribute("data-method", "delete")
        }
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
  removeChannel(){
    let channel_id = this.element.getAttribute("data-channels-id")
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels.json`,
      type: 'delete',
      success: (result) => {
        let element = this.symbolTarget
        console.log(element)
        if (result["status"]){
          element.textContent = "+"
          element.setAttribute("data-action", "click->channels#addChannel")
          element.setAttribute("data-method", "post")
        } else {
          element.textContent = "-"
        }
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
}
