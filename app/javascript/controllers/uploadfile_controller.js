import { Controller } from "stimulus"
// import Rails from "@rails/ujs";
// const event = new CustomEvent("new-file-click")
// window.dispatchEvent(event)
export default class extends Controller {
  static targets = [ "newForm" ]
  
  connect(){
    console.log("upload ready!")
    console.log(this.newFormTarget)
  }

  newFormShowUp(){
    this.newFormTarget.classList.remove("hidden")
  }
  submitForm(){
    console.log("hidden")
    this.newFormTarget.classList.add("hidden")
  }

  closeForm(){
    this.newFormTarget.classList.add("hidden")
  }
}
