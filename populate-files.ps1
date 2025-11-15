# --------------------------------------------------------------
# populate-files.ps1 – writes the real content into every file
# --------------------------------------------------------------
$projRoot = (Get-Location).Path   # assumes you are already in C:\Users\mosma\my-waffy-site

# ----------------------------------------------------------------
# Helper: write a multi‑line string to a file (UTF‑8, no BOM)
# ----------------------------------------------------------------
function Write-File ($path, $content) {
    $fullPath = Join-Path $projRoot $path
    $content | Set-Content -Encoding UTF8 -NoNewline $fullPath
    Write-Host "✓ $path"
}

# ----------------------------------------------------------------
# 1️⃣ admin folder (CMS UI)
# ----------------------------------------------------------------
Write-File "admin\index.html" @"
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Waffy‑Demo Admin</title>
  <script src="https://unpkg.com/netlify-cms@^2.10.0/dist/netlify-cms.js"></script>
  <link href="https://unpkg.com/netlify-cms@^2.10.0/dist/netlify-cms.css" rel="stylesheet">
</head>
<body>
  <script src="config.yml"></script>
</body>
</html>
"@

Write-File "admin\config.yml" @"
backend:
  name: git-gateway
  branch: main

media_folder: "assets/img/uploads"
public_folder: "/assets/img/uploads"

collections:
  - name: "products"
    label: "Products"
    folder: "data/products"
    create: true
    slug: "{{slug}}"
    fields:
      - { label: "ID", name: "id", widget: "string", hint: "Unique short code (e.g. c001)" }
      - { label: "Name", name: "name", widget: "string" }
      - { label: "Price (USD)", name: "price", widget: "number", value_type: "int" }
      - { label: "Type", name: "type", widget: "select", options: ["spice","capsule"] }
      - { label: "Condition", name: "condition", widget: "list", hint: "e.g. Joint Health, Digestion" }
      - { label: "Tags", name: "tags", widget: "list", required: false }
      - { label: "Image", name: "image", widget: "image" }
      - { label: "Alt text", name: "alt", widget: "string" }
      - { label: "Description", name: "description", widget: "markdown" }
      - label: "Supplement Facts"
        name: "supplementFacts"
        widget: "object"
        required: false
        fields:
          - { label: "Serving Size", name: "servingSize", widget: "string" }
          - { label: "Servings Per Container", name: "servingsPerContainer", widget: "string" }
          - { label: "Curcumin (mg)", name: "curcumin", widget: "string", required: false }
          - { label: "Bioavailability", name: "bioavailability", widget: "string", required: false }
"@

# ----------------------------------------------------------------
# 2️⃣ assets/css/style.css
# ----------------------------------------------------------------
Write-File "assets\css\style.css" @"
:root {
  --primary:#FF7A00;        /* orange – top/right border, CTA */
  --primary-light:#FFB84D;  /* lighter orange – hover background */
  --accent:#C0392B;         /* red‑brown – bottom/left border */
  --dark-bg:#2C2C2C;        /* header/footer background */
  --light-bg:#F5F5F5;       /* page background */
  --text:#333333;           /* body copy */
  --anim-duration:.6s;    /* length of each side animation */
}

/* reset & basic typography */
*,
*::before,
*::after { box-sizing:border-box; margin:0; padding:0; }
body {
  font-family:'Poppins',system-ui,Arial,sans-serif;
  background:var(--light-bg);
  color:var(--text);
  line-height:1.6;
}
a { color:var(--primary); text-decoration:none; }
a:hover { text-decoration:underline; }

/* header – sticky */
header {
  position:fixed; top:0; left:0; right:0;
  background:transparent;
  padding:1rem 2rem;
  display:flex; justify-content:space-between; align-items:center;
  transition:background var(--anim-duration) ease;
  z-index:100;
}
header.solid { background:var(--dark-bg); }
header .logo { color:#fff; font-size:1.5rem; font-weight:700; }
header nav a { margin-left:1.5rem; color:#fff; }

/* hero */
.hero {
  position:relative;
  height:80vh;
  background:url('../img/hero.jpg') center/cover no-repeat;
  display:flex; align-items:center; justify-content:center;
  text-align:center; color:#fff;
}
.hero::after { content:""; position:absolute; inset:0; background:rgba(0,0,0,0.4); }
.hero .content { position:relative; z-index:1; }
.hero h1 { font-size:3rem; margin-bottom:.5rem; }
.hero .cta {
  display:inline-block;
  padding:.8rem 1.6rem;
  background:var(--primary);
  border-radius:4px;
  font-weight:600;
  transition:background var(--anim-duration) ease;
}
.hero .cta:hover { background:var(--primary-light); }

/* hover‑border animation */
.hover-box {
  position:relative;
  overflow:hidden;
  padding:1.2rem;
  background:#fff;
  border-radius:6px;
  transition:transform .2s ease;
}
.hover-box:hover { transform:translateY(-4px); }
.hover-box::before,
.hover-box::after,
.hover-box .border-bottom-left::before,
.hover-box .border-bottom-left::after {
  content:"";
  position:absolute;
  background:var(--primary);
}
.hover-box::before { top:0; left:0; width:0; height:2px; animation:draw-top var(--anim-duration) forwards; }
.hover-box::after { top:0; right:0; width:2px; height:0; animation:draw-right var(--anim-duration) forwards; animation-delay:var(--anim-duration); }
.hover-box .border-bottom-left::before,
.hover-box .border-bottom-left::after { background:var(--accent); }
.hover-box .border-bottom-left::before { bottom:0; right:0; width:0; height:2px; animation:draw-bottom var(--anim-duration) forwards; animation-delay:calc(2*var(--anim-duration)); }
.hover-box .border-bottom-left::after { bottom:0; left:0; width:2px; height:0; animation:draw-left var(--anim-duration) forwards; animation-delay:calc(3*var(--anim-duration)); }

@keyframes draw-top    { from{width:0;}    to{width:100%;} }
@keyframes draw-right  { from{height:0;}   to{height:100%;} }
@keyframes draw-bottom { from{width:0;}    to{width:100%;} }
@keyframes draw-left   { from{height:0;}   to{height:100%;} }

.grid {
  display:grid;
  grid-template-columns:repeat(auto-fit, minmax(220px,1fr));
  gap:1.5rem;
  padding:2rem;
}
.product-card img {
  width:100%; height:180px; object-fit:cover; border-radius:4px;
}
.product-card h3 { margin:.7rem 0 .3rem; font-size:1.1rem; }
.product-card .price { font-weight:600; color:var(--primary); }

footer {
  background:var(--dark-bg);
  color:#fff;
  padding:2rem;
  text-align:center;
}
footer a { color:#fff; }
"@

# ----------------------------------------------------------------
# 3️⃣ assets/js/main.js
# ----------------------------------------------------------------
Write-File "assets\js\main.js" @"
async function loadAllProducts() {
  const idxResp = await fetch('data/products/index.json');
  const ids = await idxResp.json();               // e.g. [\"c001\",\"c002\"]
  const promises = ids.map(id =>
    fetch(\`data/products/\${id}.json\`).then(r => r.json())
  );
  return Promise.all(promises);
}

function renderProducts(list) {
  const container = document.getElementById('product-grid');
  if (!container) return;
  container.innerHTML = list.map(p => \`
    <div class="hover-box product-card">
      <img src="\${p.image}" alt="\${p.alt}">
      <h3>\${p.name}</h3>
      <div class="price">$\${p.price}</div>
      <div class="border-bottom-left"></div>
    </div>\`).join('');
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
"@

# ----------------------------------------------------------------
# 4️⃣ root HTML pages
# ----------------------------------------------------------------
Write-File "index.html" @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Waffy – Herbs & Spices Store</title>
  <link rel="stylesheet" href="assets/css/style.css">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
  <header id="site-header">
    <div class="logo">Waffy</div>
    <nav>
      <a href="index.html">Home</a>
      <a href="condition-filter.html">Capsules by Condition</a>
      <a href="product-detail.html">Shop</a>
      <a href="/admin">Admin</a>
    </nav>
  </header>

  <section class="hero">
    <div class="content">
      <h1>Pure Herbs & Spices</h1>
      <p>Organic, hand‑picked, and now also in capsule form.</p>
      <a href="condition-filter.html" class="cta">Explore Capsules</a>
    </div>
  </section>

  <div class="promo-ribbons" style="background:#fff;padding:1rem;text-align:center;">
    <div style="margin:.5rem;">
      <strong>Herbs & Spices – Flat 10 % Off</strong> – use coupon: <code>spi18</code>
    </div>
    <div style="margin:.5rem;">
      <strong>The choice of chefs – 15 % off</strong> – use coupon: <code>spi18</code>
    </div>
    <div style="margin:.5rem;">
      <strong>All Organic Spices – 20 % off</strong> – use coupon: <code>spi18</code>
    </div>
  </div>

  <h2 style="text-align:center;margin-top:2rem;">Best Products</h2>
  <div id="product-grid" class="grid"></div>

  <footer>
    <p>© 2025 Waffy – Premium Herbs & Spices</p>
    <p><a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a></p>
  </footer>

  <script src="assets/js/main.js"></script>
  <script>
    // sticky‑header colour change
    window.addEventListener('scroll', () => {
      const hdr = document.getElementById('site-header');
      hdr.classList.toggle('solid', window.scrollY > 50);
    });
  </script>
</body>
</html>
"@

Write-File "condition-filter.html" @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Choose Capsules by Condition</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <header id="site-header">
    <div class="logo">Waffy</div>
    <nav>
      <a href="index.html">Home</a>
      <a href="condition-filter.html">Capsules by Condition</a>
      <a href="product-detail.html">Shop</a>
      <a href="/admin">Admin</a>
    </nav>
  </header>

  <main style="padding:2rem;">
    <h2>Select your health concern</h2>
    <div style="margin:1rem 0;">
      <button class="condition-btn" data-condition="Joint Health">Joint Health</button>
      <button class="condition-btn" data-condition="Digestive">Digestive</button>
      <button class="condition-btn" data-condition="Immune Support">Immune Support</button>
      <button class="condition-btn" data-condition="Stress Relief">Stress Relief</button>
    </div>

    <h3 style="margin-top:2rem;">Recommended Capsules</h3>
    <div id="product-grid" class="grid"></div>
  </main>

  <footer>
    <p>© 2025 Waffy – Premium Herbs & Spices</p>
  </footer>

  <script src="assets/js/main.js"></script>
  <script>
    window.addEventListener('scroll', () => {
      const hdr = document.getElementById('site-header');
      hdr.classList.toggle('solid', window.scrollY > 50);
    });
  </script>
</body>
</html>
"@

Write-File "product-detail.html" @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Product Detail</title>
  <link rel="stylesheet" href="assets/css/style.css">
</head>
<body>
  <header id="site-header">
    <div class="logo">Waffy</div>
    <nav>
      <a href="index.html">Home</a>
      <a href="condition-filter.html">Capsules</a>
      <a href="product-detail.html">Shop</a>
      <a href="/admin">Admin</a>
    </nav>
  </header>

  <main style="padding:2rem;">
    <h2>Product Detail Page</h2>
    <p>This page is a placeholder. You can extend it to read a query‑string id and render a single product from <code>window.allProducts</code> if you wish.</p>
  </main>

  <footer>
    <p>© 2025 Waffy – Premium Herbs & Spices</p>
  </footer>

  <script src="assets/js/main.js"></script>
  <script>
    window.addEventListener('scroll', () => {
      const hdr = document.getElementById('site-header');
      hdr.classList.toggle('solid', window.scrollY > 50);
    });
  </script>
</body>
</html>
"@

# ----------------------------------------------------------------
# 5️⃣ generate-index.js (the tiny build script)
# ----------------------------------------------------------------
Write-File "generate-index.js" @"
const fs = require('fs');
const path = require('path');

const folder = path.join(__dirname, 'data', 'products');
const ids = fs.readdirSync(folder)
  .filter(f => f.endsWith('.json') && f !== 'index.json')
  .map(f => path.parse(f).name); // strip .json

fs.writeFileSync(path.join(folder, 'index.json'), JSON.stringify(ids, null, 2));
console.log('✅ generated data/products/index.json');
"@

# ----------------------------------------------------------------
# 6️⃣ package.json (minimal – only the build script)
# ----------------------------------------------------------------
Write-File "package.json" @"
{
  "name": "waffy-demo-static",
  "version": "1.0.0",
  "description": "Static replica of the Waffy Shopify demo with Netlify CMS",
  "scripts": {
    "build": "node generate-index.js"
  },
  "author": "Your Name",
  "license": "MIT"
}
"@

# ----------------------------------------------------------------
# 7️⃣ README.md (optional – placeholder)
# ----------------------------------------------------------------
Write-File "README.md" @"
# Waffy‑Demo Static Site

A free, fully‑static replica of the Shopify **Waffy** demo that:

* uses the exact orange/red colour palette,
* has the same hover‑border animation,
* ships with **Netlify CMS** for product entry,
* includes a “capsules‑by‑condition” page,
* can be hosted for free on Netlify (and optionally use Cloudinary for images).

See the original instructions for deployment steps.
"@

# ----------------------------------------------------------------
# 8️⃣ Create a tiny placeholder hero image (1 × 1 pixel JPEG)
# ----------------------------------------------------------------
$heroPath = Join-Path $projRoot "assets\img\hero.jpg"
# Minimal JPEG header (so browsers accept it). This is only a placeholder – replace later.
[byte[]]$jpegHeader = 0xFF,0xD8,0xFF,0xE0,0x00,0x10,0x4A,0x46,0x49,0x46,0x00,0x01,0x01,0x00,0x00,0x01,0x00,0x01,0x00,0x00,0xFF,0xDB,0x00,0x43,0x00,0x28,0x1C,0x1E,0x23,0x1A,0x28,0x23,0x21,0x23,0x2D,0x2B,0x28,0x30,0x3C,0x64,0x41,0x3C,0x37,0x37,0x3C,0x7B,0x5E,0x62,0x4F,0x64,0x88,0x80,0x8D,0x89,0x85,0x80,0x86,0x94,0x9F,0xBB,0xA7,0x94,0x9E,0xE6,0xB9,0x94,0x86,0xA1,0xC3,0xC5,0xC9,0xC6,0xAA,0xE1,0xDE,0xF2,0xFE,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF
Set-Content -Path $heroPath -Value $jpegHeader -Encoding Byte
Write-Host "✓ placeholder hero.jpg created (replace it later with a real picture)"

# ----------------------------------------------------------------
# 9️⃣ Create two sample product JSONs (c001 & c002)
# ----------------------------------------------------------------
Write-File "data\products\c001.json" @"
{
  "id": "c001",
  "name": "Turmeric Capsules – 60 pcs",
  "price": 349,
  "type": "capsule",
  "condition": ["Joint Health","Inflammation"],
  "tags": ["turmeric","anti‑inflammatory"],
  "image": "assets/img/uploads/turmeric-capsule.webp",
  "alt": "Bottle of 60 turmeric capsules, orange powder spilling out",
  "description": "Premium organic turmeric powder in easy‑to‑swallow capsules. Supports healthy inflammation response.",
  "supplementFacts": {
    "servingSize": "1 capsule",
    "servingsPerContainer": "60",
    "curcumin": "500 mg",
    "bioavailability": "95 % with black‑pepper extract"
  }
}
"@

Write-File "data\products\c002.json" @"
{
  "id": "c002",
  "name": "Ashwagandha Capsules – 90 pcs",
  "price": 429,
  "type": "capsule",
  "condition": ["Stress Relief","Sleep"],
  "tags": ["ashwagandha","adaptogen"],
  "image": "assets/img/uploads/ashwagandha-capsule.webp",
  "alt": "Bottle of 90 ashwagandha capsules on a wooden table",
  "description": "Organic ashwagandha root extract in vegan capsules. Helps the body adapt to stress and improve sleep quality.",
  "supplementFacts": {
    "servingSize": "1 capsule",
    "servingsPerContainer": "90"
  }
}
"@

Write-Host "nAll files have been written. You can now run npm, commit, and push."
