import 'package:shared_preferences/shared_preferences.dart';
import '../models/stock_model.dart';

class StockService {
  static const _key = 'agrinexus_stock_items';

  Future<List<StockItem>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return StockItem.listFromJson(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> add(StockItem item) async {
    final items = await getAll();
    items.insert(0, item);
    await _save(items);
  }

  Future<void> update(StockItem updated) async {
    final items = await getAll();
    final idx = items.indexWhere((i) => i.id == updated.id);
    if (idx != -1) {
      items[idx] = updated;
      await _save(items);
    }
  }

  Future<void> delete(String id) async {
    final items = await getAll();
    items.removeWhere((i) => i.id == id);
    await _save(items);
  }

  Future<void> _save(List<StockItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, StockItem.listToJson(items));
  }
}