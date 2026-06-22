import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/eatgood_product_model.dart';

class EatGoodService {

  static Box<EatGoodProduct> productBox =
  Hive.box<EatGoodProduct>(
    'products',
  );
  static List<EatGoodProduct> get products {
    return productBox.values.toList();
  }
  static void addProduct(
      EatGoodProduct product,
      ) {

    debugPrint(
        "ADDING ${product.productName}");

    productBox.put(
      product.productId,
      product,
    );

    debugPrint(
        "BOX LENGTH AFTER ADD = ${productBox.length}");

  }
  static void updateProduct(
      EatGoodProduct product,
      ) {
    productBox.put(
      product.productId,
      product,
    );
  }
  static void deleteProduct(
      String productId,
      ) {
    productBox.delete(
      productId,
    );
  }
  static EatGoodProduct? getProductById(
      String productId,
      ) {
    return productBox.get(
      productId,
    );
  }
}