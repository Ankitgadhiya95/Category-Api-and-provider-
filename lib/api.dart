import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';

class Services {
  Future<CategoryModel?> getData() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {

        final jsonData = json.decode(response.body);
        print(response.body);
        return CategoryModel.fromJson(jsonData);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}


/*
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';

class Services{
  Future<CategoryModel> getData(context) async {
    // late CategoryModel data;
    List<CategoryModel> histList = [];

    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        histList.add(item);// Mapping json response to our data model
      } else {
        print('Error Occurred');
      }

    } catch (e) {
      print('Error Occurred'+e.toString());
    }
     // return ;
  }
}*//*


import 'dart:convert';

import 'package:http/http.dart' as http;

import 'model.dart';

class Services{
  Future<CategoryModel> getData(context) async {
    late CategoryModel data;
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        data = CategoryModel.fromJson(item);// Mapping json response to our data model
      print(data);
      } else {
        print('Error Occurred');
      }
    } catch (e) {
      print('Error Occurred'+e.toString());
    }
    return data;
  }
}*/
