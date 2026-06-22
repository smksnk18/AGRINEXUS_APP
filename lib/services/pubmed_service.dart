import 'dart:convert';
import 'package:http/http.dart' as http;

class PubMedService {

  static Future<String> getEvidence(
      String ingredient) async {

    try {

      final searchResponse =
      await http.get(

        Uri.parse(
          "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmax=3&term=$ingredient&retmode=json",
        ),

      );

      if (
      searchResponse.statusCode != 200
      ) {

        return "";

      }

      final searchData =
      jsonDecode(
        searchResponse.body,
      );

      List ids =
      searchData["esearchresult"]
      ["idlist"];

      if (
      ids.isEmpty
      ) {

        return "";

      }

      final summaryResponse =
      await http.get(

        Uri.parse(
          "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id=${ids.join(",")}&retmode=json",
        ),

      );

      if (
      summaryResponse.statusCode != 200
      ) {

        return "";

      }

      final summaryData =
      jsonDecode(
        summaryResponse.body,
      );

      String result = "";

      for (
      String id
      in ids
      ) {

        result +=
        "${summaryData["result"][id]["title"]}\n";

      }

      return result;

    }

    catch (e) {

      print(
        e.toString(),
      );

      return "";

    }

  }

}