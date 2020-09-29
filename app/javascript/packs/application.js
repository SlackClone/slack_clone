// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
// require("turbolinks").start()         
require("@rails/activestorage").start()
require("channels")
// require("stylesheets")
import "./invite_ws.js"
import "./info.js"
import "tailwindcss/base";
import "tailwindcss/components";
import "tailwindcss/utilities";
import "stylesheets"
import "controllers"
import './select2.js'
import './create_ch.js'

import './header-btn'
import "./share-btn"
import './header-btn'
import ClassicEditor from 'ckeditor5-custom-build/build/ckeditor.js'
// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

ClassicEditor
			.create( document.querySelector( '.editor' ), {	
				toolbar: {
					items: [
						'bold',
						'underline',
						'italic',
						'strikethrough',
						'code',
						'link',
						'bulletedList',
						'numberedList',
						'blockQuote',
						'codeBlock',
						'|',
						'CKFinder',
						'undo',
						'redo',
						'|'
					]
				},
				language: 'en',
				image: {
					toolbar: [
						'imageTextAlternative',
						'imageStyle:full',
						'imageStyle:side'
					]
				},
				licenseKey: '',
				
			} )
			.then( editor => {
				window.editor = editor;
	
			} )
			.catch( error => {
				console.error( 'Oops, something went wrong!' );
				console.error( 'Please, report the following error on https://github.com/ckeditor/ckeditor5/issues with the build id and the error stack trace:' );
				console.warn( 'Build id: 4ozor8y2k6gc-3tl4u0tlpo5k' );
				console.error( error );
			} );