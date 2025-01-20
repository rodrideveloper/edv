import 'package:estilodevida/ui/constants.dart';
import 'package:estilodevida/ui/lessons_avalibles.dart';
import 'package:estilodevida/ui/widgets/common_appbar.dart';
import 'package:estilodevida/ui/widgets/common_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedLessons extends StatefulWidget {
  const SelectedLessons({super.key});

  @override
  State<SelectedLessons> createState() => _SelectedLessonsState();
}

class _SelectedLessonsState extends State<SelectedLessons> {
  Future<void> showSingleSelectionDialog() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        // Controlar el valor seleccionado con un StatefulBuilder
        LessonsAvaliblesEnum? selectedLesson;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.white, width: 0),
              ),
              title: const Text(
                'Seleccionar clase',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<LessonsAvaliblesEnum>(
                    title: const Text('Salsa on 1'),
                    value: LessonsAvaliblesEnum.salsa1,
                    groupValue: selectedLesson,
                    onChanged: (value) {
                      setState(() => selectedLesson = value);
                    },
                  ),
                  RadioListTile<LessonsAvaliblesEnum>(
                    title: const Text('Salsa on 2'),
                    value: LessonsAvaliblesEnum.salsa2,
                    groupValue: selectedLesson,
                    onChanged: (value) {
                      setState(() => selectedLesson = value);
                    },
                  ),
                  RadioListTile<LessonsAvaliblesEnum>(
                    title: const Text('Bachata'),
                    value: LessonsAvaliblesEnum.bachata,
                    groupValue: selectedLesson,
                    onChanged: (value) {
                      setState(() => selectedLesson = value);
                    },
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
                  label: Text(
                    'Cancelar',
                    style: GoogleFonts.roboto(
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
                  label: Text(
                    'Continar',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    if (selectedLesson == null) {
                      return;
                    }
                    Navigator.of(context).pop();
                    GoRouter.of(context)
                        .push('/register', extra: selectedLesson);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        showSingleSelectionDialog();
      },
    );

    super.initState();
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
            child: const SizedBox(
              width: 30,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }
}
