// file: checkout_page.dart (Đã hoàn thiện)

import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/modal/product.dart';
import 'dart:math'; 
import 'dart:convert'; // <<< ĐÃ THÊM: Sửa lỗi jsonEncode >>>
import 'package:flutter_application_baikiemtra/userprofile_service.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:intl/intl.dart'; 


class CheckoutPage extends StatefulWidget {
  final Product product;

  const CheckoutPage({super.key, required this.product});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  String _paymentMethod = 'COD';
  String _invoiceId = '';

  bool _isProfileLoading = true; 

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  double get _shippingFee => 3.00;
  double get _totalPrice => widget.product.price + _shippingFee;

  @override
  void initState() {
    super.initState();
    _loadUserProfileDefaults(); 
  }

  Future<void> _loadUserProfileDefaults() async {
    final info = await UserProfileService.fetchShippingInfo(); 

    setState(() {
      _isProfileLoading = false;
      if (info != null) {
        _nameController.text = info.fullName;
        _addressController.text = info.address;
        _phoneController.text = info.phone;
      } else {
        _nameController.text = '';
        _addressController.text = '';
        _phoneController.text = '';
      }
    });
  }
  
  // HÀM: LƯU HÓA ĐƠN VÀ HOÀN TẤT
  Future<void> _completeOrder() async {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty || _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin nhận hàng.")),
        );
        return;
    }
    
    final newInvoiceId = 'INV-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(100)}';
    
    // 1. LƯU HÓA ĐƠN VÀO SHARED PREFERENCES
    final invoiceData = {
        'id': newInvoiceId,
        'date': DateTime.now().toIso8601String(),
        'total': _totalPrice.toStringAsFixed(2),
        'productTitle': widget.product.title,
        'productPrice': widget.product.price.toString(), 
        'shippingFee': _shippingFee.toString(),
        'name': _nameController.text,
        'address': _addressController.text,
        'paymentMethod': _paymentMethod,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> invoices = prefs.getStringList('invoices') ?? [];
    
    invoices.add(jsonEncode(invoiceData)); 
    
    await prefs.setStringList('invoices', invoices);

    // 2. CẬP NHẬT GIAO DIỆN
    setState(() {
      _invoiceId = newInvoiceId;
      _currentStep = 3; 
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán đơn hàng', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: (step) {
          if (step < _currentStep || step == _currentStep) {
            setState(() => _currentStep = step);
          }
        },
        controlsBuilder: (context, details) {
          return const SizedBox.shrink();
        },
        steps: [
          _buildStep(
            title: '1. Xác nhận đơn hàng', 
            content: _buildOrderSummary(),
            stepIndex: 0
          ),
          _buildStep(
            title: '2. Thông tin nhận hàng', 
            content: _buildShippingForm(),
            stepIndex: 1
          ),
          _buildStep(
            title: '3. Phương thức thanh toán', 
            content: _buildPaymentSelection(),
            stepIndex: 2
          ),
          _buildStep(
            title: '4. Hoàn tất & Hóa đơn', 
            content: _buildInvoice(),
            stepIndex: 3
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
  Step _buildStep({required String title, required Widget content, required int stepIndex}) {
    return Step(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: _currentStep >= stepIndex ? Colors.indigo : Colors.grey)),
      content: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: content
      ),
      isActive: _currentStep >= stepIndex,
      state: _currentStep > stepIndex ? StepState.complete : StepState.indexed,
    );
  }

  // WIDGET 1: TÓM TẮT ĐƠN HÀNG
  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(widget.product.image, width: 50, height: 50, fit: BoxFit.cover)
            ),
            title: Text(widget.product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text("Giá: \$${widget.product.price.toStringAsFixed(2)}"),
          ),
        ),
        const SizedBox(height: 15),
        _buildPriceRow("Giá sản phẩm:", widget.product.price, Colors.black87),
        _buildPriceRow("Phí vận chuyển:", _shippingFee, Colors.redAccent),
        const Divider(),
        _buildPriceRow("Tổng cộng:", _totalPrice, Colors.indigo, isTotal: true),
        const SizedBox(height: 10),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _currentStep = 1); 
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Tiếp tục', style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }
  
  // WIDGET 2: FORM THÔNG TIN NHẬN HÀNG
  Widget _buildShippingForm() {
    if (_isProfileLoading) {
      return const Center(child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text("Đang tải thông tin giao hàng từ hồ sơ...")
        ],
      ));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Thông tin sẽ được tự động điền nếu bạn đã đăng nhập.", 
          style: TextStyle(fontSize: 14, color: Colors.blueGrey),
        ),
        const SizedBox(height: 10),
        _buildInputField(_nameController, 'Tên người nhận', Icons.person),
        _buildInputField(_phoneController, 'Số điện thoại', Icons.phone),
        _buildInputField(_addressController, 'Địa chỉ chi tiết', Icons.location_on, maxLines: 3),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _currentStep = 2); 
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Tiếp tục thanh toán', style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  // WIDGET 3: CHỌN PHƯƠNG THỨC THANH TOÁN
  Widget _buildPaymentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentOption('COD', 'Thanh toán khi nhận hàng', Icons.money),
        _buildPaymentOption('E-WALLET', 'Ví điện tử (Momo, ZaloPay,...)', Icons.account_balance_wallet),
        _buildPaymentOption('CARD', 'Thẻ tín dụng/ghi nợ (Visa/Mastercard)', Icons.credit_card),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeOrder, // Hoàn tất đơn hàng
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Đặt hàng và thanh toán bằng ${_paymentMethod}', style: const TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }

  // WIDGET 4: HÓA ĐƠN HOÀN TẤT
  Widget _buildInvoice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.green.shade50,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.green)),
          child: ListTile(
            leading: const Icon(Icons.check_circle, color: Colors.green, size: 30),
            title: const Text("Đơn hàng đã hoàn tất!", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            subtitle: Text("Mã hóa đơn: $_invoiceId"),
          ),
        ),
        const SizedBox(height: 20),
        
        _buildPriceRow("Tổng tiền đã thanh toán:", _totalPrice, Colors.green, isTotal: true),
        _buildPriceRow("Phương thức:", _paymentMethod, Colors.black87, isCurrency: false),
        
        // Sửa lỗi overflow bằng cách dùng Column cho địa chỉ
        _buildAddressRow("Địa chỉ giao hàng:", _addressController.text, Colors.black87),
        
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/invoices'); 
            },
            icon: const Icon(Icons.receipt_long),
            label: const Text("Xem tất cả hóa đơn"),
          ),
        )
      ],
    );
  }

  // WIDGET PHỤ MỚI: DÒNG ĐỊA CHỈ (Sử dụng Column để tránh overflow)
  Widget _buildAddressRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET PHỤ: DÒNG GIÁ
  Widget _buildPriceRow(String label, dynamic value, Color color, {bool isTotal = false, bool isCurrency = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            isCurrency ? "\$${(value as double).toStringAsFixed(2)}" : value.toString(), 
            style: TextStyle(
              fontSize: isTotal ? 20 : 16, 
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, 
              color: color
            )
          ),
        ],
      ),
    );
  }

  // WIDGET PHỤ: INPUT FIELD
  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.indigo),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  // WIDGET PHỤ: CHỌN THANH TOÁN
  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: _paymentMethod == value ? const BorderSide(color: Colors.indigo, width: 2) : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(icon, color: _paymentMethod == value ? Colors.indigo : Colors.grey),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: _paymentMethod == value ? Colors.indigo : Colors.black87)),
        trailing: _paymentMethod == value ? const Icon(Icons.check_circle, color: Colors.indigo) : null,
        onTap: () {
          setState(() {
            _paymentMethod = value;
          });
        },
      ),
    );
  }
  
  // WIDGET BOTTOM BAR
  Widget _buildBottomBar(BuildContext context) {
    if (_currentStep == 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Tổng thanh toán:", style: TextStyle(fontSize: 18, color: Colors.black87)),
          Text(
            "\$${_totalPrice.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ],
      ),
    );
  }
}