import 'cropperjs/dist/cropper.css';
import Cropper from 'cropperjs';
fetch("/users/profiles/avatar")
  .then(response => response.json())
  .then(({small,medium,large }) => {
  console.log(small)
  document.querySelectorAll('.avatar_small').forEach((e)=>{
    e.src = small
  })
  document.querySelectorAll('.origin_avatar').forEach((e)=>{
    e.src = small
  })
  document.querySelector('#avatar_large').src = large
})
// const image = document.getElementById('output'); 
document.querySelector('.cropper-wrap-box').innerHTML = ''
// let CROPPER = new Cropper(image, {
//   aspectRatio: 16 / 16,
//   viewMode:0,
//   minContainerWidth:300,
//   minContainerHeight:300,
//   dragMode:'move',
//   modal:false,
//   viewMode:1,
//   zoomOnWheel:false,
//   movable:false,
//   })
//   CROPPER.reset()
