import 'package:flutter/material.dart';
import 'package:BalanceTracker/utils/currency_symbol.dart';
import 'package:BalanceTracker/utils/currency_settings.dart';

class CurrencySelectorScreen extends StatefulWidget {
  const CurrencySelectorScreen({super.key});

  @override
  _CurrencySelectorScreenState createState() => _CurrencySelectorScreenState();
}

class _CurrencySelectorScreenState extends State<CurrencySelectorScreen> {
  String? _selectedCurrency = 'VND'; // Mặc định là VND
  String? _currencySymbol = '₫'; // Mặc định là VND

  @override
  void initState() {
    super.initState();
    _loadCurrencySetting(); // Tải cài đặt đơn vị tiền tệ khi khởi động
  }

  // Tải cài đặt đơn vị tiền tệ từ SharedPreferences
  void _loadCurrencySetting() async {
    String? savedCurrency = await CurrencySettings.getCurrencyUnit();
    if (savedCurrency != null) {
      setState(() {
        _selectedCurrency = savedCurrency;
        _currencySymbol = CurrencySymbol.getSymbol(savedCurrency);
      });
    }
  }

  // Lưu đơn vị tiền tệ khi người dùng chọn
  void _onCurrencyChanged(String? newCurrency) {
    setState(() {
      _selectedCurrency = newCurrency;
      _currencySymbol = CurrencySymbol.getSymbol(newCurrency!);
    });
    CurrencySettings.saveCurrencyUnit(newCurrency!); // Lưu cài đặt
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn đơn vị tiền tệ')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<String>(
              value: _selectedCurrency,
              items: <String>['VND', 'USD', 'EUR', 'GBP'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged:
                  _onCurrencyChanged, // Khi người dùng thay đổi đơn vị tiền tệ
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Ký hiệu tiền tệ: $_currencySymbol',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
