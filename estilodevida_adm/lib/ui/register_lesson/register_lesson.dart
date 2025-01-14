// import 'package:collection/collection.dart';
// import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
// import 'package:estilodevida_adm/service/register_lesson_service.dart';
// import 'package:estilodevida_adm/ui/drawer/custom_drawer.dart';
// import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';

// class RegisterLessonListScreen extends StatefulWidget {
//   const RegisterLessonListScreen({Key? key}) : super(key: key);

//   @override
//   RegisterLessonListScreenState createState() =>
//       RegisterLessonListScreenState();
// }

// class RegisterLessonListScreenState extends State<RegisterLessonListScreen> {
//   // Servicio para obtener las lecciones
//   final RegisterLessonService _service = RegisterLessonService();

//   // Controlador para el filtro por nombre de usuario (TEMPORAL)
//   final TextEditingController _nameController = TextEditingController();

//   // Fechas de inicio y fin TEMPORALES (las que el usuario va seleccionando)
//   DateTime? _startDate;
//   DateTime? _endDate;

//   // Filtro temporal de "Clases de hoy"
//   bool _filterToday = false;

//   // ---- Filtros aplicados (los que realmente usa el StreamBuilder) ----
//   // Al presionar "Aplicar Filtros", copiamos las variables temporales a estas:
//   DateTime? _appliedStartDate;
//   DateTime? _appliedEndDate;
//   bool _appliedFilterToday = true; // Por defecto en true, si así lo deseas

//   // NOTA: En este ejemplo, el filtrado por nombre lo hacemos en el cliente,
//   // así que no necesitamos una variable "appliedNameQuery" para la query.
//   // Pero si quisieras filtrar en servidor por nombre, podrías agregarlo.

//   // Para escuchar eventos de teclado
//   final FocusNode _focusNode = FocusNode();

//   // Colores de la marca
//   final Color brandPurple = const Color(0xFF81327D);
//   final Color brandBlue = const Color(0xFF3155A1);

//   /// Seleccionar fecha (inicio o fin).
//   /// Ajustamos la hora a las 00:00:00 si es inicio, o 23:59:59 si es fin,
//   /// para asegurarnos de incluir todas las lecciones de ese día.
//   Future<void> _selectDate(BuildContext context, bool isStart) async {
//     final DateTime now = DateTime.now();
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           // Ajustar a comienzo del día
//           _startDate = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
//           // Si la fecha final ya existe y es anterior, la igualamos
//           if (_endDate != null && _startDate!.isAfter(_endDate!)) {
//             _endDate = _startDate;
//           }
//         } else {
//           // Ajustar a fin del día
//           _endDate =
//               DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
//           // Si la fecha inicio ya existe y es posterior, la igualamos
//           if (_startDate != null && _endDate!.isBefore(_startDate!)) {
//             _startDate = _endDate;
//           }
//         }
//       });
//     }
//   }

//   /// Limpia los filtros temporales
//   void _clearFilters() {
//     setState(() {
//       _nameController.clear();
//       _startDate = null;
//       _endDate = null;
//       _filterToday = false;
//     });
//   }

//   /// Aplica los filtros para el StreamBuilder.
//   /// Se copian las variables temporales a las definitivas,
//   /// de modo que solo aquí se actualiza el stream.
//   void _applyFilters() {
//     setState(() {
//       _appliedFilterToday = _filterToday;
//       if (_appliedFilterToday) {
//         // Si selecciona "clases de hoy", anulamos las fechas
//         _appliedStartDate = null;
//         _appliedEndDate = null;
//       } else {
//         _appliedStartDate = _startDate;
//         _appliedEndDate = _endDate;
//       }
//     });
//   }

//   /// Manejador de eventos de teclado (aplica filtros con Enter)
//   void _handleKey(KeyEvent event) {
//     if (event is KeyDownEvent) {
//       if (event.logicalKey == LogicalKeyboardKey.enter) {
//         _applyFilters();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Formateador de fechas
//     final DateFormat formatter = DateFormat('dd-MM-yyyy');

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: brandPurple,
//         title: const Text(
//           'Lista de Lecciones Registradas',
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       drawer: const CustomDrawer(),
//       body: KeyboardListener(
//         focusNode: _focusNode,
//         onKeyEvent: _handleKey,
//         autofocus: true,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // ------- Sección de filtros -------
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Filtro por Nombre
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       labelText: 'Nombre de Usuario',
//                       border: const OutlineInputBorder(),
//                       labelStyle: TextStyle(color: brandPurple),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: brandPurple),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: brandPurple),
//                       ),
//                     ),
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (_) => _applyFilters(),
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Filtros por Fecha (TEMPORALES)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: InkWell(
//                           onTap: () => _selectDate(context, true),
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'Fecha Inicio',
//                               border: const OutlineInputBorder(),
//                               labelStyle: TextStyle(color: brandPurple),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: brandPurple),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: brandPurple),
//                               ),
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
//                             decoration: InputDecoration(
//                               labelText: 'Fecha Fin',
//                               border: const OutlineInputBorder(),
//                               labelStyle: TextStyle(color: brandPurple),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: brandPurple),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(color: brandPurple),
//                               ),
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

//                   // Checkbox para "Clases de hoy"
//                   CheckboxListTile(
//                     title: Text(
//                       'Clases de hoy',
//                       style: TextStyle(color: brandPurple),
//                     ),
//                     activeColor: brandPurple,
//                     value: _filterToday,
//                     onChanged: (value) {
//                       setState(() {
//                         _filterToday = value ?? false;
//                         // Si marca "Clases de hoy", borramos las fechas temporales
//                         if (_filterToday) {
//                           _startDate = null;
//                           _endDate = null;
//                         }
//                       });
//                     },
//                     controlAffinity: ListTileControlAffinity.leading,
//                   ),
//                   const SizedBox(height: 16.0),

//                   // Botones de Aplicar y Limpiar Filtros
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: brandBlue,
//                           foregroundColor: Colors.white,
//                         ),
//                         onPressed: _applyFilters,
//                         child: const Text('Aplicar Filtros'),
//                       ),
//                       TextButton(
//                         style: TextButton.styleFrom(
//                           foregroundColor: brandPurple,
//                         ),
//                         onPressed: _clearFilters,
//                         child: const Text('Limpiar Filtros'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(),

//             // ------- Aquí construimos la lista de resultados -------
//             Expanded(
//               child: StreamBuilder<List<RegisterLessonModel>>(
//                 // Aquí usamos los filtros APLICADOS para no hacer múltiples consultas
//                 stream: _service.getRegisterLessons(
//                   startDate: _appliedFilterToday ? null : _appliedStartDate,
//                   endDate: _appliedFilterToday ? null : _appliedEndDate,
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

//                   // Obtenemos la lista de lecciones
//                   List<RegisterLessonModel> lessons = snapshot.data ?? [];

//                   // Filtrar por "Clases de hoy" de forma local (según el flag aplicado)
//                   // Aunque ya pedimos TODO al servicio si _appliedFilterToday es true,
//                   // igual hacemos esta validación local en caso de que la query no filtra por hora.
//                   if (_appliedFilterToday) {
//                     final today = DateTime.now();
//                     lessons = lessons.where((lesson) {
//                       final lessonDate = lesson.date;
//                       return lessonDate.year == today.year &&
//                           lessonDate.month == today.month &&
//                           lessonDate.day == today.day;
//                     }).toList();
//                   }

//                   // Filtrar por userName en el cliente (texto ingresado actualmente)
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

//                   // --- Agrupar por "lessons" ---
//                   final grouped = groupBy(
//                     lessons,
//                     (RegisterLessonModel lesson) => lesson.lessons ?? 0,
//                   );

//                   // Contador total de lecciones encontradas
//                   final totalCount = lessons.length;

//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       border: const Border(
//                         top: BorderSide(
//                           color: Colors.purple,
//                           width: 2.0,
//                         ),
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(20.0),
//                         bottomRight: Radius.circular(20.0),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 15.0,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         // Contador en la parte superior
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Card(
//                             elevation: 2,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 'Se encontraron $totalCount clases',
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   fontWeight: FontWeight.bold,
//                                   color: brandPurple,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Listado de packs con ExpansionTile agrupados por "lessons"
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: grouped.keys.length,
//                             itemBuilder: (context, index) {
//                               final lessonsCount =
//                                   grouped.keys.elementAt(index);
//                               final packLessons = grouped[lessonsCount] ?? [];

//                               // Cantidad de registros en este grupo
//                               final totalRegistrosEnPack = packLessons.length;

//                               return Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0,
//                                   vertical: 8.0,
//                                 ),
//                                 child: Card(
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                   child: ExpansionTile(
//                                     collapsedBackgroundColor: Colors.grey[100],
//                                     iconColor: brandBlue,
//                                     collapsedIconColor: brandBlue,
//                                     title: Text(
//                                       'Packs de $lessonsCount clases: $totalRegistrosEnPack',
//                                       style: const TextStyle(
//                                         fontSize: 16.0,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     children: packLessons.map((lesson) {
//                                       return RegisterLessonTile(
//                                         lesson: lesson,
//                                         index: lessons.indexOf(lesson),
//                                       );
//                                     }).toList(),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
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

import 'package:collection/collection.dart';
import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
import 'package:estilodevida_adm/service/register_lesson_service.dart';
import 'package:estilodevida_adm/ui/drawer/custom_drawer.dart';
import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class RegisterLessonListScreen extends StatefulWidget {
  const RegisterLessonListScreen({Key? key}) : super(key: key);

  @override
  RegisterLessonListScreenState createState() =>
      RegisterLessonListScreenState();
}

class RegisterLessonListScreenState extends State<RegisterLessonListScreen> {
  // Servicio para obtener las lecciones
  final RegisterLessonService _service = RegisterLessonService();

  // Controlador para el filtro por nombre de usuario (TEMPORAL)
  final TextEditingController _nameController = TextEditingController();

  // Fechas de inicio y fin TEMPORALES (las que el usuario va seleccionando)
  DateTime? _startDate;
  DateTime? _endDate;

  // Filtro temporal de "Clases de hoy"
  bool _filterToday = false;

  // ---- Filtros aplicados (los que realmente se usan al llamar al servicio) ----
  DateTime? _appliedStartDate;
  DateTime? _appliedEndDate;
  bool _appliedFilterToday = true; // Por defecto en true, si así lo deseas

  // Lista local con los resultados de la consulta
  List<RegisterLessonModel> _lessons = [];

  // Bandera para saber si estamos cargando la lista desde Firestore
  bool _isLoading = false;

  // Para escuchar eventos de teclado (aplica filtros con Enter)
  final FocusNode _focusNode = FocusNode();

  // Colores de la marca
  final Color brandPurple = const Color(0xFF81327D);
  final Color brandBlue = const Color(0xFF3155A1);

  @override
  void dispose() {
    _focusNode.dispose();
    _nameController.dispose();
    super.dispose();
  }

  /// Seleccionar fecha (inicio o fin).
  /// Ajustamos la hora a las 00:00:00 si es inicio, o 23:59:59 si es fin,
  /// para asegurarnos de incluir todas las lecciones de ese día.
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          // Ajustar a comienzo del día
          _startDate = DateTime(picked.year, picked.month, picked.day, 0, 0, 0);
          // Si la fecha final ya existe y es anterior, la igualamos
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate;
          }
        } else {
          // Ajustar a fin del día
          _endDate =
              DateTime(picked.year, picked.month, picked.day, 23, 59, 59);
          // Si la fecha inicio ya existe y es posterior, la igualamos
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  /// Limpia los filtros temporales
  void _clearFilters() {
    setState(() {
      _nameController.clear();
      _startDate = null;
      _endDate = null;
      _filterToday = false;
      // Opcional: borrar también el listado actual
      _lessons.clear();
    });
  }

  /// Manejador de eventos de teclado (aplica filtros con Enter)
  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _applyFilters(); // Llamamos a la misma función
      }
    }
  }

  /// Aplica los filtros y llama al servicio solo en este momento
  /// para cargar la lista de lecciones.
  Future<void> _applyFilters() async {
    setState(() {
      _appliedFilterToday = _filterToday;
      if (_appliedFilterToday) {
        _appliedStartDate = null;
        _appliedEndDate = null;
      } else {
        _appliedStartDate = _startDate;
        _appliedEndDate = _endDate;
      }
      _isLoading = true; // Mostrar indicador de carga si quieres
    });

    // LLAMADA AL SERVICIO:  (un solo .get() o .first, según tu implementación)
    final List<RegisterLessonModel> results =
        await _service.getRegisterLessonsFuture(
      startDate: _appliedFilterToday ? null : _appliedStartDate,
      endDate: _appliedFilterToday ? null : _appliedEndDate,
    ); // Convertimos el Stream en un Future con .first

    // Actualizamos la lista local
    setState(() {
      _lessons = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Formateador de fechas
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: brandPurple,
        title: const Text(
          'Lista de Lecciones Registradas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ------- Sección de filtros -------
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Filtro por Nombre
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre de Usuario',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: brandPurple),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandPurple),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: brandPurple),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _applyFilters(),
                  ),
                  const SizedBox(height: 16.0),

                  // Filtros por Fecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, true),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Fecha Inicio',
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: brandPurple),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: brandPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: brandPurple),
                              ),
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
                            decoration: InputDecoration(
                              labelText: 'Fecha Fin',
                              border: const OutlineInputBorder(),
                              labelStyle: TextStyle(color: brandPurple),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: brandPurple),
                              ),
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

                  // Checkbox para "Clases de hoy"
                  CheckboxListTile(
                    title: Text(
                      'Clases de hoy',
                      style: TextStyle(color: brandPurple),
                    ),
                    activeColor: brandPurple,
                    value: _filterToday,
                    onChanged: (value) {
                      setState(() {
                        _filterToday = value ?? false;
                        if (_filterToday) {
                          // Borramos fechas temporales
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandBlue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _applyFilters,
                        child: const Text('Aplicar Filtros'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: brandPurple,
                        ),
                        onPressed: _clearFilters,
                        child: const Text('Limpiar Filtros'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // ------- Aquí construimos la lista de resultados -------
            Expanded(
              // Aquí ya NO usamos StreamBuilder.
              // Solo mostramos la lista local _lessons
              child: _buildLessonsView(),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el contenido donde se muestran las lecciones
  Widget _buildLessonsView() {
    // Si todavía está cargando, muestra un indicador (o nada, como prefieras)
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtrar por "Clases de hoy" de forma local (por si acaso)
    List<RegisterLessonModel> displayedLessons = List.from(_lessons);
    if (_appliedFilterToday) {
      final today = DateTime.now();
      displayedLessons = displayedLessons.where((lesson) {
        final lessonDate = lesson.date;
        return lessonDate.year == today.year &&
            lessonDate.month == today.month &&
            lessonDate.day == today.day;
      }).toList();
    }

    // Filtrar por userName en el cliente (lo que haya en _nameController)
    if (_nameController.text.trim().isNotEmpty) {
      final query = _nameController.text.trim().toLowerCase();
      displayedLessons = displayedLessons.where((lesson) {
        final name = lesson.userName?.toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    }

    if (displayedLessons.isEmpty) {
      return const Center(
        child: Text('No se encontraron lecciones'),
      );
    }

    // --- Agrupar por "lessons" ---
    final grouped = groupBy(
      displayedLessons,
      (RegisterLessonModel lesson) => lesson.lessons ?? 0,
    );

    // Contador total de lecciones encontradas
    final totalCount = displayedLessons.length;

    // Construimos la vista (similar a tu código original)
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(
            color: Colors.purple,
            width: 2.0,
          ),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Contador en la parte superior
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
                  'Se encontraron $totalCount clases',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: brandPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          // Listado de packs con ExpansionTile agrupados por "lessons"
          Expanded(
            child: ListView.builder(
              itemCount: grouped.keys.length,
              itemBuilder: (context, index) {
                final lessonsCount = grouped.keys.elementAt(index);
                final packLessons = grouped[lessonsCount] ?? [];

                // Cantidad de registros en este grupo
                final totalRegistrosEnPack = packLessons.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ExpansionTile(
                      collapsedBackgroundColor: Colors.grey[100],
                      iconColor: brandBlue,
                      collapsedIconColor: brandBlue,
                      title: Text(
                        'Packs de $lessonsCount clases: $totalRegistrosEnPack',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      children: packLessons.map((lesson) {
                        return RegisterLessonTile(
                          lesson: lesson,
                          index: _lessons.indexOf(lesson),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
