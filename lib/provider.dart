import 'package:flutter/material.dart';
import 'api.dart';
import 'model.dart';

class DataProvider with ChangeNotifier {
  CategoryModel? histList; // Use nullable type to avoid late initialization issues
  bool loading = false;

  final Services services = Services();

  Future<void> getPostData() async {
    loading = true;
    notifyListeners(); // Notify listeners to show loading state

    try {
      histList = await services.getData();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      loading = false;
      notifyListeners(); // Notify listeners to refresh UI
    }
  }
}
