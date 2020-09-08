window.addEventListener('turbolinks:load', function(){
  // const url = ''
  const users = [];
  fetch('http://localhost:3000//api/v1/users_workspaces.json')
  .then(blob => blob.json())
  .then(data => users.push(...data));
  const sgggg = document.querySelector('.sgggg')
  //點選按鈕後會顯示DIV
  document.querySelector('.invite-ws-btn').addEventListener('click', function(){
    document.querySelector('.add-people').classList.remove('hidden');
  })
  //點選按鈕後會顯示XX會取消DIV
  document.querySelector('.invite-cancel-btn').addEventListener('click', function(){
    document.querySelector('.add-people').classList.add('hidden');
  })
  //INPUT事件
  const searchInput = document.querySelector('.search')
  searchInput.addEventListener('input',displayMatches)
  function displayMatches() {
    const matchArray = findMatches(this.value,users);
    const html = matchArray.map(place => {
      const regex = new RegExp(this.value, 'gi');
      const account = place.email.replace(regex, `<span class="hl">${this.value}</span>`);
      return `
        <li>
          <span class="name">${account}</span>
        </li>
      `;
    }).join('');
    if (searchInput.value) {
    sgggg.innerHTML = html;
  } else {
    sgggg.innerHTML = ''
  }
  }

  function findMatches(wordToMatch,users) {
    return users.filter(place => {
      // here we need to figure out if the city or state matches what was searched
      const regex = new RegExp(wordToMatch, 'gi');
      return place.email.match(regex)
     
    });
    
  }
  
})


// const endpoint = 'https://gist.githubusercontent.com/Miserlou/c5cd8364bf9b2420bb29/raw/2bf258763cdddd704f8ffd3ea9a3e81d25e2c6f6/cities.json';

// const cities = [];
// fetch(endpoint)
//   .then(blob => blob.json())
//   .then(data => cities.push(...data));

// function findMatches(wordToMatch, cities) {
//   return cities.filter(place => {
//     // here we need to figure out if the city or state matches what was searched
//     const regex = new RegExp(wordToMatch, 'gi');
//     return place.city.match(regex) || place.state.match(regex)
//   });
// }

// function numberWithCommas(x) {
//   return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
// }

// function displayMatches() {
//   const matchArray = findMatches(this.value, cities);
//   const html = matchArray.map(place => {
//     const regex = new RegExp(this.value, 'gi');
//     const cityName = place.city.replace(regex, `<span class="hl">${this.value}</span>`);
//     const stateName = place.state.replace(regex, `<span class="hl">${this.value}</span>`);
//     return `
//       <li>
//         <span class="name">${cityName}, ${stateName}</span>
//         <span class="population">${numberWithCommas(place.population)}</span>
//       </li>
//     `;
//   }).join('');
//   suggestions.innerHTML = html;
// }

// const searchInput = document.querySelector('.search');
// const suggestions = document.querySelector('.suggestions');

// searchInput.addEventListener('change', displayMatches);
// searchInput.addEventListener('keyup', displayMatches);
