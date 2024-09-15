import 'package:BalanceTracker/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:BalanceTracker/UI//account/account.dart';
import 'package:BalanceTracker/UI//currency/currency_select.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:excel/excel.dart' as excel;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:BalanceTracker/constants/constant.dart';

class orther extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onLogout;
  const orther({
    super.key,
    required this.metadata,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    final srcWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context)!;
    return Column(children: [
      Container(
          height: srcHeight / 12,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFDFE6DD), Color(0xFFFFFFFF)],
              stops: [0.05, 1],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Center(
            child: Text(
              l10n.other,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xFF62C42A),
                decoration: TextDecoration.none,
              ),
            ),
          )),
      Expanded(
          child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white.withOpacity(0.7),
        child: Column(
          children: [
            _buildMenuItem(context, l10n.reportByCategory, Icons.menu, () {}),
            _buildMenuItem(context, l10n.account, Icons.account_circle, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountPage(metadata: metadata, onLogout: onLogout)),
              );
            }),
            _buildMenuItem(context, l10n.language, Icons.language, () {
              _showLanguageDialog(context,
                  Provider.of<LanguageProvider>(context, listen: false));
            }),
            _buildMenuItem(
                context, l10n.currencyUnit, Icons.currency_exchange_rounded,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CurrencySelectorScreen()),
              );
            }),
            _buildMenuItem(context, l10n.exportToExcel, Icons.file_download,
                () {
              exportToExcel(context);
            }),
          ],
        ),
      )),
    ]);
  }

  Widget _buildMenuItem(
      BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey.withOpacity(0.3),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Text(text)),
                Icon(
                  icon,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, LanguageProvider languageProvider) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageListTile(
                    l10n.english,
                    'en',
                    languageProvider,
                    setState,
                  ),
                  _buildLanguageListTile(
                    l10n.vietnamese,
                    'vi',
                    languageProvider,
                    setState,
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.apply),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.languageChanged)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageListTile(String title, String languageCode,
      LanguageProvider languageProvider, StateSetter setState) {
    final isSelected =
        languageProvider.currentLocale.languageCode == languageCode;
    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(title),
        onTap: () {},
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    // TODO: Implement language change logic
    // This might involve updating a global state or calling a method from a language management service
    print('Changing language to: $languageCode');
    // After changing the language, you might need to rebuild the entire app
    // to reflect the changes. This depends on your localization implementation.
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final url = Uri.parse('${GetConstant().apiEndPoint}/transaction');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': metadata['_id'],
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['metadata'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error occurred while fetching transactions');
    }
  }

  Future<void> exportToExcel(BuildContext context) async {
    try {
      final transactions = await getTransactions();

      var excelFile = excel.Excel.createExcel();
      excel.Sheet sheetObject = excelFile['Transactions'];

      // Add headers
      sheetObject
          .appendRow(['Date', 'Category', 'Amount', 'Type', 'Description']);

      // Add data
      for (var transaction in transactions) {
        sheetObject.appendRow([
          transaction['transaction_date'],
          transaction['category']['category_name'],
          transaction['transaction_amount'].toString(),
          transaction['transaction_type'],
          transaction['transaction_description'],
        ]);
      }

      // Save file
      var fileBytes = excelFile.save();
      var directory = await getApplicationDocumentsDirectory();
      File(('${directory.path}/transactions.xlsx'))
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Excel file exported successfully')),
      );
    } catch (e) {
      print('Error exporting to Excel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to export Excel file')),
      );
    }
  }
}
