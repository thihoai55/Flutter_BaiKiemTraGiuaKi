// file: invoices_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Đã được thêm vào pubspec.yaml

// Model đại diện cho một hóa đơn
class Invoice {
  final String id;
  final DateTime date;
  final double total;
  final String productTitle;
  final String address;
  final String paymentMethod;

  Invoice({
    required this.id,
    required this.date,
    required this.total,
    required this.productTitle,
    required this.address,
    required this.paymentMethod,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      date: DateTime.parse(json['date']),
      total: double.tryParse(json['total']) ?? 0.0,
      productTitle: json['productTitle'],
      address: json['address'],
      paymentMethod: json['paymentMethod'],
    );
  }
}

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List<Invoice> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> rawInvoices = prefs.getStringList('invoices') ?? [];
    
    setState(() {
      _invoices = rawInvoices
          .map((jsonString) => Invoice.fromJson(jsonDecode(jsonString)))
          .toList()
          .reversed.toList(); // Hiển thị hóa đơn mới nhất trước
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử Hóa đơn', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _invoices.isEmpty
              ? const Center(
                  child: Text(
                    "Bạn chưa có hóa đơn nào.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _invoices.length,
                  itemBuilder: (context, index) {
                    return _buildInvoiceCard(_invoices[index]);
                  },
                ),
    );
  }

  // WIDGET HIỂN THỊ THẺ HÓA ĐƠN
  Widget _buildInvoiceCard(Invoice invoice) {
    // Định dạng ngày tháng
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDate = dateFormat.format(invoice.date);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hóa đơn #${invoice.id.split('-').last}", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal)
                ),
                Text(
                  "\$${invoice.total.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Colors.red)
                ),
              ],
            ),
            const Divider(height: 15),
            _buildDetailRow(Icons.calendar_today, "Ngày mua:", formattedDate),
            _buildDetailRow(Icons.shopping_bag, "Sản phẩm:", invoice.productTitle),
            _buildDetailRow(Icons.payment, "Thanh toán:", invoice.paymentMethod),
            _buildDetailRow(Icons.location_on, "Địa chỉ:", invoice.address, isAddress: true),
          ],
        ),
      ),
    );
  }
  
  // WIDGET PHỤ CHO CHI TIẾT HÓA ĐƠN
  Widget _buildDetailRow(IconData icon, String label, String value, {bool isAddress = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            label, 
            style: const TextStyle(fontWeight: FontWeight.w500)
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              textAlign: isAddress ? TextAlign.start : TextAlign.end,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}