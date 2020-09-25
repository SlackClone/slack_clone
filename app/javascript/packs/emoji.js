window.addEventListener('DOMContentLoaded', () => {
  const emojiTable = document.querySelector('.emoji-picker')
  const msg = document.querySelector('.messages')
  var msgId 
  msg.addEventListener('click', function (e) {
    if (e.target.className == 'emoji-trigger') {
      msgId = e.target.parentElement.parentElement.dataset.id
      console.log(msgId)
    }
  })



  emojiTable.addEventListener('click', function (e) {
    if (e.target.className == 'emoji-picker__emoji') {
      let emoji = e.target.textContent 

      Rails.ajax({
        url: `/messages/emoji`,
        type: 'post',
        data: { emoji: emoji, msg: msgId}
          success: () => {

        },
        error: (err) => {
          console.log(err);
        }
      })

    }

  })
})


