// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()         
require("@rails/activestorage").start()
require("channels")
require("stylesheets")
import "./invite_ws.js"
import "./info.js"
import "tailwindcss/base";
import "tailwindcss/components";
import "tailwindcss/utilities";
import "stylesheets"
import "controllers"
import './select2.js'
import './create_ch.js'
import $ from 'jquery';
window.jQuery = $
window.$ = $



$(document).ready(function () {
  $('.clickopen').click(function (event) {
    $('.open').slideToggle();
    event.stopPropagation();
   })
   $('.open').click(function(event){
    event.stopPropagation();
    });
  $('html').click(function(e) {
    if(e.target != $('.open')){
    $('.open').slideUp();
    }
  })
});

$('.upload-btn').click(()=>{
  $('#upload-input').trigger('click')
})

import "./share-btn"

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

