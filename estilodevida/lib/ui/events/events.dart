import 'package:estilodevida/models/user_pack/user_pack.dart';
import 'package:estilodevida/services/user_pack_service.dart/user_pack_service.dart';
import 'package:estilodevida/ui/common_button.dart';
import 'package:estilodevida/ui/user_pack/user_pack_card.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final theme = Theme.of(context);
    if (user == null) {
      return const CircularProgressIndicator();
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Eventos',
      ),
      body: CommonBackgroundContainer(
        child: StreamBuilder<List<UserPackModel>>(
          stream: UserPackService().getUserPacksStream(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los packs'));
            }
            var packs = snapshot.data ?? [];
            if (packs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No tienes packs',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton(
                        hasBorder: true,
                        onPress: () => GoRouter.of(context).push('/buypack'),
                        title: const Text('Comprar Pack'),
                      ),
                    ],
                  ),
                ),
              );
            }

            UserPackModel? activePack;
            final now = DateTime.now();
            final availablePacks = packs.where((pack) {
              final isNotExpired = pack.dueDate.isAfter(now);
              final remainingLessons =
                  pack.totalLessons - (pack.usedLessons ?? 0);
              final hasAvailableClasses = remainingLessons > 0;
              return isNotExpired && hasAvailableClasses;
            }).toList();

            if (availablePacks.isNotEmpty) {
              availablePacks.sort((a, b) => a.buyDate.compareTo(b.buyDate));
              activePack = availablePacks.first;
            }

            packs.sort((a, b) {
              if (a == activePack) return -1;
              if (b == activePack) return 1;
              if (a.dueDate.isAfter(b.dueDate)) return -1;
              if (a.dueDate.isBefore(b.dueDate)) return 1;
              return 0;
            });

            return ListView.builder(
              itemCount: packs.length,
              itemBuilder: (context, index) {
                final pack = packs[index];
                return UserPackCard(
                  pack: pack,
                  isActivePack: pack == activePack,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
