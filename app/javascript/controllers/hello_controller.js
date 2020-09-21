// hello_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "check", "output", "error" ]

  input(e) {
    this.outputTarget.textContent = e.target.value
    this.checkTarget.textContent = 255 - e.target.value.length
    console.log()
    if (e.target.value) {
      this.errorTarget.textContent = ''
      document.querySelector('.field_with_errors>input').style.borderColor = 'gray'
    }
  }
  
  check(e) {
    const input = e.target
    this.checkTarget.classList.remove('hidden')
    document.addEventListener('click',(e)=>{
      if(e.target != input)
      this.checkTarget.classList.add('hidden')
    })
  }
}