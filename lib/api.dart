//import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_baikiemtra/modal/product.dart';

class API {
  Future<List<Product>> getAllProduct() async {
    var url = 'https://fakestoreapi.com/products';
    var dio = Dio();
    var response = await dio.get(url); 
    List<Product> ls = [];
    if (response.statusCode == 200) {
      List data = response.data;
      ls = data.map((json)=>Product.fromJson(json)).toList(); //bien 1 doi tuong trong js thanh nhung doi tuong torng modal
    } 
    else {
      print('Loiiiiiiiii');
    }
    return ls;
  }
}

var test_api = API();
