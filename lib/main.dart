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
      title: 'products list',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'products list'),
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

  Widget _buildLabel(String label) {
    return Expanded(
      child: Text(
        label,//ชื่แที่จะถูกเปลียน
        textAlign: TextAlign.center,// ตรงกลาง
        style: const TextStyle(fontWeight: FontWeight.bold), // เป็นหัวข้อ
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Product>>(
        future: ApiService.fetchProduct(),
        builder: (context, snapshot) {//ไปกลางจอ
          if (snapshot.connectionState == ConnectionState.waiting)//วงกลมหมุนๆ
             {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("เกิดข้อผิดพลาดในการโหลดข้อมูล"));
          }

          final products = snapshot.data!;

          // ใช้ SingleChildScrollView เพื่อให้ตารางเลื่อนซ้าย-ขวาได้ถ้าจอแคบ
          return SingleChildScrollView( //เนื่องจากตาราง DataTable มักจะมีขนาดกว้างเกินหน้าจอมือถือ ึงใช้ SingleChildScrollView ซ้อนกัน 2 ชั้น:
            scrollDirection: Axis.vertical,//Axis.vertical : ช่วยให้เลื่อนดูสินค้าลงไปข้างล่างได้ถ้ามีหลายรายการ
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,//Axis.horizontal): ช่วยให้เลื่อนซ้าย-ขวาได้
              child: DataTable(//ตาราง
                  columns: [
                    DataColumn(label: _buildLabel('รูปภาพ')),//_buildLabel ฟั่งชั่นไวกลาง
                    DataColumn(label: _buildLabel('ชื่อสินค้า')),
                    DataColumn(label: _buildLabel('รายละเอียด')),
                    DataColumn(label: _buildLabel('น้ำหนัก')),
                    DataColumn(label: _buildLabel('ราคา')),
                  ],
                rows: products.map((p) => DataRow(//ลูปproducts เก็บใวใน P
                  cells: [//cells เว้นช่องไฟ
                    DataCell(
                        Image.network(p.photo, width: 50, height: 50, fit: BoxFit.cover)
                    ),
                    DataCell(Text(p.name)),
                    DataCell(Text(p.description)),
                    DataCell(Text('${p.weight} กรัม')),

                    DataCell(Text('${p.price} บาท')),
                  ],
                )).toList(),//Map ทั้งหมดกลับมาเป็น List เพื่อให้ DataTable
              ),
            ),
          );
        },
      ),
    );
  }
}
