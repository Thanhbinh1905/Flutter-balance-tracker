import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BalanceTracker/utils/currency_symbol.dart';

class CurrencySettings {
  static const String _currencyKey = 'currency_unit';

  // Lưu mã tiền tệ vào SharedPreferences
  static Future<void> saveCurrencyUnit(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  // Lấy mã tiền tệ từ SharedPreferences
  static Future<String?> getCurrencyUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  // Xóa cài đặt đơn vị tiền tệ
  static Future<void> clearCurrencyUnit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currencyKey);
  }

  static Future<String> getCurrencySymbol() async {
    String? currency = await CurrencySettings.getCurrencyUnit();
    String symbol = CurrencySymbol.getSymbol(currency ?? 'USD');
    return symbol;
  }

  static Widget showCurrency() {
    return FutureBuilder<String>(
      future:
          CurrencySettings.getCurrencySymbol(), // Hàm để lấy ký hiệu tiền tệ
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Hiển thị ký hiệu tiền tệ sau khi dữ liệu đã sẵn sàng
          return Text(
            snapshot.data ?? '',
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          );
        }
      },
    );
  }
}
