const iconElement = document.querySelector('.weather-icon');
const tempElement = document.querySelector('.temperature-value p');
const descElement = document.querySelector('.temperature-description p');

// App data
const weather = {};
weather.temperature = {
  unit: 'celsius',
};

// Change to 'F' for Fahrenheit
var tempUnit = 'C';

const KELVIN = 273.15;
// Use your own key for the Weather, Get it here: https://openweathermap.org/
const key = 'eaf0bf95962bd42471d02500acc89aa1';

// Set Position function
setPosition();

function setPosition(position) {
  // Here you can change your position
  // You can use https://www.latlong.net/ to get it! (I use San Francisco as an example)
  let latitude = 36.675117;
  let longitude = 117.054005;

  getWeather(latitude, longitude);
}

// Get the Weather data
function getWeather(latitude, longitude) {
  let api = `https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${key}`;

  console.log(api);

  fetch(api)
    .then(function (response) {
      let data = response.json();
      return data;
    })
    .then(function (data) {
      let celsius = Math.floor(data.main.temp - KELVIN);
      weather.temperature.value =
        tempUnit == 'C' ? celsius : (celsius * 9) / 5 + 32;
      weather.description = data.weather[0].description;
      weather.iconId = data.weather[0].icon;
    })
    .then(function () {
      displayWeather();
    });
}

// Display Weather info
function displayWeather() {
  iconElement.innerHTML = `<img src="icons/Nord/${weather.iconId}.png"/>`;
  tempElement.innerHTML = `${weather.temperature.value}°<span class="darkfg">${tempUnit}</span>`;
  descElement.innerHTML = weather.description;
}
