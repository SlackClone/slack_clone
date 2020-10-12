// hello_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "check", "output", "error" ]

  input(e) {
    const btn = document.querySelector('.create-ws-btn')
    this.outputTarget.textContent = e.target.value
    this.checkTarget.textContent = 255 - e.target.value.length
    if (e.target.value) {
      btn.removeAttribute('disabled')
      btn.classList.remove('bg-gray-500')
      btn.classList.add('bg-deep_sladock')
    } else {
      btn.setAttribute('disabled','')
      btn.classList.remove('bg-deep_sladock')
      btn.classList.add('bg-gray-500')
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