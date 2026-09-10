const days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
const months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];

const elements = {
  clock: document.querySelector("#clock"),
  hour: document.querySelector("#hour"),
  minute: document.querySelector("#minute"),
  second: document.querySelector("#second"),
  period: document.querySelector("#period"),
  day: document.querySelector("#day"),
  date: document.querySelector("#date"),
  month: document.querySelector("#month"),
  year: document.querySelector("#year"),
  formatButton: document.querySelector("#formatButton"),
  secondsButton: document.querySelector("#secondsButton"),
  scaleButton: document.querySelector("#scaleButton"),
  opacityButton: document.querySelector("#opacityButton"),
  themeButton: document.querySelector("#themeButton"),
};

const themes = [
  { name: "WHITE", value: "white" },
  { name: "WARM", value: "warm" },
  { name: "ICE", value: "ice" },
];
const scales = [0.8, 1, 1.25];
const opacities = [1, 0.8, 0.6];

const defaults = {
  use24Hour: true,
  showSeconds: true,
  themeIndex: 0,
  scaleIndex: 1,
  opacityIndex: 0,
};

function loadState() {
  try {
    return { ...defaults, ...JSON.parse(localStorage.getItem("minimalClockState")) };
  } catch {
    return { ...defaults };
  }
}

const state = loadState();

function saveState() {
  localStorage.setItem("minimalClockState", JSON.stringify(state));
}

function pad(value) {
  return String(value).padStart(2, "0");
}

function renderClock(now = new Date()) {
  let hour = now.getHours();
  let period = "";

  if (!state.use24Hour) {
    period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12 || 12;
  }

  elements.hour.textContent = state.use24Hour ? pad(hour) : String(hour);
  elements.minute.textContent = pad(now.getMinutes());
  elements.second.textContent = pad(now.getSeconds());
  elements.period.textContent = period;
  elements.period.hidden = state.use24Hour;
  elements.day.textContent = days[now.getDay()];
  elements.date.textContent = pad(now.getDate());
  elements.month.textContent = months[now.getMonth()];
  elements.year.textContent = now.getFullYear();
}

function renderState() {
  const theme = themes[state.themeIndex];
  const scale = scales[state.scaleIndex];
  const opacity = opacities[state.opacityIndex];

  document.body.dataset.theme = theme.value;
  document.documentElement.style.setProperty("--clock-scale", scale);
  document.documentElement.style.setProperty("--clock-opacity", opacity);
  elements.clock.classList.toggle("seconds-hidden", !state.showSeconds);

  elements.formatButton.textContent = state.use24Hour ? "24H" : "12H";
  elements.secondsButton.textContent = state.showSeconds ? "SECONDS ON" : "SECONDS OFF";
  elements.secondsButton.setAttribute("aria-pressed", String(state.showSeconds));
  elements.scaleButton.textContent = `${Math.round(scale * 100)}%`;
  elements.opacityButton.textContent = `${Math.round(opacity * 100)}%`;
  elements.themeButton.textContent = theme.name;

  renderClock();
}

function scheduleNextTick() {
  const delay = 1000 - (Date.now() % 1000) + 5;
  window.setTimeout(() => {
    renderClock();
    scheduleNextTick();
  }, delay);
}

function cycle(key, values) {
  state[key] = (state[key] + 1) % values.length;
  saveState();
  renderState();
}

elements.formatButton.addEventListener("click", () => {
  state.use24Hour = !state.use24Hour;
  saveState();
  renderState();
});

elements.secondsButton.addEventListener("click", () => {
  state.showSeconds = !state.showSeconds;
  saveState();
  renderState();
});

elements.scaleButton.addEventListener("click", () => cycle("scaleIndex", scales));
elements.opacityButton.addEventListener("click", () => cycle("opacityIndex", opacities));
elements.themeButton.addEventListener("click", () => cycle("themeIndex", themes));

renderState();
scheduleNextTick();
