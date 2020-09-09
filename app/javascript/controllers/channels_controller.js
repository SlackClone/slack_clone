import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'symbol' ]
  
  addChannel(){
    let element = this.symbolTarget
    element.textContent = "-"
    element.setAttribute("data-action", "click->channels#removeChannel")
    element.setAttribute("data-method", "delete")
  }
  removeChannel(){
    let element = this.symbolTarget
    element.textContent = "+"
    element.setAttribute("data-action", "click->channels#addChannel")
    element.setAttribute("data-method", "post")
  }
}
