const fs = require('fs');
const path = require('path');

const folder = path.join(__dirname, 'data', 'products');
const ids = fs.readdirSync(folder)
  .filter(f => f.endsWith('.json') && f !== 'index.json')
  .map(f => path.parse(f).name); // strip .json

fs.writeFileSync(path.join(folder, 'index.json'), JSON.stringify(ids, null, 2));
console.log('✅ generated data/products/index.json');