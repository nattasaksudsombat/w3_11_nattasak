import 'package:flutter/material.dart';
import 'package:w3_11_nattasak/api_service.dart';

import 'product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Product>>(
        future: ApiService.fetchProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("เกิดข้อผิดพลาดในการโหลดข้อมูล"));
          }

          final products = snapshot.data!;

          // ใช้ SingleChildScrollView เพื่อให้ตารางเลื่อนซ้าย-ขวาได้ถ้าจอแคบ
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('รูปภาพ')),
                  DataColumn(label: Text('ชื่อสินค้า')),
                  DataColumn(label: Text('ราคา')),
                ],
                rows: products.map((p) => DataRow(
                  cells: [
                    DataCell(
                        Image.network(p.photo, width: 50, height: 50, fit: BoxFit.cover)
                    ),
                    DataCell(Text(p.name)),
                    DataCell(Text('${p.price} บาท')),
                  ],
                )).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
