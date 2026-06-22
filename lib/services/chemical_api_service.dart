import 'dart:convert';
import 'package:http/http.dart' as http;

class ChemicalApiService {

  static Future<String> getChemicalInfo(
      String ingredient) async {

    try {

      final response = await http.get(

        Uri.parse(
          "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/$ingredient/synonyms/JSON",
        ),

      );

      if (response.statusCode != 200) {

        return "No information found.";

      }

      final data =
      jsonDecode(
        response.body,
      );

      List synonyms =
      data["InformationList"]
      ["Information"][0]
      ["Synonym"];

      return synonyms
          .take(10)
          .join(", ");

    }

    catch (e) {

      print(e);

      return "No information found.";

    }

  }

}