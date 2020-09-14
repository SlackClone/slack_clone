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
import "./invite_ch.js"
import "tailwindcss/base";
import "tailwindcss/components";
import "tailwindcss/utilities";
import "../stylesheets/Frontend/shared"
import $ from 'jquery';
window.jQuery = $
window.$ = $



$(document).ready(function () {
  $('.clickopen').click(function (event) {
    event.preventDefault();
    $('.open').slideToggle();
  });
});



import "./share-btn"

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)
import "controllers"
