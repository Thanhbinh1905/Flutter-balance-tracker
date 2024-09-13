class CurrencySymbol {
  static Map<String, String> currencySymbols = {
    'VND': '₫',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    // Thêm các ký hiệu khác nếu cần
  };

  static String getSymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? '';
  }
}
