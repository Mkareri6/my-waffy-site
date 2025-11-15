async function loadAllProducts() {
  const idxResp = await fetch('data/products/index.json');
  const ids = await idxResp.json();               // e.g. [\"c001\",\"c002\"]
  const promises = ids.map(id =>
    fetch(\data/products/\.json\).then(r => r.json())
  );
  return Promise.all(promises);
}

function renderProducts(list) {
  const container = document.getElementById('product-grid');
  if (!container) return;
  container.innerHTML = list.map(p => \
    <div class="hover-box product-card">
      <img src="\" alt="\">
      <h3>\</h3>
      <div class="price">$\</div>
      <div class="border-bottom-left"></div>
    </div>\).join('');
}

function filterByCondition(cond) {
  const filtered = window.allProducts.filter(p => p.condition?.includes(cond));
  renderProducts(filtered);
}

document.addEventListener('DOMContentLoaded', async () => {
  const products = await loadAllProducts();
  window.allProducts = products;
  renderProducts(products);

  const conditionButtons = document.querySelectorAll('.condition-btn');
  conditionButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const cond = btn.dataset.condition;
      filterByCondition(cond);
    });
  });
});