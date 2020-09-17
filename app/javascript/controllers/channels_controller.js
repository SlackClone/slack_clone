import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ 'symbol' ]

  addChannel(){
    let element = this.symbolTarget
    let channel_id = this.element.getAttribute("data-channels-id")
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels`,
      type: 'post',
      success: () => {
        element.textContent = "-"
        element.setAttribute("data-action", "click->channels#removeChannel")
        element.setAttribute("data-method", "delete")
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
  removeChannel(){
    let element = this.symbolTarget
    let channel_id = this.element.getAttribute("data-channels-id")
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels`,
      type: 'delete',
      success: () => {
        element.textContent = "+"
        element.setAttribute("data-action", "click->channels#addChannel")
        element.setAttribute("data-method", "post")
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
}
