// GTU Main Website - main.js

// Font size control (A+, A, A-)
function changeFontSize(multiplier) {
  const base = 14;
  document.body.style.fontSize = (base * multiplier) + 'px';
}

// Auto-scroll news ticker
(function() {
  const ticker = document.querySelector('.news-ticker');
  if (!ticker) return;

  let scrollY = 0;
  const items = ticker.querySelectorAll('.news-item');
  let current = 0;

  setInterval(() => {
    current = (current + 1) % items.length;
    items[current].scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  }, 4000);
})();
