import { Controller } from 'stimulus'
import { EmojiButton } from '@joeattardi/emoji-button'

export default class extends Controller {
  static targets = ['reaction']
  
  click (event){
    const target = event.currentTarget
    const picker = new EmojiButton({
      autoHide: true,
      showCategoryButtons: false	
      

    })
    picker.togglePicker(target)
    picker.on('emoji', selection => {
      console.log('selected')
      console.log('selection')
      // 怎麼顯示 emoji
      this.reactionTarget.innerHTML = selection.emoji

      // let emoji = e.target.textContent
      // let id = e.target.dataset.id
    
      // Rails.ajax({
      //   url: `messages/${id}/emoji`,
      //   type: 'post',
      //   data: {
      //     emoji: emoji,
      //     id: id
      //   },
      //     success: () => {
      //     element.setAttribute("data-action", "click-> emoji#click")   
      //   },
      //   error: (err) => {
      //     console.log(err);
      //   }
      // })

    })
  }
}