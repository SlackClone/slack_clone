window.addEventListener('turbolinks:load', function(){
  //索取workspaceId
  const workspaceId = window.location.href.match(/\d*$/)
  const url = `http://localhost:3000//api/v1/users_workspaces.json?workspace=${workspaceId[0]}`
  const users = [];
  fetch(url)
  .then(blob => blob.json())
  .then(data => users.push(...data));
  const memberGroup = document.querySelector('.member-group')
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
  //顯示出符合規則的值並innerHTML
  function displayMatches() {
    const matchArray = findMatches(this.value,users);
    const html = matchArray.map(place => {
      const regex = new RegExp(this.value, 'g');
      const account = place.nickname.replace(regex, `<span class="hl">${this.value}</span>`);
      return `
        <div class="bg-gray-300">
          <span class="name">${account}</span>
        </div> `;
    }).join('');
    //如果INPUT的值為空的時候清空所有的東西
    if (searchInput.value) {
      memberGroup.innerHTML = html;
    } else {
      memberGroup.innerHTML = ''
    }
  }
  // 找到符合規則的user
  function findMatches(wordToMatch,users) {
    return cleanParams(users).filter(place => {
      // here we need to figure out if the city or state matches what was searched
      const regex = new RegExp(wordToMatch, 'g');
      if (place.nickname) {
        return place.nickname.match(regex)
      }
    });
  }
  //只有當前的workspace的人才可以被顯示出來
  function cleanParams(users) {
    return users.filter((e)=> e.workspace_ids == workspaceId[0])
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
