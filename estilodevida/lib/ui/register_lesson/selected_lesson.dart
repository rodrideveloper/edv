import 'package:estilodevida/ui/lessons_avalibles.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';

class SelectedLessons extends StatefulWidget {
  const SelectedLessons({super.key});

  @override
  State<SelectedLessons> createState() => _SelectedLessonsState();
}

class _SelectedLessonsState extends State<SelectedLessons> {
  @override
  void initState() {
    super.initState();
    // Llamamos al diálogo tras montarse la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSingleSelectionDialog();
    });
  }

  /// Diálogo para seleccionar una clase.
  Future<void> _showSingleSelectionDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          // Control local del valor seleccionado y del mensaje de error
          LessonsAvaliblesEnum? selectedLesson;
          String? errorMessage;

          return StatefulBuilder(builder: (context, setDialogState) {
            /// Función para validar la selección antes de continuar
            void validateSelectionAndContinue() {
              if (selectedLesson == null) {
                setDialogState(() {
                  errorMessage = 'Selecciona una clase antes de continuar.';
                });
                return;
              }
              // Si hay selección, cerramos el diálogo y navegamos
              Navigator.of(context).pop();
              GoRouter.of(context).pushReplacement(
                '/register',
                extra: selectedLesson,
              );
            }

            return AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 0),
              ),
              title: const Text(
                'Seleccionar clase',
                textAlign: TextAlign.center,
              ),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SegmentedButton en vertical y rectangular
                  SegmentedButton<LessonsAvaliblesEnum>(
                    // Disposición vertical
                    direction: Axis.vertical,

                    // Tus opciones
                    segments: const [
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.salsa1,
                        label: Text('Salsa on 1'),
                      ),
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.salsa2,
                        label: Text('Salsa on 2'),
                      ),
                      ButtonSegment(
                        value: LessonsAvaliblesEnum.bachata,
                        label: Text('Bachata'),
                      ),
                    ],

                    // Permitir empezar sin selección
                    // (si prefieres que nunca puedan deseleccionar todo, pon 'false')
                    emptySelectionAllowed: true,

                    // Configura el estilo para quitar esquinas redondeadas, etc.
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),

                    // Si no hay nada seleccionado => set vacío, de lo contrario set con la selección actual
                    selected: selectedLesson == null
                        ? <LessonsAvaliblesEnum>{}
                        : <LessonsAvaliblesEnum>{selectedLesson!},
                    onSelectionChanged:
                        (Set<LessonsAvaliblesEnum> newSelection) {
                      setDialogState(() {
                        if (newSelection.isEmpty) {
                          selectedLesson = null;
                        } else {
                          selectedLesson = newSelection.first;
                        }
                        // Limpiamos el mensaje de error cuando seleccionan algo
                        errorMessage = null;
                      });
                    },
                    multiSelectionEnabled: false,
                  ),

                  const SizedBox(height: 12),

                  // Mostrar mensaje de error si hace falta
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
              actions: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: validateSelectionAndContinue,
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final sizeMedia = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(title: 'Seleccionar clase'),
      body: CommonBackgroundContainer(
        child: SizedBox(
          width: sizeMedia.width,
          height: sizeMedia.height,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
