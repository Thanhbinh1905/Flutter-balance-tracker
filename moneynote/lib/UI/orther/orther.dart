import 'package:flutter/material.dart';
import 'package:BalanceTracker/UI//account/account.dart';
import 'package:BalanceTracker/UI//currency/currency_select.dart';

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
          child: const Center(
            child: Text(
              "Khác",
              textAlign: TextAlign.center,
              style: TextStyle(
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
            _buildMenuItem(context, "Báo cáo theo danh mục", Icons.menu, () {}),
            _buildMenuItem(context, "Tài khoản", Icons.account_circle, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountPage(metadata: metadata, onLogout: onLogout)),
              );
            }),
            _buildMenuItem(context, "Ngôn ngữ", Icons.language, () {}),
            _buildMenuItem(
                context, "Đơn vị tiền tệ", Icons.currency_exchange_rounded, () {
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
}
