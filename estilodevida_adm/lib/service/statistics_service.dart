import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StatisticsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Carga los datos estadísticos del mes seleccionado
  Future<Map<String, dynamic>> getMonthlyData(DateTime selectedMonth) async {
    try {
      final startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
      final endOfMonth =
          DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

      // Cargar datos de clases tomadas del mes seleccionado
      final lessonsQuery = await _db
          .collection('register_lessons')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
          .get();

      // Procesar datos diarios
      Map<int, int> dailyLessons = {};

      for (var doc in lessonsQuery.docs) {
        final data = doc.data();

        if (data.containsKey('date')) {
          final timestamp = (data['date'] as Timestamp).toDate();
          final day = timestamp.day;
          dailyLessons[day] = (dailyLessons[day] ?? 0) + 1;
        }
      }

      // Encontrar el día con más clases
      int? bestDay;
      int maxClasses = 0;
      dailyLessons.forEach((day, classes) {
        if (classes > maxClasses) {
          maxClasses = classes;
          bestDay = day;
        }
      });

      // Cargar datos del mes anterior para comparación
      final prevMonth =
          DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
      final endPrevMonth = DateTime(selectedMonth.year, selectedMonth.month, 0);

      final prevLessonsQuery = await _db
          .collection('register_lessons')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(prevMonth))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endPrevMonth))
          .get();

      return {
        'dailyLessons': dailyLessons,
        'totalLessons': lessonsQuery.docs.length,
        'previousMonthLessons': prevLessonsQuery.docs.length,
        'activeDays': dailyLessons.length,
        'averagePerActiveDay': dailyLessons.isEmpty
            ? 0
            : (lessonsQuery.docs.length / dailyLessons.length).round(),
        'bestDay': bestDay,
        'bestDayClasses': maxClasses,
      };
    } catch (e) {
      debugPrint('Error loading monthly data: $e');
      throw Exception('Error loading monthly statistics: $e');
    }
  }

  /// Carga los datos estadísticos del día seleccionado
  Future<Map<String, dynamic>> getDayData(DateTime selectedDay) async {
    try {
      final selectedDayStart =
          DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
      final selectedDayEnd = DateTime(
          selectedDay.year, selectedDay.month, selectedDay.day, 23, 59, 59);

      final dayLessonsQuery = await _db
          .collection('register_lessons')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(selectedDayStart))
          .where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(selectedDayEnd))
          .get();

      // Obtener datos del día anterior para comparación
      final previousDay = selectedDay.subtract(const Duration(days: 1));
      final previousDayStart =
          DateTime(previousDay.year, previousDay.month, previousDay.day);
      final previousDayEnd = DateTime(
          previousDay.year, previousDay.month, previousDay.day, 23, 59, 59);

      final previousDayLessonsQuery = await _db
          .collection('register_lessons')
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(previousDayStart))
          .where('date',
              isLessThanOrEqualTo: Timestamp.fromDate(previousDayEnd))
          .get();

      return {
        'totalSelectedDay': dayLessonsQuery.docs.length,
        'totalPreviousDay': previousDayLessonsQuery.docs.length,
      };
    } catch (e) {
      debugPrint('Error loading day data: $e');
      throw Exception('Error loading daily statistics: $e');
    }
  }
}
