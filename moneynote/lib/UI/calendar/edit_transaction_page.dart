import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:BalanceTracker/constants/constant.dart';
import 'package:BalanceTracker/utils/currency_settings.dart';
import 'package:intl/intl.dart';

class EditTransactionPage extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final String clientId;
  final Function refreshTransactions;

  const EditTransactionPage({
    super.key,
    required this.transaction,
    required this.clientId,
    required this.refreshTransactions,
  });

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  bool _isLoading = false;
  late DateTime _selectedDate;
  late List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.transaction['transaction_amount'].toString());
    _descriptionController = TextEditingController(
        text: widget.transaction['transaction_description']);
    _selectedCategoryId = widget.transaction['category']['_id'];
    _selectedDate =
        DateFormat('dd/MM/yyyy').parse(widget.transaction['transaction_date']);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final url = Uri.parse(
        '${GetConstant().apiEndPoint}/category?category_type=${widget.transaction['transaction_type']}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': widget.clientId,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = List<Map<String, dynamic>>.from(data['metadata']);
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _editTransaction() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        '${GetConstant().apiEndPoint}/transaction?transaction_id=${widget.transaction['_id']}');
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'CLIENT_ID': widget.clientId,
        },
        body: jsonEncode({
          "transaction_amount": double.parse(_amountController.text),
          "transaction_description": _descriptionController.text,
          "category": _selectedCategoryId,
          "transaction_date": DateFormat('dd/MM/yyyy').format(_selectedDate),
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Giao dịch đã được cập nhật thành công')),
        );
        widget.refreshTransactions();
        Navigator.pop(context);
      } else {
        throw Exception('Không thể cập nhật giao dịch');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa giao dịch'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            DropdownButton<String>(
              value: _selectedCategoryId,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['_id'],
                  child: Text(category['category_name']),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoryId = newValue;
                });
              },
              hint: const Text('Chọn danh mục'),
            ),
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                  'Chọn ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _editTransaction,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cập nhật giao dịch'),
            ),
          ],
        ),
      ),
    );
  }
}
