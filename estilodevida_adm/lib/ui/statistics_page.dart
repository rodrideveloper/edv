import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../service/statistics_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StatisticsService _statisticsService = StatisticsService();
  DateTime selectedMonth = DateTime.now();
  DateTime selectedDay = DateTime.now();
  Map<String, dynamic> monthlyData = {};
  Map<String, dynamic> dayData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMonthlyData();
    loadDayData();
  }

  Future<void> loadDayData() async {
    try {
      final data = await _statisticsService.getDayData(selectedDay);
      setState(() {
        dayData = data;
      });
    } catch (e) {
      // Error handled in service with debugPrint
      setState(() {
        dayData = {'totalSelectedDay': 0, 'totalPreviousDay': 0};
      });
    }
  }

  Future<void> loadMonthlyData() async {
    setState(() => isLoading = true);

    try {
      final data = await _statisticsService.getMonthlyData(selectedMonth);
      setState(() {
        monthlyData = data;
        isLoading = false;
      });
    } catch (e) {
      // Error handled in service with debugPrint
      setState(() {
        monthlyData = {
          'dailyLessons': {},
          'totalLessons': 0,
          'previousMonthLessons': 0,
          'activeDays': 0,
          'averagePerActiveDay': 0,
          'bestDay': null,
          'bestDayClasses': 0,
        };
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDaySelector(),
                  const SizedBox(height: 16),
                  _buildDayCard(),
                  const SizedBox(height: 24),
                  _buildSummaryCard(),
                ],
              ),
            ),
    );
  }

  Widget _buildMonthSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  selectedMonth =
                      DateTime(selectedMonth.year, selectedMonth.month - 1);
                });
                loadMonthlyData();
              },
            ),
            Text(
              DateFormat('MMMM yyyy', 'es_ES').format(selectedMonth),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: selectedMonth.isBefore(DateTime.now())
                  ? () {
                      setState(() {
                        selectedMonth = DateTime(
                            selectedMonth.year, selectedMonth.month + 1);
                      });
                      loadMonthlyData();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    final isToday = selectedDay.year == DateTime.now().year &&
        selectedDay.month == DateTime.now().month &&
        selectedDay.day == DateTime.now().day;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  selectedDay = selectedDay.subtract(const Duration(days: 1));
                });
                loadDayData();
              },
            ),
            Column(
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(selectedDay),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isToday)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'HOY',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: isToday
                  ? null
                  : () {
                      setState(() {
                        selectedDay = selectedDay.add(const Duration(days: 1));
                      });
                      loadDayData();
                    },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard() {
    final totalSelectedDay = dayData['totalSelectedDay'] as int? ?? 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Clases del Día Seleccionado',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    totalSelectedDay.toString(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                  ),
                  Text(
                    totalSelectedDay == 1 ? 'clase tomada' : 'clases tomadas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalLessons = monthlyData['totalLessons'] as int? ?? 0;
    final previousMonthLessons =
        monthlyData['previousMonthLessons'] as int? ?? 0;
    final bestDay = monthlyData['bestDay'] as int?;
    final bestDayClasses = monthlyData['bestDayClasses'] as int? ?? 0;

    final difference = totalLessons - previousMonthLessons;
    final isIncrease = difference > 0;

    // Crear la fecha del mejor día en formato dd/MM
    String bestDayFormatted = '';
    if (bestDay != null) {
      final bestDayDate =
          DateTime(selectedMonth.year, selectedMonth.month, bestDay);
      bestDayFormatted = DateFormat('dd/MM').format(bestDayDate);
    }

    return Column(
      children: [
        _buildMonthSelector(),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Resumen del Mes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        totalLessons.toString(),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                      ),
                      Text(
                        totalLessons == 1 ? 'clase tomada' : 'clases tomadas',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[700],
                                ),
                      ),
                    ],
                  ),
                ),
                if (bestDay != null) ...[
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Mejor día: $bestDayFormatted ($bestDayClasses ${bestDayClasses == 1 ? 'clase' : 'clases'})',
                        style: TextStyle(
                          color: Colors.amber[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      difference == 0
                          ? Icons.remove
                          : (isIncrease
                              ? Icons.trending_up
                              : Icons.trending_down),
                      color: difference == 0
                          ? Colors.grey
                          : (isIncrease ? Colors.green : Colors.red),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      difference == 0
                          ? 'Igual que mes anterior ($previousMonthLessons)'
                          : '${isIncrease ? '+' : ''}$difference vs mes anterior ($previousMonthLessons)',
                      style: TextStyle(
                        color: difference == 0
                            ? Colors.grey
                            : (isIncrease ? Colors.green : Colors.red),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
