// file: lib/ui/manual_pay_admin_screen.dart
import 'package:estilodevida_adm/model/manual_pay/manual_pay.dart';
import 'package:estilodevida_adm/model/pack/pack_model.dart';
import 'package:estilodevida_adm/service/manual_pay_service.dart';
import 'package:estilodevida_adm/service/pack_service.dart';
import 'package:estilodevida_adm/ui/utils.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class ManualPayAdminScreen extends StatefulWidget {
  const ManualPayAdminScreen({super.key});

  @override
  State<ManualPayAdminScreen> createState() => _ManualPayAdminScreenState();
}

class _ManualPayAdminScreenState extends State<ManualPayAdminScreen> {
  final ManualPayService _manualPayService = ManualPayService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos Manuales Pendientes'),
        backgroundColor: purple,
      ),
      body: StreamBuilder<List<ManualPayModel>>(
        stream: _manualPayService.getPendingManualPays(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: blue),
            );
          }
          final pendingList = snapshot.data!;
          if (pendingList.isEmpty) {
            return const Center(
              child: Text(
                'No hay pagos manuales pendientes.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            itemCount: pendingList.length,
            itemBuilder: (context, index) {
              final item = pendingList[index];
              // Formatear fecha usando intl
              final dateFormatted =
                  DateFormat('dd/MM/yyyy HH:mm').format(item.date);

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: blue, width: 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      item.packName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Usuario: ${item.userName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          'Fecha: $dateFormatted',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Ejecuta la función allowNow
                              allowNow(item);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              'Acreditar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _manualPayService.deleteManualPay(item.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Función que se ejecuta cuando el usuario hace "tap" (clic) en el botón "Acreditar"
  void allowNow(ManualPayModel manualPay) async {
    try {
      PackModel? pack = await PackService().getPackById(manualPay.packId);
      if (pack == null) {
        throw 'Pack no existe en metodo de pago manual, packid: ${manualPay.id}';
      }
      await _manualPayService.allowNow(
        manualPayId: manualPay.id,
        pack: pack,
        userId: manualPay.userId,
        userName: manualPay.userName,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Pago manual de ${manualPay.userName} acreditado correctamente.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al acreditar el pago: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
