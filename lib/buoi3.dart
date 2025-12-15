
import 'package:flutter/material.dart';
import 'package:flutter_application_baikiemtra/widgets/app_drawer.dart';

class Buoi3 extends StatelessWidget {
  const Buoi3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Buổi 3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            block1(),
            block2(),
            block3(),
            block4(),
            block5()
            
          ],
        ),
      )
    );
  }
}

Widget block1() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      IconButton(
        icon: Icon(Icons.notifications),
        color: Colors.black54,
        onPressed: () {

        },
      ),
      SizedBox(width: 8),
      IconButton(
        icon: Icon(Icons.extension),
        color: Colors.black54,
        onPressed: () {

        },
      ),
    ],
  );
}


Widget block2() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Charlie',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget block3() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color.fromARGB(255, 111, 218, 223), 
        width: 1, 
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.search, color: const Color.fromARGB(255, 111, 218, 223)),
        SizedBox(width: 8),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget block4() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Text(
      'Saved places',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget block5() {
  final imgs = [
    'asset/anhkt1.jpg',
    'asset/anhkt2.jpg',
    'asset/anhkt3.jpg',
    'asset/anhkt4.jpg',
  ];

  return Expanded(
    child: GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: List.generate(imgs.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imgs[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      }),
    ),
  );
}