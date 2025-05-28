import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/local_storage.dart';
import '../../../../models/data/bag_data.dart';

class BagController extends GetxController {
  RxList<Map<String, String>> products = <Map<String, String>>[].obs;



  @override
  void onInit() {
    super.onInit();
    updateProductsFromBags();
  }

  void updateProductsFromBags() {
    List<BagData> bags = LocalStorage.getBags();
    Map<String, int> tempMap = {};
    products.clear();
    for (var bag in bags) {
      if (bag.bagProducts != null) {
        for (var product in bag.bagProducts!) {
          print('product.parentId: ${product.stockId}');
          print('product quantity: ${product.quantity}');
          products.add({"qty" : product.quantity.toString(), "id" : product.stockId.toString()});
        }
      }
    }

    print("products: $products");
  }


   getQtyById( id) {
    final product = products.firstWhere(
          (p) => p["id"] == id,
      orElse: () => {},
    );

    // Get qty value which might be int, String, or null
    final qtyValue = product["qty"];

    if (qtyValue == null) {
      return 0; // default if null
    }

    if (qtyValue is int) {
      return qtyValue;
    }

    if (qtyValue is String) {
      // try parsing string to int, return 0 if fail
      return int.tryParse(qtyValue) ?? 0;
    }

    // fallback
    return 0;
  }


}
