
let searchBar = document.querySelector('.search-toggle')
let searchContent = document.querySelector('.search-content')

searchBar.addEventListener('click',function{
  searchContent.classList.remove('hidden')
})