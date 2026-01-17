import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';
import 'package:w3_11_nattasak/product_model.dart';

class ApiService{
  static Future <List<Product>> fetchProduct() async{

    final response = await http.get(Uri.parse("https://6964b225e8ce952ce1f28d47.mockapi.io/products"));

    if(response.statusCode==200){
      final List deta =  jsonDecode(response.body);
      return deta.map((e) => Product.fromJson(e)).toList();

    }else{
      throw Exception('ไม่สำเร็จ');
    }
  }
}