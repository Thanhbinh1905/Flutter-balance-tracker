import 'package:BalanceTracker/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:BalanceTracker/UI//account/account.dart';
import 'package:BalanceTracker/UI//currency/currency_select.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class orther extends StatelessWidget {
  final Map<String, dynamic> metadata;
  final VoidCallback onLogout;
  final VoidCallback onRefresh;
  const orther({
    super.key,
    required this.metadata,
    required this.onLogout,
    required this.onRefresh,
  });

  @override
  
  Widget build(BuildContext context) {
    final srcHeight = MediaQuery.of(context).size.height;
    final srcWidth = MediaQuery.of(context).size.width;
    final l10n = AppLocalizations.of(context);
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
              l10n?.other ?? '',
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
            _buildMenuItem(
                context, l10n?.reportByCategory ?? '', Icons.menu, () {}),
            _buildMenuItem(context, l10n?.account ?? '', Icons.account_circle,
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountPage(metadata: metadata, onLogout: onLogout)),
              );
            }),
            _buildMenuItem(context, l10n?.language ?? '', Icons.language, () {
              _showLanguageDialog(context,
                  Provider.of<LanguageProvider>(context, listen: false));
            }),
            _buildMenuItem(context, l10n?.currencyUnit ?? '',
                Icons.currency_exchange_rounded, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CurrencySelectorScreen()),
              );
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                  context, l10n.vietnamese ?? '', 'vi', languageProvider),
              _buildLanguageOption(
                  context, l10n.english ?? '', 'en', languageProvider),
            ],
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
                // Áp dụng ngôn ngữ đã chọn
                languageProvider.applySelectedLocale();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, String label,
      String languageCode, LanguageProvider languageProvider) {
    return InkWell(
      onTap: () {
        languageProvider.selectLocale(Locale(languageCode));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: languageProvider.selectedLocale.languageCode == languageCode
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            if (languageProvider.selectedLocale.languageCode == languageCode)
              Icon(Icons.check, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
