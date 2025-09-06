double toUnitPrice(num price, num sizeValue, String sizeUnit) {
  // normalize to per kg or per L or per 100g:
  final u = sizeUnit.toLowerCase();
  if (u == 'kg') return price / sizeValue; // ₱/kg
  if (u == 'g') return price / (sizeValue / 1000); // ₱/kg
  if (u == 'l') return price / sizeValue; // ₱/L
  if (u == 'ml') return price / (sizeValue / 1000); // ₱/L
  // fallback: per pack
  return price.toDouble();
}
