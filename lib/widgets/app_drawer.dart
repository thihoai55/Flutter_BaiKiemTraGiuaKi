import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Chuyển sang StatefulWidget để quản lý trạng thái đăng nhập và route hiện tại
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  // Biến trạng thái
  bool _isLoggedIn = false;
  String _currentRoute = '/';

  // Định nghĩa các cặp Route và Màu sắc tương ứng (Key là route)
  final Map<String, Color> iconColors = {
    // Nhóm Home/Navigation
    '/': Colors.blue.shade700,
    '/myprofile': Colors.pink.shade400,
    '/classroom': Colors.deepPurple.shade500,
    '/my_place': Colors.teal.shade500,
    // Nhóm Bài học
    '/buoi3': Colors.indigo.shade400,
    '/buoi4': Colors.orange.shade600,
    '/demso': Colors.green.shade600,
    '/bodemthoigian': Colors.cyan.shade600,
    '/chisoBMI': Colors.lightGreen.shade700,
    '/danhgia': Colors.amber.shade700,
    // Nhóm User/E-commerce
    '/userprofile': Colors.blueGrey.shade600,
    '/my_product': Colors.brown.shade500,
    '/invoices': Colors.deepOrange.shade600,
    '/newslist': Colors.purple.shade600,
    // Nhóm Auth/Test
    '/hometesttoken': Colors.red.shade600,
    '/dangnhap': Colors.blue.shade700, // Sử dụng màu xanh dương cho nút Đăng nhập chính
  };

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _currentRoute = ModalRoute.of(context)?.settings.name ?? '/';
        });
      }
    });
  }

  // Hàm kiểm tra trạng thái đăng nhập
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    
    if (mounted) {
      setState(() {
        _isLoggedIn = (token != null && token.isNotEmpty);
      });
    }
  }

  // Hàm Đăng xuất: Xóa token và về Home
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("isLoggedIn");
    
    Navigator.pop(context);

    // Chuyển hướng về màn hình HOME ('/') và xóa toàn bộ stack cũ
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/', 
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
            // 1. HEADER (ĐÃ TỐI ƯU)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, bottom: 20, left: 16, right: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff2196F3), Color(0xff4FC3F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                ]
              ),
              child: Row(
                children: [
                    const CircleAvatar(
                      radius: 28, 
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('asset/anhhoai.jpg'), 
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Xin chào,', 
                            style: TextStyle(color: Colors.white70, fontSize: 13)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isLoggedIn ? 'Nguyễn Thị Hoài' : 'Khách', 
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ),

            // 2. DANH SÁCH MENU (Sử dụng _buildTile có màu sắc)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildTile(context, Icons.home, 'Home', '/'),
                  _buildTile(context, Icons.account_box, 'Trang cá nhân của tôi', '/myprofile'), 
                  _buildTile(context, Icons.class_, 'Classroom', '/classroom'),
                  _buildTile(context, Icons.place, 'My place', '/my_place'),
                  
                  const Divider(thickness: 1, height: 1), 

                  _buildTile(context, Icons.book, 'Buổi 3', '/buoi3'),
                  _buildTile(context, Icons.palette, 'Buổi 4 (Đổi màu)', '/buoi4'),
                  _buildTile(context, Icons.format_list_numbered, 'Đếm số', '/demso'),
                  _buildTile(context, Icons.timer, 'Bộ đếm thời gian', '/bodemthoigian'),
                  _buildTile(context, Icons.monitor_weight, 'Chỉ số BMI', '/chisoBMI'),
                  _buildTile(context, Icons.thumb_up, 'Đánh giá', '/danhgia'),
                  
                  const Divider(thickness: 1, height: 1), 

                  _buildTile(context, Icons.account_circle, 'User profile', '/userprofile'), 
                  _buildTile(context, Icons.shopping_bag, 'My product', '/my_product'),
                  _buildTile(context, Icons.receipt_long, 'Hóa đơn đã mua', '/invoices'),
                  _buildTile(context, Icons.article, 'Tin tức Kinh doanh', '/newslist'),
                  
                  // MỤC TEST TOKEN chỉ hiển thị khi CHƯA đăng nhập
                  if (!_isLoggedIn)
                    _buildTile(context, Icons.verified_user, 'Test Token', '/hometesttoken'),
                ],
              ),
            ),

            // 3. NÚT ĐĂNG NHẬP/ĐĂNG KÝ/ĐĂNG XUẤT (Logic hiển thị)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _isLoggedIn 
                  ? _buildLogoutButton(context) 
                  : _buildLoginRegisterButtons(context),
            ),
          ],
        ),
    
    );
  }
  
  // Widget cho một ListTile trong Drawer (có hiệu ứng highlight và màu sắc)
  Widget _buildTile(BuildContext context, IconData icon, String title, String route) {
    final bool isSelected = _currentRoute == route;
    // Lấy màu sắc dựa trên route, nếu không tìm thấy thì dùng màu xám
    final Color itemColor = iconColors[route] ?? Colors.blueGrey.shade600;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      decoration: BoxDecoration(
        // Màu nền highlight nhạt hơn màu icon
        color: isSelected ? itemColor.withOpacity(0.15) : Colors.transparent, 
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          // Icon có màu động (sử dụng itemColor)
          color: isSelected ? itemColor : itemColor.withOpacity(0.7),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? itemColor : Colors.black87,
          ),
        ),
        trailing: isSelected 
            // Dùng icon check circle với màu động
            ? Icon(Icons.check_circle, color: itemColor, size: 20) 
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.pop(context); 
          if (mounted) {
            setState(() {
              _currentRoute = route;
            });
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, route);
          });
        },
      ),
    );
  }
  
  // Widget Nút Đăng nhập / Đăng ký
  Widget _buildLoginRegisterButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dangky');
            },
            icon: const Icon(Icons.person_add, color: Colors.teal),
            label: const Text('Đăng ký mới', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              side: const BorderSide(color: Colors.teal),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dangnhap');
            },
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text('Đăng nhập', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }
  
  // Widget Nút Đăng xuất
  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Đăng xuất', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}