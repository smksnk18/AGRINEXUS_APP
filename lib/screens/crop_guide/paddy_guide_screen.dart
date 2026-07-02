import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:agrinexus/models/crop_models.dart';
import '../../paddy_guide_controller.dart';
import '../../services/groq_service.dart';
import '../../services/weather_service.dart';
import '../../services/location_service.dart';
import '../../models/weather_model.dart';

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
const _kGreen900 = Color(0xFF1B5E20);
const _kGreen800 = Color(0xFF2E7D32);
const _kGreen600 = Color(0xFF43A047);
const _kGreen100 = Color(0xFFE8F5E9);
const _kGreen50  = Color(0xFFF1F8F1);
const _kAmber    = Color(0xFFFFA000);
const _kSurface  = Color(0xFFF7F8FA);
const _kCard     = Colors.white;

class PaddyGuideScreen extends StatefulWidget {
  const PaddyGuideScreen({super.key});
  @override
  State<PaddyGuideScreen> createState() => _PaddyGuideScreenState();
}

class _PaddyGuideScreenState extends State<PaddyGuideScreen> {
  DateTime? plantingDate;
  WeatherModel? weather;
  String? aiAdvice;
  bool aiLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PaddyGuideController>(context, listen: false).loadInitialStates();
      _loadWeather();
    });
  }

  Future<void> _loadWeather() async {
    try {
      final pos = await LocationService().getCurrentLocation();
      final data = await WeatherService().getWeather(pos.latitude, pos.longitude);
      if (mounted) setState(() => weather = data);
    } catch (_) {}
  }

  String _growthStage(DateTime planting) {
    final days = DateTime.now().difference(planting).inDays;
    if (days <= 20) return "Nursery";
    if (days <= 45) return "Tillering";
    if (days <= 75) return "Flowering";
    return "Maturity";
  }

  Future<void> _loadAiAdvice() async {
    final ctrl = Provider.of<PaddyGuideController>(context, listen: false);
    if (plantingDate == null || ctrl.selectedVariety == null) return;
    setState(() { aiLoading = true; aiAdvice = null; });
    try {
      final result = await GroqService().predictDisease(
        variety: ctrl.selectedVariety!.name,
        temperature: weather?.temperature ?? 30,
        humidity: weather?.humidity ?? 80,
        growthStage: _growthStage(plantingDate!),
      );
      if (mounted) setState(() { aiAdvice = result; aiLoading = false; });
    } catch (e) {
      if (mounted) setState(() { aiAdvice = "Unable to fetch AI advice: $e"; aiLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Provider.of<PaddyGuideController>(context);
    final variety = ctrl.selectedVariety;
    final days = plantingDate != null
        ? DateTime.now().difference(plantingDate!).inDays
        : null;

    return Scaffold(
      backgroundColor: _kSurface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── FLEXIBLE RESILIENT HEADER ─────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 140,
                backgroundColor: _kGreen900,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_kGreen900, _kGreen800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.agriculture, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'AGRINEXUS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 22),
                                  onPressed: () {},
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('TN',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              'Paddy Crop Guide',
                              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Smart crop planning and advisory',
                              style: TextStyle(color: Colors.white60, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      // ── WEATHER STRIP ─────────────────────────────
                      if (weather != null) _WeatherStrip(weather: weather!),

                      // ── REGIONAL SELECTION ────────────────────────
                      _SectionCard(
                        title: 'Regional Selection Matrix',
                        icon: Icons.map_outlined,
                        child: _RegionalSelector(ctrl: ctrl),
                      ),

                      // ── PLANTING DATE ─────────────────────────────
                      _SectionCard(
                        title: 'Planting Date',
                        icon: Icons.calendar_today_outlined,
                        child: _PlantingDatePicker(
                          date: plantingDate,
                          onPicked: (d) => setState(() => plantingDate = d),
                        ),
                      ),

                      // ── VARIETY PICKER ────────────────────────────
                      if (ctrl.availableVarieties.isNotEmpty)
                        _SectionCard(
                          title: 'Select Variety',
                          icon: Icons.grass_outlined,
                          child: _VarietyChips(ctrl: ctrl),
                        ),

                      // ── CROP AGE PROGRESS ─────────────────────────
                      if (plantingDate != null && variety != null)
                        _SectionCard(
                          title: 'Crop Progress',
                          icon: Icons.show_chart,
                          child: _CropAgeProgress(
                            days: days!,
                            durationDays: variety.durationDays,
                          ),
                        ),

                      // ── VARIETY PROFILE ───────────────────────────
                      if (variety != null)
                        _SectionCard(
                          title: 'Variety Profile: ${variety.name}',
                          icon: Icons.info_outline,
                          child: _VarietyProfile(variety: variety),
                        ),

                      // ── SMART CROP CALENDAR ───────────────────────
                      if (plantingDate != null && variety != null)
                        _SectionCard(
                          title: 'Smart Crop Calendar',
                          icon: Icons.calendar_month_outlined,
                          child: _SmartCropCalendar(
                            plantingDate: plantingDate!,
                            variety: variety,
                            currentDays: days!,
                          ),
                        ),

                      // ── FERTILIZER SCHEDULE ───────────────────────
                      if (variety != null && variety.fertilizerSchedule.isNotEmpty)
                        _SectionCard(
                          title: 'Fertilizer Schedule',
                          icon: Icons.science_outlined,
                          child: _FertilizerSchedule(schedule: variety.fertilizerSchedule),
                        ),

                      // ── AI ADVISOR ────────────────────────────────
                      if (variety != null && plantingDate != null)
                        _AiAdvisorCard(
                          advice: aiAdvice,
                          loading: aiLoading,
                          onTap: _loadAiAdvice,
                        ),

                      // ── HARVEST OUTLOOK ───────────────────────────
                      if (plantingDate != null && variety != null)
                        _SectionCard(
                          title: 'Harvest Outlook',
                          icon: Icons.agriculture_outlined,
                          child: _HarvestOutlook(
                            plantingDate: plantingDate!,
                            variety: variety,
                            days: days!,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Loading overlay
          if (ctrl.isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: _kGreen600),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WEATHER STRIP
// ─────────────────────────────────────────────
class _WeatherStrip extends StatelessWidget {
  final WeatherModel weather;
  const _WeatherStrip({required this.weather});

  @override
  Widget build(BuildContext context) {
    final isRainy = weather.humidity > 70;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kGreen800, _kGreen600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: _kGreen800.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _WeatherChip(icon: Icons.thermostat, label: '${weather.temperature.toStringAsFixed(0)}°C')),
          Expanded(child: _WeatherChip(icon: Icons.water_drop_outlined, label: '${weather.humidity}%')),
          Expanded(
            flex: 2,
            child: _WeatherChip(
              icon: isRainy ? Icons.water : Icons.wb_sunny_outlined,
              label: isRainy ? 'Rain Expected' : 'Low Rain',
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeatherChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Alignment alignment;
  const _WeatherChip({required this.icon, required this.label, this.alignment = Alignment.centerLeft});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SECTION CARD WRAPPER
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: _kGreen100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _kGreen800, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REGIONAL SELECTOR
// ─────────────────────────────────────────────
class _RegionalSelector extends StatelessWidget {
  final PaddyGuideController ctrl;
  const _RegionalSelector({required this.ctrl});

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(fontSize: 13, color: Colors.grey),
    filled: true,
    fillColor: _kGreen50,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _kGreen600, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<LocationEntity>(
          decoration: _dec('Select State'),
          value: ctrl.selectedState,
          isExpanded: true,
          items: ctrl.states
              .map((s) => DropdownMenuItem(value: s, child: Text(s.name, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: ctrl.selectState,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<LocationEntity>(
          decoration: _dec('District'),
          value: ctrl.selectedDistrict,
          isExpanded: true,
          items: ctrl.districts
              .map((d) => DropdownMenuItem(value: d, child: Text(d.name, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: ctrl.selectedState == null ? null : ctrl.selectDistrict,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<LocationEntity>(
          decoration: _dec('Taluka'),
          value: ctrl.selectedTaluka,
          isExpanded: true,
          items: ctrl.talukas
              .map((t) => DropdownMenuItem(value: t, child: Text(t.name, style: const TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: ctrl.selectedDistrict == null ? null : ctrl.selectTaluka,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  PLANTING DATE PICKER
// ─────────────────────────────────────────────
class _PlantingDatePicker extends StatelessWidget {
  final DateTime? date;
  final ValueChanged<DateTime> onPicked;
  const _PlantingDatePicker({required this.date, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: _kGreen800),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _kGreen50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: date != null ? _kGreen600 : Colors.transparent, width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: date != null ? _kGreen800 : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null
                    ? DateFormat('MMM dd, yyyy').format(date!)
                    : 'Tap to select planting date',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: date != null ? FontWeight.w600 : FontWeight.normal,
                    color: date != null ? const Color(0xFF1A1A1A) : Colors.grey),
              ),
            ),
            if (date != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _kGreen100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${DateTime.now().difference(date!).inDays} Days',
                  style: const TextStyle(color: _kGreen800, fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  VARIETY CHIPS
// ─────────────────────────────────────────────
class _VarietyChips extends StatelessWidget {
  final PaddyGuideController ctrl;
  const _VarietyChips({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ctrl.availableVarieties.map((v) {
        final selected = ctrl.selectedVariety?.id == v.id;
        return GestureDetector(
          onTap: () => ctrl.selectVariety(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _kGreen800 : _kGreen50,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected ? _kGreen800 : Colors.grey.shade200,
                width: 1.5,
              ),
              boxShadow: selected
                  ? [BoxShadow(color: _kGreen800.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 3))]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                ],
                Text(
                  v.name,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF333333),
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  CROP AGE PROGRESS
// ─────────────────────────────────────────────
class _CropAgeProgress extends StatelessWidget {
  final int days;
  final int durationDays;
  const _CropAgeProgress({required this.days, required this.durationDays});

  @override
  Widget build(BuildContext context) {
    final stages = [
      (label: 'Nursery', days: 0),
      (label: 'Transplant', days: 15),
      (label: 'Tillering', days: 30),
      (label: 'Panicle', days: 60),
      (label: 'Harvest', days: durationDays),
    ];

    int currentIdx = 0;
    for (int i = 0; i < stages.length; i++) {
      if (days >= stages[i].days) currentIdx = i;
    }

    final progress = (days / durationDays).clamp(0.0, 1.0);

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 320,
            child: Row(
              children: List.generate(stages.length * 2 - 1, (i) {
                if (i.isOdd) {
                  final stageIdx = i ~/ 2;
                  final done = stageIdx < currentIdx;
                  return Expanded(
                    child: Container(
                      height: 3,
                      color: done ? _kGreen600 : Colors.grey.shade200,
                    ),
                  );
                }
                final stageIdx = i ~/ 2;
                final done = stageIdx < currentIdx;
                final current = stageIdx == currentIdx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: current ? 26 : 20,
                  height: current ? 26 : 20,
                  decoration: BoxDecoration(
                    color: done || current ? _kGreen600 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: current ? [BoxShadow(color: _kGreen600.withOpacity(0.3), blurRadius: 6)] : [],
                  ),
                  child: Icon(
                    done ? Icons.check : (current ? Icons.grass : Icons.circle),
                    color: done || current ? Colors.white : Colors.grey.shade400,
                    size: current ? 14 : 9,
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stages.map((s) => Expanded(
            child: Text(
              s.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          )).toList(),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(_kGreen600),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Day $days', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kGreen800)),
            Text('${(progress * 100).toStringAsFixed(0)}% Complete', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  VARIETY PROFILE
// ─────────────────────────────────────────────
class _VarietyProfile extends StatelessWidget {
  final PaddyVariety variety;
  const _VarietyProfile({required this.variety});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (icon: Icons.category_outlined, label: 'Category', value: 'Fine Grain Paddy'),
      (icon: Icons.wb_sunny_outlined, label: 'Season', value: variety.season),
      (icon: Icons.timer_outlined, label: 'Duration', value: '${variety.durationDays} Days'),
      (icon: Icons.trending_up, label: 'Avg Yield', value: '${variety.avgYield.toStringAsFixed(0)} kg/acre'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (_, i) {
            final s = stats[i];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _kGreen50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(s.icon, color: _kGreen800, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.label, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1),
                        Text(
                          s.value,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (variety.resistances.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Special Features & Resistance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: variety.resistances.map((r) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _kGreen100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: _kGreen800, size: 14),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      r,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kGreen900),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  SMART CROP CALENDAR
// ─────────────────────────────────────────────
class _SmartCropCalendar extends StatelessWidget {
  final DateTime plantingDate;
  final PaddyVariety variety;
  final int currentDays;
  const _SmartCropCalendar({required this.plantingDate, required this.variety, required this.currentDays});

  @override
  Widget build(BuildContext context) {
    final events = [
      (icon: Icons.eco_outlined, label: 'Seed Treatment', dayOffset: -2, note: null),
      (icon: Icons.grass, label: 'Nursery Preparation', dayOffset: 0, note: null),
      (icon: Icons.arrow_upward, label: 'Transplanting', dayOffset: 15, note: null),
      (icon: Icons.science_outlined, label: 'Fertilizer Application 1', dayOffset: 30, note: 'Top dressing - Urea 35kg + Neem Cake'),
      (icon: Icons.grain, label: 'Panicle Initiation', dayOffset: 60, note: null),
      (icon: Icons.science_outlined, label: 'Fertilizer Application 2', dayOffset: 80, note: null),
      (icon: Icons.agriculture, label: 'Harvest', dayOffset: variety.durationDays, note: null),
    ];

    return Column(
      children: events.asMap().entries.map((entry) {
        final i = entry.key;
        final e = entry.value;
        final eventDay = e.dayOffset;
        final done = currentDays > eventDay;
        final isCurrent = !done && (i == 0 || currentDays > events[i - 1].dayOffset);
        final date = plantingDate.add(Duration(days: eventDay));

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: done ? _kGreen600 : isCurrent ? _kAmber : _kGreen50,
                    shape: BoxShape.circle,
                    boxShadow: isCurrent ? [BoxShadow(color: _kAmber.withOpacity(0.3), blurRadius: 6)] : [],
                  ),
                  child: Icon(
                    done ? Icons.check : e.icon,
                    color: done || isCurrent ? Colors.white : Colors.grey.shade400,
                    size: 16,
                  ),
                ),
                if (i < events.length - 1)
                  Container(
                    width: 2,
                    height: 40,
                    color: done ? _kGreen100 : Colors.grey.shade200,
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM dd').format(date).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isCurrent ? _kAmber : Colors.grey.shade500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _kAmber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('CURRENT STAGE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: _kAmber)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      e.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                        color: isCurrent ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
                      ),
                    ),
                    if (e.note != null) ...[
                      const SizedBox(height: 2),
                      Text(e.note!, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────
//  FERTILIZER SCHEDULE
// ─────────────────────────────────────────────
class _FertilizerSchedule extends StatelessWidget {
  final List<String> schedule;
  const _FertilizerSchedule({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final labels = ['Basal Application', 'Top Dressing 1 (Current)', 'Top Dressing 2'];
    final colors = [_kGreen100, const Color(0xFFFFF9C4), _kGreen50];
    final borderColors = [_kGreen600, _kAmber, _kGreen800];

    return Column(
      children: List.generate(schedule.length, (i) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors[i % colors.length],
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: borderColors[i % borderColors.length], width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i < labels.length ? labels[i] : 'Application ${i + 1}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black54, letterSpacing: 0.3),
              ),
              const SizedBox(height: 4),
              Text(schedule[i], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222))),
            ],
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
//  AI ADVISOR CARD
// ─────────────────────────────────────────────
class _AiAdvisorCard extends StatelessWidget {
  final String? advice;
  final bool loading;
  final VoidCallback onTap;
  const _AiAdvisorCard({required this.advice, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_kGreen900, _kGreen800.withOpacity(0.95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: _kGreen900.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Agri-Advisor AI',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!loading)
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        advice == null ? 'Get Advice' : 'Refresh',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2.5))),
              )
            else if (advice != null)
              Text(
                '"$advice"',
                style: const TextStyle(
                  color: Color(0xFFEFEFEF),
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              )
            else
              Text(
                'Tap "Get Advice" for an AI-powered analysis based on your crop\'s current growth stage and weather.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HARVEST OUTLOOK
// ─────────────────────────────────────────────
class _HarvestOutlook extends StatelessWidget {
  final DateTime plantingDate;
  final PaddyVariety variety;
  final int days;
  const _HarvestOutlook({required this.plantingDate, required this.variety, required this.days});

  @override
  Widget build(BuildContext context) {
    final harvestDate = plantingDate.add(Duration(days: variety.durationDays));
    final daysLeft = harvestDate.difference(DateTime.now()).inDays.clamp(0, variety.durationDays);
    final progress = (days / variety.durationDays).clamp(0.0, 1.0);
    final revenue = variety.estimatedRevenue;
    final profit = variety.estimatedProfit;

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(_kGreen600),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _kGreen800),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Estimated: ${DateFormat('MMM dd, yyyy').format(harvestDate)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$daysLeft days remaining',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _OutlookTile(
                label: 'Est. Revenue',
                value: '₹${(revenue / 1000).toStringAsFixed(0)}K',
                icon: Icons.currency_rupee,
                color: _kGreen100,
                textColor: _kGreen900,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _OutlookTile(
                label: 'Est. Profit',
                value: '₹${(profit / 1000).toStringAsFixed(0)}K',
                icon: Icons.trending_up,
                color: const Color(0xFFF0FFF4),
                textColor: const Color(0xFF14532D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _kGreen50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.auto_awesome, color: _kGreen800, size: 14),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'AI Analysis available after harvest',
                  style: TextStyle(fontSize: 12, color: _kGreen800, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutlookTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color textColor;
  const _OutlookTile(
      {required this.label, required this.value, required this.icon, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: TextStyle(fontSize: 9, color: textColor.withOpacity(0.8), fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}