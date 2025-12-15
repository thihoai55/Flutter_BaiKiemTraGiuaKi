import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class DanhGia extends StatefulWidget {
  const DanhGia({super.key});
  @override
  _DanhGiaState createState() => _DanhGiaState();
}

class _DanhGiaState extends State<DanhGia> {
  final _formKey = GlobalKey<FormState>(); // Thêm GlobalKey cho Form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  int selectedStar = 0; // Thay đổi kiểu dữ liệu, 0 là chưa chọn

  // Màu chủ đạo
  final Color primaryColor = Colors.orange.shade600;
  final Color starColor = Colors.amber.shade700;
  
  @override
  void dispose() {
    nameController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: header(),
      body: myBody(),
    );
  }

  // ---------------- HEADER ----------------
  PreferredSizeWidget header() {
    return AppBar(
      backgroundColor: primaryColor,
      title: const Text(
        "Gửi Phản Hồi & Đánh Giá",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  // ---------------- BODY ----------------
  Widget myBody() {
    return Container(
      color: Colors.grey.shade50, // Màu nền sáng nhẹ
      padding: const EdgeInsets.all(25),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Tiêu đề & Icon lớn
            Icon(Icons.rate_review_outlined, size: 80, color: primaryColor),
            const SizedBox(height: 20),

            // Họ tên
            _buildLabel("Họ tên"),
            _buildTextField(
              controller: nameController,
              icon: Icons.person,
              hintText: "Nhập họ tên của bạn",
              validatorMessage: "Vui lòng nhập họ tên",
            ),

            const SizedBox(height: 25),

            // Đánh giá sao (Rating Bar)
            _buildLabel("Mức độ hài lòng (1-5 Sao)"),
            _buildRatingBar(),

            const SizedBox(height: 25),

            // Nội dung góp ý
            _buildLabel("Nội dung góp ý"),
            _buildTextField(
              controller: contentController,
              icon: Icons.edit_note,
              hintText: "Nhập góp ý, nhận xét của bạn...",
              maxLines: 5,
              validatorMessage: "Vui lòng nhập nội dung góp ý",
            ),

            const SizedBox(height: 40),

            // Nút gửi phản hồi
            Center(
              child: SizedBox(
                width: 250,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                  ),
                  onPressed: sendFeedback,
                  icon: const Icon(Icons.send_rounded, size: 24),
                  label: const Text(
                    "GỬI PHẢN HỒI",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // ---------------- WIDGETS TÁCH RIÊNG ----------------

  // Widget Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w600, 
          color: primaryColor
        ),
      ),
    );
  }
  
  // Widget TextField chung
  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    required String validatorMessage,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: maxLines > 1 ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: primaryColor),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  // Widget Rating Bar (thay thế Dropdown)
  Widget _buildRatingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int starValue = index + 1;
        return IconButton(
          icon: Icon(
            starValue <= selectedStar ? Icons.star_rounded : Icons.star_border_rounded,
            color: starValue <= selectedStar ? starColor : Colors.grey.shade400,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              selectedStar = starValue;
            });
          },
        );
      }),
    );
  }

  // ---------------- FUNCTION GỬI PHẢN HỒI ----------------
  void sendFeedback() {
    if (_formKey.currentState!.validate()) {
      if (selectedStar == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Vui lòng chọn số sao đánh giá")),
        );
        return;
      }
      
      // Xử lý gửi phản hồi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gửi phản hồi thành công! Đánh giá: $selectedStar sao."),
          backgroundColor: Colors.green.shade600,
        ),
      );

      // Đặt lại form sau khi gửi
      setState(() {
        nameController.clear();
        contentController.clear();
        selectedStar = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
    }
  }
}