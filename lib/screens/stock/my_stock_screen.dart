import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/stock_model.dart';
import '../../services/stock_service.dart';
import 'add_stock_screen.dart';

const _kGreen900 = Color(0xFF1B5E20);
const _kGreen800 = Color(0xFF2E7D32);
const _kGreen600 = Color(0xFF43A047);
const _kGreen100 = Color(0xFFE8F5E9);
const _kGreen50  = Color(0xFFF1F8F1);
const _kAmber    = Color(0xFFFFA000);

class MyStockScreen extends StatefulWidget {
  const MyStockScreen({super.key});

  @override
  State<MyStockScreen> createState() => _MyStockScreenState();
}

class _MyStockScreenState extends State<MyStockScreen>
    with SingleTickerProviderStateMixin {
  List<StockItem> _items = [];
  bool _loading = true;
  late TabController _tabController;
  final _service = StockService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadStock();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStock() async {
    setState(() => _loading = true);
    final items = await _service.getAll();
    if (mounted) setState(() { _items = items; _loading = false; });
  }

  List<StockItem> get _available =>
      _items.where((i) => i.status == StockStatus.available || i.status == StockStatus.partialSold).toList();
  List<StockItem> get _sold =>
      _items.where((i) => i.status == StockStatus.sold).toList();

  double get _totalValue => _items.fold(0, (s, i) => s + i.totalValue);
  double get _availableValue => _available.fold(0, (s, i) => s + i.remainingValue);
  double get _soldValue => _sold.fold(0, (s, i) => s + i.soldValue);

  Future<void> _deleteItem(StockItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Stock'),
        content: Text('Remove "${item.cropName}" from your stock?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _service.delete(item.id);
      _loadStock();
    }
  }

  Future<void> _markSold(StockItem item) async {
    final ctrl = TextEditingController(text: item.availableQuantity.toStringAsFixed(1));
    final qty = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mark ${item.cropName} as Sold'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available: ${item.availableQuantity.toStringAsFixed(1)} ${item.unit}',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: InputDecoration(
                labelText: 'Quantity sold (${item.unit})',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _kGreen600, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _kGreen800, foregroundColor: Colors.white),
            onPressed: () {
              final val = double.tryParse(ctrl.text);
              if (val != null && val > 0 && val <= item.availableQuantity) {
                Navigator.pop(ctx, val);
              }
            },
            child: const Text('Confirm Sale'),
          ),
        ],
      ),
    );

    if (qty != null) {
      final newSold = item.soldQuantity + qty;
      final newStatus = newSold >= item.quantity ? StockStatus.sold : StockStatus.partialSold;
      await _service.update(item.copyWith(soldQuantity: newSold, status: newStatus));
      _loadStock();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: _kGreen800,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Stock', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadStock,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'All (${_items.length})'),
            Tab(text: 'Available (${_available.length})'),
            Tab(text: 'Sold (${_sold.length})'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _kGreen800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Stock', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddStockScreen()),
          );
          if (result == true) _loadStock();
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _kGreen600))
          : Column(
        children: [
          // ── SUMMARY BANNER ─────────────────────────
          _SummaryBanner(
            totalValue: _totalValue,
            availableValue: _availableValue,
            soldValue: _soldValue,
            itemCount: _items.length,
          ),

          // ── TAB CONTENT ────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _StockList(items: _items, onDelete: _deleteItem, onSell: _markSold),
                _StockList(items: _available, onDelete: _deleteItem, onSell: _markSold),
                _StockList(items: _sold, onDelete: _deleteItem, onSell: _markSold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── SUMMARY BANNER ───────────────────────────────
class _SummaryBanner extends StatelessWidget {
  final double totalValue;
  final double availableValue;
  final double soldValue;
  final int itemCount;
  const _SummaryBanner({
    required this.totalValue,
    required this.availableValue,
    required this.soldValue,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kGreen900, _kGreen800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: _kGreen900.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Portfolio Overview',
              style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            '₹${_fmt(totalValue)}',
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          Text(
            '$itemCount crop stock entries',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'Available',
                  value: '₹${_fmt(availableValue)}',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.white24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatChip(
                  label: 'Sold',
                  value: '₹${_fmt(soldValue)}',
                  icon: Icons.sell_outlined,
                  color: Colors.white24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double val) {
    if (val >= 100000) return '${(val / 100000).toStringAsFixed(1)}L';
    if (val >= 1000) return '${(val / 1000).toStringAsFixed(1)}K';
    return val.toStringAsFixed(0);
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── STOCK LIST ────────────────────────────────────
class _StockList extends StatelessWidget {
  final List<StockItem> items;
  final Future<void> Function(StockItem) onDelete;
  final Future<void> Function(StockItem) onSell;
  const _StockList({required this.items, required this.onDelete, required this.onSell});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('No stock entries yet',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text('Tap "Add Stock" to record your harvest',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: items.length,
      itemBuilder: (_, i) => _StockCard(
        item: items[i],
        onDelete: () => onDelete(items[i]),
        onSell: () => onSell(items[i]),
      ),
    );
  }
}

// ── STOCK CARD ────────────────────────────────────
class _StockCard extends StatelessWidget {
  final StockItem item;
  final VoidCallback onDelete;
  final VoidCallback onSell;
  const _StockCard({required this.item, required this.onDelete, required this.onSell});

  Color get _statusColor {
    switch (item.status) {
      case StockStatus.available:   return _kGreen600;
      case StockStatus.partialSold: return _kAmber;
      case StockStatus.sold:        return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (item.status) {
      case StockStatus.available:   return 'Available';
      case StockStatus.partialSold: return 'Partial Sold';
      case StockStatus.sold:        return 'Sold Out';
    }
  }

  Color get _gradeColor {
    switch (item.quality) {
      case 'A': return _kGreen900;
      case 'B': return _kAmber;
      default:  return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final soldPct = item.quantity > 0 ? item.soldQuantity / item.quantity : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // ── TOP ROW ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Crop icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _kGreen100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.grass_outlined, color: _kGreen800, size: 24),
                ),
                const SizedBox(width: 12),

                // Name + date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.cropName,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(
                        'Harvested: ${DateFormat('MMM dd, yyyy').format(item.harvestDate)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_statusLabel,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _statusColor)),
                ),
              ],
            ),
          ),

          // ── DIVIDER ──────────────────────────────
          Divider(height: 1, color: Colors.grey.shade100),

          // ── STATS ROW ────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _Stat(label: 'Total', value: '${item.quantity.toStringAsFixed(1)} ${item.unit}'),
                _StatDivider(),
                _Stat(label: 'Available', value: '${item.availableQuantity.toStringAsFixed(1)} ${item.unit}'),
                _StatDivider(),
                _Stat(
                  label: 'Rate',
                  value: '₹${item.pricePerUnit.toStringAsFixed(0)}/${item.unit}',
                ),
                _StatDivider(),
                _Stat(
                  label: 'Grade',
                  value: 'A${item.quality}',
                  valueColor: _gradeColor,
                ),
              ],
            ),
          ),

          // ── PROGRESS BAR (sold %) ─────────────────
          if (item.soldQuantity > 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sold Progress',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      Text('${(soldPct * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kGreen800)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: soldPct.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          item.status == StockStatus.sold ? Colors.grey : _kGreen600),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── TOTAL VALUE ───────────────────────────
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _kGreen50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Remaining Value',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text(
                  '₹${item.remainingValue.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: _kGreen800),
                ),
              ],
            ),
          ),

          // ── ACTION BUTTONS ────────────────────────
          if (item.status != StockStatus.sold)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Remove'),
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.sell_outlined, size: 16),
                      label: const Text('Mark as Sold'),
                      onPressed: onSell,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kGreen800,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove Entry'),
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),

          if (item.notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.notes_outlined, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(item.notes!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Stat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          const SizedBox(height: 2),
          Text(value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: Colors.grey.shade100,
  );
}