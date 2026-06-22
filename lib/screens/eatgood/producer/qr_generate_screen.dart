import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/eatgood_product_model.dart';

class QRGenerateScreen extends StatelessWidget {

  final EatGoodProduct product;

  const QRGenerateScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Generate QR",
        ),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Text(
              product.productName,

              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 30,
            ),

            QrImageView(

              data: product.productId,

              version: QrVersions.auto,

              size: 250,

            ),

            SizedBox(
              height: 30,
            ),

            Text(
              "Product ID",

              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              product.productId,
            ),

          ],
        ),
      ),
    );
  }
}