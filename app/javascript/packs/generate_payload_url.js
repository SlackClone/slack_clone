window.addEventListener('DOMContentLoaded',()=>{
  if(document.querySelector('#webhook_record_channel_id')){
    // TODO: 正式環境要更改 baseURL 網址
    let baseURL = 'https://staging.sladock.tw/webhook/channels'
    let select = document.querySelector('#webhook_record_channel_id')
    let payloadURL = document.querySelector('#webhook_record_payload_url')
    let generateSecret = document.querySelector('#generate_secret')

    // pick first option by css selector
    let firstChannel = document.querySelector('#webhook_record_channel_id option')
    let secret = document.querySelector('#webhook_record_secret')
        
    payloadURL.value=`${baseURL}/${firstChannel.value}/github`
    // secret.value = makeRandomSecret(20)

    // generateSecret.addEventListener('click', (e)=> {
    //   e.preventDefault()
    //   secret.value = makeRandomSecret(20)
    // })

    select.addEventListener('change',(e)=>{
      channelID  = e.target.value
      payloadURL.value=`${baseURL}/${channelID}/github`
    })

  }

//   function makeRandomSecret(length) {
//     var result           = '';
//     var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
//     var charactersLength = characters.length;
//     for ( var i = 0; i < length; i++ ) {
//        result += characters.charAt(Math.floor(Math.random() * charactersLength));
//     }
//     return result;
//  }
})