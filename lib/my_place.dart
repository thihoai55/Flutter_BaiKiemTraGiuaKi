import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class MyPlace extends StatelessWidget {
  const MyPlace({super.key});

  // Màu thương hiệu chính
  static const Color primaryColor = Colors.teal;
  static const Color accentColor = Colors.tealAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bỏ drawer khỏi Scaffold chính, dùng CustomScrollView
      body: CustomScrollView(
        slivers: [
          // Block 1: Ảnh và AppBar (SliverAppBar)
          _buildSliverAppBar(),
          
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Block 2: Tiêu đề và Đánh giá
                _block2Content(),
                
                // Đường phân cách
                const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                
                // Block 3: Hành động (Call, Route, Share)
                _block3Content(),
                
                // Đường phân cách
                const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                
                // Block 4: Mô tả chi tiết
                _block4Content(),
                
                const SizedBox(height: 40), // Khoảng trắng cuối trang
              ],
            ),
          ),
        ],
      ),
      // Drawer được giữ lại ở đây để có thể truy cập qua icon Menu trên AppBar
      drawer: const AppDrawer(), 
    );
  }
  
  // ----------------------------------------------------
  // SLIVER APP BAR (BLOCK 1 CẢI TIẾN)
  // ----------------------------------------------------
  Widget _buildSliverAppBar() {
    var src = "https://images.unsplash.com/photo-1559586616-361e18714958?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";

    return SliverAppBar(
      expandedHeight: 280.0, // Tăng chiều cao ảnh
      pinned: true, // Giữ AppBar lại khi cuộn
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 60, bottom: 16), // Để lại chỗ cho nút back
        title: const Text(
          'Oeschinen Lake',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            shadows: [
              Shadow(blurRadius: 4, color: Colors.black, offset: Offset(0, 1))
            ]
          ),
        ),
        background: Image.network(
          src,
          width: double.infinity,
          fit: BoxFit.cover,
          // Thêm lớp phủ nhẹ để chữ dễ đọc hơn
          colorBlendMode: BlendMode.darken,
          color: Colors.black.withOpacity(0.2), 
        ),
      ),
      backgroundColor: primaryColor,
      foregroundColor: Colors.white, // Nút back và menu màu trắng
    );
  }

  // ----------------------------------------------------
  // BLOCK 2: TIÊU ĐỀ & ĐÁNH GIÁ (Cải tiến)
  // ----------------------------------------------------
  Widget _block2Content() {
    var title = "Oeschinen Lake Campground";
    var subtitle = "Kandersteg, Switzerland";
    
    return Padding(
      padding: const EdgeInsets.all(25), // Tăng padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900, // Rất đậm
                    fontSize: 26, 
                    color: Colors.black87
                  ), 
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: primaryColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: primaryColor.withOpacity(0.3))
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rate_rounded, color: Colors.amber, size: 28), // Sao vàng rực rỡ
                const SizedBox(width: 6),
                const Text(
                  "4.1", 
                  style: TextStyle(
                    fontWeight: FontWeight.w900, // Rất đậm
                    fontSize: 20, 
                    color: Colors.black87
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // BLOCK 3: HÀNH ĐỘNG (Cải tiến)
  // ----------------------------------------------------
  Widget _block3Content() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionColumn(Icons.call, "GỌI", primaryColor),
          _buildActionColumn(Icons.near_me, "CHỈ ĐƯỜNG", primaryColor),
          _buildActionColumn(Icons.share, "CHIA SẺ", primaryColor),
          _buildActionColumn(Icons.bookmark_border, "LƯU LẠI", primaryColor),
        ],
      ),
    );
  }

  // Widget phụ cho block3 (Không thay đổi nhiều, chỉ cập nhật màu chữ)
  Widget _buildActionColumn(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {}, 
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30), // Icon lớn hơn
            const SizedBox(height: 6),
            Text(
              label, 
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13) // Chữ in hoa và đậm
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // BLOCK 4: MÔ TẢ (Cải tiến)
  // ----------------------------------------------------
  Widget _block4Content() {
    var data = "Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese Alps. Situated 1,578 meters above sea level, it is one of the larger Alpine Lakes. A gondola ride from Kandersteg, followed by a half-hour walk through pastures and pine forest, leads you to the lake, which warms to 20 degrees Celsius in the summer. Activities enjoyed here include rowing, and riding the summer toboggan run.";
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mô tả chi tiết",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data,
            textAlign: TextAlign.justify, // Căn đều hai bên cho văn bản chuyên nghiệp
            style: const TextStyle(
              fontSize: 16, 
              height: 1.6, // Tăng chiều cao dòng rất quan trọng cho khả năng đọc
              color: Colors.black87
            ), 
          ),
        ],
      ),
    );
  }
}