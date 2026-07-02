import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/stock_model.dart';
import '../../services/stock_service.dart';

const _kGreen800 = Color(0xFF2E7D32);
const _kGreen600 = Color(0xFF43A047);
const _kGreen100 = Color(0xFFE8F5E9);
const _kGreen50 = Color(0xFFF1F8F1);

class AddStockScreen extends StatefulWidget {
  const AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedUnit = 'kg';
  String _selectedQuality = 'A';
  DateTime _harvestDate = DateTime.now();
  bool _saving = false;

  final _units = ['kg', 'Quintal', 'Tonne'];
  final _qualities = ['A', 'B', 'C'];

  final _cropSuggestions = [
    'Paddy', 'Wheat', 'Maize', 'Sugarcane', 'Cotton',
    'Soybean', 'Groundnut', 'Sunflower', 'Tomato', 'Onion',
    'Potato', 'Banana', 'Coconut', 'Turmeric', 'Chilli',
  ];

  @override
  void dispose() {
    _cropController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _harvestDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _kGreen800),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _harvestDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final item = StockItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cropName: _cropController.text.trim(),
      quantity: double.parse(_quantityController.text.trim()),
      unit: _selectedUnit,
      pricePerUnit: double.parse(_priceController.text.trim()),
      quality: _selectedQuality,
      harvestDate: _harvestDate,
      addedAt: DateTime.now(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    try {
      await StockService().add(item);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Stock added successfully!'),
            ],
          ),
          backgroundColor: _kGreen600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _dec(String label, {String? hint, IconData? icon}) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: icon != null ? Icon(icon, color: _kGreen800, size: 20) : null,
    filled: true,
    fillColor: _kGreen50,
    labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: _kGreen600, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: _kGreen800,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Add Stock', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // ── HEADER CARD ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_kGreen800, _kGreen600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('New Stock Entry',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                        SizedBox(height: 2),
                        Text('Record your harvested crop stock',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _sectionLabel('Crop Details'),
            const SizedBox(height: 12),

            // ── CROP NAME WITH SUGGESTIONS ───────────────
            Autocomplete<String>(
              optionsBuilder: (v) => v.text.isEmpty
                  ? const []
                  : _cropSuggestions.where(
                      (c) => c.toLowerCase().contains(v.text.toLowerCase())),
              onSelected: (val) => _cropController.text = val,
              fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) {
                _cropController.addListener(() {
                  if (ctrl.text != _cropController.text) {
                    ctrl.text = _cropController.text;
                  }
                });
                return TextFormField(
                  controller: ctrl,
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.words,
                  decoration: _dec('Crop Name', hint: 'e.g. Paddy, Wheat', icon: Icons.grass_outlined),
                  validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Crop name is required' : null,
                  onChanged: (val) => _cropController.text = val,
                );
              },
            ),

            const SizedBox(height: 14),

            // ── QUANTITY + UNIT ───────────────────────────
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    decoration: _dec('Quantity', icon: Icons.scale_outlined),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (double.tryParse(v) == null || double.parse(v) <= 0) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _kGreen50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedUnit,
                        isExpanded: true,
                        items: _units
                            .map((u) => DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedUnit = v!),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── PRICE PER UNIT ────────────────────────────
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: _dec('Price per ${_selectedUnit} (₹)', icon: Icons.currency_rupee),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Price is required';
                if (double.tryParse(v) == null || double.parse(v) <= 0) {
                  return 'Enter a valid price';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),
            _sectionLabel('Quality & Date'),
            const SizedBox(height: 12),

            // ── QUALITY GRADE ─────────────────────────────
            Row(
              children: _qualities.map((q) {
                final selected = q == _selectedQuality;
                final gradeColors = {
                  'A': const Color(0xFF1B5E20),
                  'B': const Color(0xFFF57F17),
                  'C': const Color(0xFFB71C1C),
                };
                final gradeLabels = {
                  'A': 'Premium Quality',
                  'B': 'Good Quality',
                  'C': 'Standard Quality',
                };
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: q != 'C' ? 10 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedQuality = q),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected ? gradeColors[q]! : _kGreen50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? gradeColors[q]! : Colors.grey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Grade $q',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: selected ? Colors.white : Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gradeLabels[q]!,
                              style: TextStyle(
                                fontSize: 9,
                                color: selected ? Colors.white70 : Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // ── HARVEST DATE ──────────────────────────────
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                decoration: BoxDecoration(
                  color: _kGreen50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: _kGreen800, size: 20),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harvest Date',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('MMMM dd, yyyy').format(_harvestDate),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _sectionLabel('Additional Info (Optional)'),
            const SizedBox(height: 12),

            // ── NOTES ─────────────────────────────────────
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: _dec('Notes', hint: 'Storage location, moisture level, buyer details...', icon: Icons.notes_outlined),
            ),

            const SizedBox(height: 14),

            // ── LIVE TOTAL VALUE PREVIEW ──────────────────
            if (_quantityController.text.isNotEmpty && _priceController.text.isNotEmpty)
              _TotalPreview(
                quantity: double.tryParse(_quantityController.text) ?? 0,
                price: double.tryParse(_priceController.text) ?? 0,
                unit: _selectedUnit,
              ),

            const SizedBox(height: 28),

            // ── SAVE BUTTON ───────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGreen800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, size: 20),
                    SizedBox(width: 8),
                    Text('Add to Stock',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: _kGreen800,
      letterSpacing: 0.3,
    ),
  );
}

// ── LIVE TOTAL PREVIEW ──────────────────────────
class _TotalPreview extends StatelessWidget {
  final double quantity;
  final double price;
  final String unit;
  const _TotalPreview({required this.quantity, required this.price, required this.unit});

  @override
  Widget build(BuildContext context) {
    final total = quantity * price;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kGreen100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kGreen600.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Estimated Total Value',
                  style: TextStyle(fontSize: 12, color: _kGreen800, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('${quantity.toStringAsFixed(1)} $unit × ₹${price.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ],
          ),
          Text(
            '₹${total.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _kGreen800,
            ),
          ),
        ],
      ),
    );
  }
}