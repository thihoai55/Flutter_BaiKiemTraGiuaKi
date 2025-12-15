// file: user_profile_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Model đơn giản hóa để chứa dữ liệu giao hàng cần thiết
class ShippingInfo {
  final String fullName;
  final String phone;
  final String address;

  ShippingInfo({required this.fullName, required this.phone, required this.address});
}

class UserProfileService {
  static Future<ShippingInfo?> fetchShippingInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    String? localFullName = prefs.getString("user_full_name");
    String? localEmail = prefs.getString("user_email");


    // 1. Ưu tiên Profile API (Nếu có Token)
    if (token != null) {
      var url = Uri.parse("https://dummyjson.com/auth/me");
      try {
        var response = await http.get(
          url,
          headers: {"Authorization": "Bearer $token"},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);

          final String firstName = data['firstName'] ?? '';
          final String lastName = data['lastName'] ?? '';
          final String phone = data['phone'] ?? 'N/A'; // Lấy SĐT nếu có
          
          final addressData = data['address'] ?? {};
          final String addressLine = addressData['address'] ?? '';
          // SỬA LỖI: Lấy trường 'city' thay vì 'address' lần nữa
          final String city = addressData['city'] ?? ''; 
          
          final fullAddress = "$addressLine, $city";

          return ShippingInfo(
            fullName: "$firstName $lastName",
            phone: phone,
            address: fullAddress,
          );
        } 
      } catch (e) {
        // Lỗi mạng hoặc lỗi API, bỏ qua và chuyển sang tải cục bộ
        print("Lỗi tải API cho Shipping Info: $e");
      }
    }
    
    // 2. Tải Profile Cục bộ (Nếu API thất bại hoặc không có Token)
    if (localFullName != null && localEmail != null) {
       // Sử dụng thông tin đã lưu từ quá trình Đăng nhập Cục bộ
       return ShippingInfo(
          fullName: localFullName,
          // Sử dụng các giá trị mặc định cho SĐT và Địa chỉ vì dữ liệu cục bộ không có
          phone: 'N/A (Cần cập nhật)',
          address: 'Địa chỉ mặc định (Cần cập nhật)',
        );
    }

    // 3. Không có dữ liệu nào
    return null;
  }
}