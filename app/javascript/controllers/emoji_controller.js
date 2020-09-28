import { Controller } from 'stimulus'
import Rails from "@rails/ujs";
import { EmojiButton } from '@joeattardi/emoji-button'

export default class extends Controller {
  static targets = ['reaction']
  
  click (event){
    const target = event.currentTarget
    const id = target.dataset.id
    const picker = new EmojiButton({
      autoHide: true,
      showCategoryButtons: false	
    })
    picker.togglePicker(target)
    picker.on('emoji', selection => {
      console.log("selection", selection);
      const emoji = selection.emoji
      // this.reactionTarget.innerHTML = selection.emoji;

      let formData = new FormData()
      formData.append('emoji', emoji)
      Rails.ajax({
        url: `/messages/${id}/emoji`,
        type: 'post',
        data: formData
      })
    })
  }
}