
import Cropper from 'cropperjs';
export default function cropper(){
  
}
window.addEventListener('DOMContentLoaded',function(){
  let CROPPER
  const input = document.getElementById('avatar')
  input.addEventListener('change',function(eve){
    //讀取上傳文件
    let reader = new FileReader();
    if(eve.target.files[0]){
      //readAsDataURL方法可以將File對象轉化為data:URL格式的字符串（base64編碼）
      reader.readAsDataURL(eve.target.files[0]);
      reader.onload = (e)=>{
        let dataURL = reader.result;
        //將img的src改為剛上傳的文件的轉換格式
        document.getElementById('output').src = dataURL;
        const image = document.getElementById('output'); 
      //創建cropper實例-----------------------------------------
        CROPPER = new Cropper(image, {
          aspectRatio: 16 / 16,
          viewMode:0,
          minContainerWidth:300,
          minContainerHeight:300,
          dragMode:'move',
          modal:false,
          viewMode:1,
          zoomOnWheel:false,
          movable:false,
          preview:[ document.querySelector('.previewBox')],
          crop(event){
            let data = JSON.stringify(event.detail)
            document.querySelectorAll('.detail').forEach((e)=>{
              e.value = data
            })
          }
        })
      }
    }
  })
  document.querySelector('.avatar-update-btn2').addEventListener('click',()=>{
    setTimeout(()=>{
      CROPPER.destroy()
    },2000)
  })
  document.querySelectorAll('.profile-cancel-btn').forEach((e)=>{
    e.addEventListener('click',()=>{
      if (CROPPER){
        CROPPER.destroy()
      }
    })
  })
})

