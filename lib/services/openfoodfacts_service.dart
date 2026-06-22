import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/openfood_product_model.dart';

class OpenFoodFactsService {
  static Future<OpenFoodProduct?> getProduct(
      String barcode,
      )
  async {

    try {

      final response = await http.get(

        Uri.parse(
          "https://world.openfoodfacts.org/api/v2/product/$barcode.json",
        ),

      );

      if (response.statusCode != 200) {

        return null;

      }

      final data =
      jsonDecode(response.body);

      if (
      data["status"] != 1
      ) {

        return null;

      }

      final product =
      data["product"];

      List<String> ingredients = [];

      if (
      product["ingredients_text"]
          != null
      ) {

        ingredients =
            product["ingredients_text"]
                .toString()
                .split(",");

      }

      return OpenFoodProduct(

        name:

        product["product_name"] ??
            "Unknown Product",

        ingredients:
        ingredients,

        calories:

        double.tryParse(

          product[
          "nutriments"]
          [
          "energy-kcal_100g"]
              ?.toString()

              ??

              "0",

        ) ??

            0,

        sugar:

        double.tryParse(

          product[
          "nutriments"]
          [
          "sugars_100g"]
              ?.toString()

              ??

              "0",

        ) ??

            0,

        fat:

        double.tryParse(

          product[
          "nutriments"]
          [
          "fat_100g"]
              ?.toString()

              ??

              "0",

        ) ??

            0,

        protein:

        double.tryParse(

          product[
          "nutriments"]
          [
          "proteins_100g"]
              ?.toString()

              ??

              "0",

        ) ??

            0,

        sodium:

        (
            double.tryParse(

              product[
              "nutriments"]
              [
              "salt_100g"]
                  ?.toString()

                  ??

                  "0",

            )

                ??

                0

        )

            *

            1000,

      );

    }

    catch (e) {

      print(
          e.toString());

      return null;

    }

  }
}