import $ from 'jquery';
window.jQuery = $
window.$ = $



$(document).ready(function () {
  $('.share-btn').click(function (event) {
    event.preventDefault();
    $('.popup').show();
  });
  $('.cancel').click(function (event) {
    event.preventDefault();
    $('.popup').hide();
  });

});



document.querySelectorAll('.share-btn').forEach((e)=>{
  e.addEventListener('click', function (e) {
    console.log(e.target.parentNode)
    let shareContent = e.target.parentNode.querySelector('.content').textContent
    let selectMessage = document.querySelector('.select-message')
    let input = document.getElementById('message_id')
    input.value = this.dataset.id
    selectMessage.textContent = shareContent
  })
})
