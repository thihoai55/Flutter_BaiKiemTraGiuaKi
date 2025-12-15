import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class ChiSoBMI extends StatefulWidget {
  const ChiSoBMI({super.key});
  @override
  _ChiSoBMIState createState() => _ChiSoBMIState();
}

class _ChiSoBMIState extends State<ChiSoBMI> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _bmi;
  String _category = "";
  Color _resultColor = Colors.black87;

  // Màu chủ đạo
  final Color primaryColor = Colors.teal.shade700;
  final Color backgroundColor = Colors.white;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // -----------------------------
  // HÀM TÍNH BMI
  // -----------------------------
  void calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double? heightCm = double.tryParse(_heightController.text);
      double? weight = double.tryParse(_weightController.text);

      if (heightCm != null && weight != null && heightCm > 0 && weight > 0) {
        // Chuyển chiều cao từ cm (giả sử người dùng nhập cm) sang mét
        // Hoặc giữ nguyên là mét nếu bạn yêu cầu người dùng nhập mét.
        // Tôi giữ nguyên là mét như code cũ, nhưng Validator sẽ hướng dẫn nhập M
        double heightM = heightCm; 

        double result = weight / (heightM * heightM);

        setState(() {
          _bmi = double.parse(result.toStringAsFixed(2));
          _category = classifyBMI(_bmi!);
          _resultColor = _getCategoryColor(_bmi!);
        });
      }
    }
  }

  // -----------------------------
  // HÀM PHÂN LOẠI BMI
  // -----------------------------
  String classifyBMI(double bmi) {
    if (bmi < 18.5) return "Thiếu cân";
    if (bmi < 25) return "Bình thường";
    if (bmi < 30) return "Thừa cân";
    return "Béo phì";
  }
  
  // -----------------------------
  // HÀM LẤY MÀU PHÂN LOẠI
  // -----------------------------
  Color _getCategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade600;      // Thiếu cân
    if (bmi < 25) return Colors.green.shade600;     // Bình thường
    if (bmi < 30) return Colors.orange.shade600;    // Thừa cân
    return Colors.red.shade600;                   // Béo phì
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: Colors.grey.shade100, // Nền màu sáng nhẹ
      appBar: Header(),
      body: myBody(),
    );
  }

  // --------------------------------
  // AppBar tách thành hàm Header()
  // --------------------------------
  PreferredSizeWidget Header() {
    return AppBar(
      title: const Text("Tính chỉ số BMI", style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: primaryColor,
      centerTitle: true,
      foregroundColor: Colors.white,
      elevation: 4,
    );
  }

  // --------------------------------
  // Giao diện chính tách thành hàm myBody()
  // --------------------------------
  Widget myBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon hoặc Logo (Trang trí)
            Icon(Icons.monitor_heart_outlined, size: 80, color: primaryColor),
            const SizedBox(height: 25),

            // Card nhập liệu
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chiều cao
                    Text("Chiều cao (mét)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor)),
                    const SizedBox(height: 8),
                    _buildInputField(_heightController, Icons.height, "Nhập chiều cao (ví dụ: 1.75)", 'Chiều cao phải > 0 và là số hợp lệ', TextInputType.number),
                    const SizedBox(height: 20),

                    // Cân nặng
                    Text("Cân nặng (kg)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor)),
                    const SizedBox(height: 8),
                    _buildInputField(_weightController, Icons.monitor_weight, "Nhập cân nặng (ví dụ: 70)", 'Cân nặng phải > 0 và là số hợp lệ', TextInputType.number),
                    const SizedBox(height: 30),

                    // Nút tính
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: calculateBMI,
                        icon: const Icon(Icons.calculate, color: Colors.white, size: 24),
                        label: const Text("TÍNH BMI", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // Hiển thị kết quả
            if (_bmi != null)
              _buildResultCard(),

            const SizedBox(height: 30),

            // Bảng phân loại BMI
            _buildBmiCategoryTable(),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị kết quả BMI
  Widget _buildResultCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: _resultColor, width: 3), // Viền nổi bật
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "KẾT QUẢ CỦA BẠN",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: _resultColor,
              ),
            ),
            const Divider(height: 20, thickness: 1.5),
            Text(
              "Chỉ số BMI:",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 5),
            Text(
              _bmi!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _resultColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "Phân loại:",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 5),
            Text(
              _category,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _resultColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho input field
  Widget _buildInputField(
    TextEditingController controller,
    IconData icon,
    String hint,
    String validatorMessage,
    TextInputType keyboardType,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        final number = double.tryParse(value ?? '');
        if (value == null || value.isEmpty || number == null || number <= 0) {
          return validatorMessage;
        }
        return null;
      },
    );
  }
  
  // Widget Bảng phân loại BMI
  Widget _buildBmiCategoryTable() {
    // Thêm một hình ảnh tham khảo về bảng phân loại BMI
    //  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bảng Phân loại BMI (Theo WHO)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2.5),
            },
            border: TableBorder.all(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
            children: [
              _buildTableRow("Chỉ số BMI", "Phân loại", isHeader: true, headerColor: primaryColor),
              _buildTableRow("< 18.5", "Thiếu cân", color: _getCategoryColor(18)),
              _buildTableRow("18.5 - 24.9", "Bình thường", color: _getCategoryColor(20)),
              _buildTableRow("25.0 - 29.9", "Thừa cân", color: _getCategoryColor(27)),
              _buildTableRow(">= 30.0", "Béo phì", color: _getCategoryColor(35)),
            ],
          ),
        ),
      ],
    );
  }
  
  // Hàm tiện ích cho các hàng trong bảng
  TableRow _buildTableRow(String range, String category, {bool isHeader = false, Color? color, Color? headerColor}) {
    return TableRow(
      decoration: isHeader 
        ? BoxDecoration(color: headerColor ?? Colors.teal.shade700) 
        : BoxDecoration(color: Colors.white),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            range,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.white : color ?? Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            category,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
              color: isHeader ? Colors.white : color ?? Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}