import 'package:estilodevida/models/user/user_model.dart';
import 'package:estilodevida/models/user_pack/user_pack.dart';
import 'package:estilodevida/services/user_pack_service.dart/user_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LessonRemains extends StatelessWidget {
  const LessonRemains({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<UserPackModel?>(
      stream: UserPackService().getActivePackStream(user!.id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }

        final activePack = snapshot.data;
        // Variables para ambos casos
        final int remainingLessons = activePack?.totalLessons != null
            ? (activePack!.totalLessons - (activePack.usedLessons ?? 0))
            : 0;
        final double percent = activePack?.totalLessons != null &&
                activePack!.totalLessons > 0
            ? remainingLessons.toDouble() / activePack.totalLessons.toDouble()
            : 0.0;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircularPercentIndicator
              CircularPercentIndicator(
                arcType: ArcType.FULL,
                backgroundColor: Colors.grey.shade800,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                radius: 160.0,
                lineWidth: 15.0,
                percent: percent.clamp(0.0, 1.0),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$remainingLessons',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 70,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.white,
                      ),
                    ),
                    Text(
                      'Clases Restantes',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    activePack != null
                        ? Text(
                            'Vence el: ${DateFormat('dd/MM/yyyy').format(activePack.dueDate)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'No tienes packs activos',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
                progressColor: Colors.white,
                arcBackgroundColor: const Color(0xff800080),
              ),
            ],
          ),
        );
      },
    );
  }
}
