if(document.querySelector('.menu')){
  const menuToggle = document.querySelector('.menu')
  const body = document.querySelector('body')
  const closeMenu = document.querySelector('.close')

  menuToggle.addEventListener('click', menuShow )
  closeMenu.addEventListener('click', menuShow)

  function menuShow () {
    body.classList.toggle('toggle')
  }

  function menuClose () {
    closeMenu.classList.remove('toggle')
    // body.classList.toggle('toggle')
  }
}