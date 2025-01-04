import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
import 'package:estilodevida_adm/service/register_lesson_service.dart';
import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
import 'package:estilodevida_adm/service/register_lesson_service.dart';
import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';

class RegisterLessonListScreen extends StatefulWidget {
  const RegisterLessonListScreen({super.key});

  @override
  _RegisterLessonListScreenState createState() =>
      _RegisterLessonListScreenState();
}

class _RegisterLessonListScreenState extends State<RegisterLessonListScreen> {
  final RegisterLessonService _service = RegisterLessonService();

  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  final FocusNode _focusNode = FocusNode();

  // Nuevo: Variable para el filtro de "Clases de hoy"
  bool _filterToday = false;

  // Función para seleccionar fecha
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Si la fecha de inicio es posterior a la fecha final, ajusta la fecha final
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          // Si la fecha final es anterior a la fecha de inicio, ajusta la fecha de inicio
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  // Función para limpiar filtros
  void _clearFilters() {
    setState(() {
      _nameController.clear();
      _startDate = null;
      _endDate = null;
      _filterToday = false; // Limpia el filtro de hoy
    });
  }

  // Función para aplicar filtros
  void _applyFilters() {
    setState(() {});
  }

  // Manejador de eventos de teclado
  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _applyFilters();
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formateador de fechas
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Lista de Lecciones Registradas'),
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        autofocus: true,
        child: Column(
          children: [
            // Filtros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filtro por Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de Usuario',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _applyFilters(),
                  ),
                  const SizedBox(height: 16.0),
                  // Filtros por Fecha
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha Inicio',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _startDate != null
                                  ? formatter.format(_startDate!)
                                  : 'Seleccionar Fecha',
                              style: TextStyle(
                                color: _startDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha Fin',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              _endDate != null
                                  ? formatter.format(_endDate!)
                                  : 'Seleccionar Fecha',
                              style: TextStyle(
                                color: _endDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Nuevo: Checkbox para "Clases de hoy"
                  CheckboxListTile(
                    title: const Text('Clases de hoy'),
                    value: _filterToday,
                    onChanged: (value) {
                      setState(() {
                        _filterToday = value ?? false;
                        if (_filterToday) {
                          // Si se selecciona "Clases de hoy", se limpian las fechas
                          _startDate = null;
                          _endDate = null;
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16.0),
                  // Botones de Aplicar y Limpiar Filtros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _applyFilters,
                        child: const Text('Aplicar Filtros'),
                      ),
                      TextButton(
                        onPressed: _clearFilters,
                        child: const Text('Limpiar Filtros'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // Expanded para contener el contador y la lista
            Expanded(
              child: StreamBuilder<List<RegisterLessonModel>>(
                stream: _service.getRegisterLessons(
                  startDate: _filterToday ? null : _startDate,
                  endDate: _filterToday ? null : _endDate,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error al cargar las lecciones'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<RegisterLessonModel> lessons = snapshot.data ?? [];

                  // Filtrar por "Clases de hoy"
                  if (_filterToday) {
                    final today = DateTime.now();
                    lessons = lessons.where((lesson) {
                      final lessonDate = lesson.date;
                      return lessonDate.year == today.year &&
                          lessonDate.month == today.month &&
                          lessonDate.day == today.day;
                    }).toList();
                  }

                  // Filtrar por userName en el cliente
                  if (_nameController.text.trim().isNotEmpty) {
                    final query = _nameController.text.trim().toLowerCase();
                    lessons = lessons.where((lesson) {
                      final name = lesson.userName?.toLowerCase() ?? '';
                      return name.contains(query);
                    }).toList();
                  }

                  if (lessons.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron lecciones'),
                    );
                  }

                  return Column(
                    children: [
                      // Contador estético en la parte superior
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Se encontraron ${lessons.length} clases',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // Lista de Lecciones
                      Expanded(
                        child: ListView.builder(
                          itemCount: lessons.length,
                          itemBuilder: (context, index) {
                            final lesson = lessons[index];
                            return RegisterLessonTile(
                              lesson: lesson,
                              index: index,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class RegisterLessonListScreen extends StatefulWidget {
//   const RegisterLessonListScreen({super.key});

//   @override
//   _RegisterLessonListScreenState createState() =>
//       _RegisterLessonListScreenState();
// }

// class _RegisterLessonListScreenState extends State<RegisterLessonListScreen> {
//   final RegisterLessonService _service = RegisterLessonService();

//   final TextEditingController _nameController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;

//   final FocusNode _focusNode =
//       FocusNode(); // FocusNode para el listener de teclado

//   // Función para seleccionar fecha
//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStart
//           ? (_startDate ?? DateTime.now())
//           : (_endDate ?? DateTime.now()),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//           // Si la fecha de inicio es posterior a la fecha final, ajusta la fecha final
//           if (_endDate != null && _startDate!.isAfter(_endDate!)) {
//             _endDate = _startDate;
//           }
//         } else {
//           _endDate = picked;
//           // Si la fecha final es anterior a la fecha de inicio, ajusta la fecha de inicio
//           if (_startDate != null && _endDate!.isBefore(_startDate!)) {
//             _startDate = _endDate;
//           }
//         }
//       });
//     }
//   }

//   // Función para limpiar filtros
//   void _clearFilters() {
//     setState(() {
//       _nameController.clear();
//       _startDate = null;
//       _endDate = null;
//     });
//   }

//   // Función para aplicar filtros
//   void _applyFilters() {
//     setState(() {});
//   }

//   // Manejador de eventos de teclado
//   void _handleKey(KeyEvent event) {
//     if (event is KeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.enter) {
//         _applyFilters();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose(); // Limpia el FocusNode cuando el widget se elimine
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Formateador de fechas
//     final DateFormat formatter = DateFormat('yyyy-MM-dd');

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text('Lista de Lecciones Registradas'),
//       ),
//       body: KeyboardListener(
//         focusNode: _focusNode,
//         onKeyEvent: _handleKey,
//         autofocus: true, // Asegura que el listener esté activo
//         child: Column(
//           children: [
//             // Filtros
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Filtro por Nombre
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Nombre de Usuario',
//                       border: OutlineInputBorder(),
//                     ),
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (_) =>
//                         _applyFilters(), // Manejador al presionar Enter
//                   ),
//                   const SizedBox(height: 16.0),
//                   // Filtros por Fecha
//                   Row(
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap: () => _selectDate(context, true),
//                           child: InputDecorator(
//                             decoration: const InputDecoration(
//                               labelText: 'Fecha Inicio',
//                               border: OutlineInputBorder(),
//                             ),
//                             child: Text(
//                               _startDate != null
//                                   ? formatter.format(_startDate!)
//                                   : 'Seleccionar Fecha',
//                               style: TextStyle(
//                                 color: _startDate != null
//                                     ? Colors.black
//                                     : Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16.0),
//                       Expanded(
//                         child: InkWell(
//                           onTap: () => _selectDate(context, false),
//                           child: InputDecorator(
//                             decoration: const InputDecoration(
//                               labelText: 'Fecha Fin',
//                               border: OutlineInputBorder(),
//                             ),
//                             child: Text(
//                               _endDate != null
//                                   ? formatter.format(_endDate!)
//                                   : 'Seleccionar Fecha',
//                               style: TextStyle(
//                                 color: _endDate != null
//                                     ? Colors.black
//                                     : Colors.grey[600],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   // Botones de Aplicar y Limpiar Filtros
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _applyFilters, // Usa la función centralizada
//                         child: const Text('Aplicar Filtros'),
//                       ),
//                       TextButton(
//                         onPressed: _clearFilters,
//                         child: const Text('Limpiar Filtros'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(),
//             // Expanded para contener el contador y la lista
//             Expanded(
//               child: StreamBuilder<List<RegisterLessonModel>>(
//                 stream: _service.getRegisterLessons(
//                   startDate: _startDate,
//                   endDate: _endDate,
//                 ),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Center(
//                       child: Text('Error al cargar las lecciones'),
//                     );
//                   }
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }

//                   List<RegisterLessonModel> lessons = snapshot.data ?? [];

//                   // Filtrar por userName en el cliente
//                   if (_nameController.text.trim().isNotEmpty) {
//                     final query = _nameController.text.trim().toLowerCase();
//                     lessons = lessons.where((lesson) {
//                       final name = lesson.userName?.toLowerCase() ?? '';
//                       return name.contains(query);
//                     }).toList();
//                   }

//                   if (lessons.isEmpty) {
//                     return const Center(
//                       child: Text('No se encontraron lecciones'),
//                     );
//                   }

//                   return Column(
//                     children: [
//                       // Contador estético en la parte superior
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Text(
//                               'Se encontraron ${lessons.length} clases',
//                               style: const TextStyle(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Lista de Lecciones
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: lessons.length,
//                           itemBuilder: (context, index) {
//                             final lesson = lessons[index];
//                             return RegisterLessonTile(
//                               lesson: lesson,
//                               index: index,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
