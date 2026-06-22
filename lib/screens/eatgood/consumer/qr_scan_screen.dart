import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../services/eatgood_service.dart';
import 'analysis_screen.dart';
import '../../../services/openfoodfacts_service.dart';
import '../../../models/eatgood_product_model.dart';
import 'package:flutter/foundation.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  String scannedData = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Scan Product",
        ),
      ),

      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: MobileScannerController(
                autoStart: true,
              ),
              onDetect: (capture) async{
                final List<Barcode> barcodes =
                    capture.barcodes;
                for (final barcode in barcodes) {
                  String productId =
                      barcode.rawValue ?? "";
                  if (productId.isEmpty) {


                    break;

                  }
                  debugPrint("SCANNED ID = $productId");
                  debugPrint("ALL PRODUCTS:");
                  for (var p in EatGoodService.products) {
                    debugPrint(
                        "${p.productName} : ${p.productId}");
                  }
                  debugPrint("ID = $productId");
                  var product =
                  EatGoodService.getProductById(
                    productId,
                  );
                  if (product != null) {
                    debugPrint("PRODUCT FOUND");
                    debugPrint(product.productName);
                    debugPrint("BEFORE NAVIGATION");
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AnalysisScreen(
                              product: product,
                            ),
                      ),
                    );

                  }
                  else {

                    final openFoodProduct =

                        await OpenFoodFactsService
                        .getProduct(
                      productId,
                    );

                    if (
                    openFoodProduct != null
                    ) {

                      EatGoodProduct convertedProduct =

                      EatGoodProduct(

                        productId:
                        productId,

                        productName:
                        openFoodProduct.name,

                        ingredients:
                        openFoodProduct.ingredients,

                        calories:
                        openFoodProduct.calories,

                        sugar:
                        openFoodProduct.sugar,

                        fat:
                        openFoodProduct.fat,

                        protein:
                        openFoodProduct.protein,

                        sodium:
                        openFoodProduct.sodium,

                        qrData:
                        productId,

                      );

                      await Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>

                              AnalysisScreen(

                                product:
                                convertedProduct,

                              ),

                        ),

                      );
                    }

                    else {

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        const SnackBar(

                          content:

                          Text(

                            "Product not found",

                          ),

                        ),

                      );
                    }

                  }
                  return;
                }
              },

            ),

          ),

          Expanded(

            child: Center(

              child: Text(

                scannedData.isEmpty
                    ? "Scan a QR Code"
                    : scannedData,

                style: const TextStyle(
                  fontSize: 18,
                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}