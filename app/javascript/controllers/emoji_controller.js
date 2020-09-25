import { Controller } from 'stimulus'
import { EmojiButton } from '@joeattardi/emoji-button'

export default class extends Controller {
  static targets = ['reaction']
  
  click (event){
    const target = event.currentTarget
    const picker = new EmojiButton()
    picker.togglePicker(target)
    picker.on('emoji', selection => {
      console.log('selected')
      console.log('selection')
      // 怎麼顯示 emoji
      this.reactionTarget.innerHTML = selection.emoji
      // 打 server api 來 toggle emoji
    })
  }
}