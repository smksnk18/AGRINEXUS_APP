import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/market/market_item_model.dart';
class ApiService {
  static const String apiUrl =
      'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=579b464db66ec23bdd000001fc5953c296f0429462002ca747d0f590&format=json&limit=1000';

  Future<List<MarketItem>> fetchMarketPrices() async {
    print("API CALLED");
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List records =
            data['records'] ?? [];
        print(data['records'].length);
        return records
            .map(
              (item) =>
              MarketItem.fromJson(item),
        )
            .toList();
      } else {
        throw Exception(
          'Failed to load market data',
        );
      }
    } catch (e) {
      throw Exception(
        'Error fetching data: $e',
      );
    }
  }
}