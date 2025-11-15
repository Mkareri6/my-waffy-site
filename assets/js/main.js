// Load every product JSON file and expose them as a global variable
async function loadAllProducts() {
  const idxResp = await fetch('data/products/index.json');
  const ids = await idxResp.json();                // ["c001","c002",...]
  const promises = ids.map(id =>
    fetch(`data/products/${id}.json`).then(r => r.json())
  );
  return Promise.all(promises);
}

// Render a product grid (used on home and condition page)
function renderProducts(list) {
  const container = document.getElementById('product-grid');
  if (!container) return;
  container.innerHTML = list.map(p => `
    <div class="hover-box product-card">
      <img src="${p.image}" alt="${p.alt}">
      <h3>${p.name}</h3>
      <div class="price">$${p.price}</div>
      <div class="border-bottom-left"></div>
    </div>`).join('');
}

// Filter by health condition (condition‑filter page)
function filterByCondition(cond) {
  const filtered = window.allProducts.filter(p => p.condition?.includes(cond));
  renderProducts(filtered);
}

// Initialise on page load
document.addEventListener('DOMContentLoaded', async () => {
  const products = await loadAllProducts();
  window.allProducts = products;
  renderProducts(products);

  // Hook up the condition buttons (if present)
  document.querySelectorAll('.condition-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      filterByCondition(btn.dataset.condition);
    });
  });
});
