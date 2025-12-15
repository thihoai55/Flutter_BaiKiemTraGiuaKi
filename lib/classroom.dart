import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class ClassRomm extends StatelessWidget {
  const ClassRomm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Danh sách Lớp học',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(child: myBody()),
    );
  }

  Widget myBody() {
    // 1. Danh sách tên môn học khác nhau
    final classNames = [
      'Lớp 1: Lập trình di động Flutter',
      'Lớp 2: Cơ sở dữ liệu nâng cao',
      'Lớp 3: Phát triển ứng dụng Web',
      'Lớp 4: Trí tuệ nhân tạo cơ bản',
      'Lớp 5: Mạng máy tính và bảo mật',
      'Lớp 6: Phân tích và thiết kế hệ thống',
      'Lớp 7: Quản lý dự án phần mềm',
      'Lớp 8: Nhập môn XML và ứng dụng',
      'Lớp 9: Công nghệ thực tế ảo (VR)',
      'Lớp 10: Thiết kế đồ họa UI/UX',
    ];

    // Màu sắc và ảnh nền giữ nguyên
    final colors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.blueGrey,
      Colors.brown,
    ];
    
    // Thêm một số ảnh nền mới để tránh lặp lại quá nhiều
    final images = [
      'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&s=0f9d5d4b7a7a2f5b2d8e0b9a1f3a6b6f', // Sách vở
      'https://images.unsplash.com/photo-1521295121783-8a321d551ad2?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&s=3a6c6b2f6f4f9dd6b1c7c3e8f2a9c1d2', // Máy tính, lập trình
      'https://images.unsplash.com/photo-1537432376769-00a5c6f3f1b6?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&s=6b9f3d5c7e8f1a2b3c4d5e6f7a8b9c0d', // Đồ họa
      'https://images.unsplash.com/photo-1498050108023-c5249f4df085?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&s=9a7b6c5d4e3f2a1b0c9d8e7f6a5b4c3d', // Thiết bị
      'https://images.unsplash.com/photo-1550009159-d3e5124f0c3d?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Mạng
      'https://images.unsplash.com/photo-1510511232890-ba383416e6d1?q=80&w=800&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', // Công nghệ
    ];

    final totalItems = classNames.length;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Tăng padding nhẹ
      itemCount: totalItems,
      itemBuilder: (context, index) {
        final colorIndex = index % colors.length;
        final imageIndex = index % images.length;
        
        // Tạo mã lớp học duy nhất (ví dụ: TIN4583.L001, L002,...)
        final classCode = '2025-2026.TIN4583.L${(index + 1).toString().padLeft(3, '0')}';
        
        return ClassroomItem(
          title: classNames[index], // Lấy tên lớp duy nhất
          subtitle: classCode,
          count: '${20 + index} sinh viên',
          color: colors[colorIndex].withOpacity(0.9), // Tăng độ đậm màu
          backgroundImage: images[imageIndex],
        );
      },
    );
  }
}

// Giữ nguyên ClassroomItem vì giao diện của nó đã khá đẹp
class ClassroomItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String count;
  final Color color;
  final String? backgroundImage;

  const ClassroomItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Tăng chiều cao nhẹ
      margin: const EdgeInsets.symmetric(vertical: 10), // Tăng khoảng cách
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Bo góc lớn hơn
        color: color,
        image: backgroundImage != null
            ? DecorationImage(
                image: NetworkImage(backgroundImage!),
                fit: BoxFit.cover,
                // Giảm opacity của lớp phủ đen để ảnh rõ hơn
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.20), BlendMode.darken), 
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // Tăng đổ bóng
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material( // Wrap bằng Material để có hiệu ứng tap mặc định
        color: Colors.transparent,
        child: InkWell( // Thêm hiệu ứng gợn sóng khi nhấn
          onTap: () {
            // Xử lý khi nhấn vào lớp học
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Mở lớp: $title')),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // Thêm gradient từ trên xuống dưới
                        colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.25)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0), // Tăng padding nội dung
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy nội dung lên và xuống
                    children: [
                      // Top Section: Title & Subtitle
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Tăng kích thước chữ tiêu đề
                              fontWeight: FontWeight.w800,
                              shadows: [Shadow(blurRadius: 4, color: Colors.black45)]
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      // Bottom Section: Count & Menu Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2), // Màu nền tag sinh viên
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.group, size: 14, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  count, 
                                  style: const TextStyle(
                                    color: Colors.white, 
                                    fontSize: 13, 
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ],
                            ),
                          ),
                          
                          // Nút menu
                          GestureDetector(
                            onTap: () => debugPrint('Open menu for $title'),
                            child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    shape: BoxShape.circle),
                                child: const Icon(Icons.more_horiz, color: Colors.white, size: 24)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}