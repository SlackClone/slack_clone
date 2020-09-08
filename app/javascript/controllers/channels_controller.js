import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "joined" ]
  connect() {
    // console.log("hi")
  }
  
  addChannel(){
    let channel_id = this.joinedTarget.getAttribute("data-channels-id")
    console.log(channel_id)
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels.json`,
      type: 'post',
      success: (result) => {
        let nextElement = this.joinedTarget.lastChild
        if (result["status"]){
          nextElement.textContent = "+"
          // return
        } else {
          nextElement.textContent = "-"
          nextElement.setAttribute("data-action", "click->channels#removeChannel")
          nextElement.setAttribute("data-method", "delete")
        }
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
  removeChannel(){
    let channel_id = this.joinedTarget.getAttribute("data-channels-id")
    console.log(channel_id)
    Rails.ajax({
      url: `/channels/${channel_id}/users_channels.json`,
      type: 'delete',
      success: (result) => {
        let nextElement = this.joinedTarget.lastChild
        if (result["status"]){
          nextElement.textContent = "+"
          nextElement.setAttribute("data-action", "click->channels#addChannel")
          nextElement.setAttribute("data-method", "post")
        } else {
          nextElement.textContent = "-"
          // return
        }
      },
      error: (err) => {
        console.log(err);
      }
    })
  }
}
