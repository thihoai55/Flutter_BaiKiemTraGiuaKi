import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/api.dart'; 
import 'package:flutter_application_baikiemtra/modal/product.dart'; 
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_baikiemtra/checkout_page.dart'; 

class MyProduct extends StatefulWidget {
  const MyProduct({super.key});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  String? _token;
  Future<List<Product>>? _productsFuture;

  @override
  void initState() {
    super.initState();
    _checkAuthAndFetchProducts();
  }

  // 1. KIỂM TRA XÁC THỰC VÀ BẮT ĐẦU TẢI SẢN PHẨM
  Future<void> _checkAuthAndFetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    setState(() {
      _token = token;
      if (_token != null) {
        // Chỉ gọi API nếu có Token
        _productsFuture = _fetchProducts();
      }
    });
  }

  // 2. HÀM GỌI API THỰC TẾ (Cần thay thế bằng logic API của bạn)
  Future<List<Product>> _fetchProducts() async {
    // --- LỖI CŨ ĐÃ ĐƯỢC THAY THẾ ---
    // Giả định test_api.getAllProduct() là hàm gọi API thực tế
    
    // VÍ DỤ MÔ PHỎNG DỮ LIỆU THÀNH CÔNG (CẦN SỬA LẠI THEO API THỰC TẾ CỦA BẠN)
    if (_token != null) {
      // API của bạn sẽ cần phải có token để xác thực, nếu cần.
      // Dòng này cần được thay thế bằng: return await test_api.getAllProduct();
      return test_api.getAllProduct(); // <--- DÒNG BẠN CẦN KÍCH HOẠT LẠI
    }
    // ---------------------------------

    // Nếu API thất bại (ví dụ lỗi mạng), ném ngoại lệ
    throw Exception("Không thể kết nối đến máy chủ API."); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Danh sách Sản phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    // 3. KIỂM TRA TRẠNG THÁI XÁC THỰC
    if (_token == null) {
      return _buildRequiredLoginView(context);
    }
    
    // Nếu đã đăng nhập, hiển thị FutureBuilder để tải dữ liệu
    return FutureBuilder<List<Product>>(
      future: _productsFuture, 
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.indigo));
        } else if (snap.hasError) {
          // Xử lý lỗi khi gọi API (ví dụ: Token hết hạn hoặc lỗi mạng)
          return Center(child: Text("Lỗi tải dữ liệu: ${snap.error}"));
        } else if (!snap.hasData || snap.data!.isEmpty) {
          return const Center(child: Text("Không có sản phẩm nào."));
        } else {
          return myListView(snap.data!);
        }
      },
    );
  }

  // 4. GIAO DIỆN YÊU CẦU ĐĂNG NHẬP (Đẹp và lộng lẫy)
  Widget _buildRequiredLoginView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.lock_person, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),
            const Text(
              "Yêu cầu Xác thực",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Bạn cần đăng nhập để xem danh sách sản phẩm. Đây là khu vực bảo mật.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/dangnhap');
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text(
                "Đăng nhập ngay",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myListView(List<Product> ls) {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 320, 
      ),
      itemCount: ls.length,
      itemBuilder: (context, index) {
        return myItem(ls[index]);
      },
    );
  }

  Widget myItem(Product p) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Thêm logic chuyển sang trang chi tiết sản phẩm
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: AspectRatio(
                aspectRatio: 1.2, 
                child: Image.network(
                  p.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(Icons.broken_image, size: 30, color: Colors.grey.shade600),
                    );
                  },
                ),
              ),
            ),

            // Nội dung
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    buildRating(p.rating.rate),
                    const SizedBox(height: 8),
                    Text(
                      "\$${p.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900, // Giá to và đậm hơn
                        color: Colors.red, // Màu nổi bật cho giá
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart, size: 16, color: Colors.white),
                          label: const Text(
                            "Mua ngay",
                            style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(product: p),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo, // Màu nổi bật hơn
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo ra hàng sao đánh giá
  Widget buildRating(double rate) {
    int full = rate.floor();
    bool half = (rate - full) >= 0.5;

    return Row(
      children: [
        for (int i = 0; i < full; i++)
          const Icon(Icons.star, size: 16, color: Colors.amber),

        if (half) const Icon(Icons.star_half, size: 16, color: Colors.amber),

        for (int i = 0; i < 5 - full - (half ? 1 : 0); i++)
          const Icon(Icons.star_border, size: 16, color: Colors.grey),
          
        const SizedBox(width: 5),
        Text(
          rate.toStringAsFixed(1), 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)
        ),
      ],
    );
  }
}