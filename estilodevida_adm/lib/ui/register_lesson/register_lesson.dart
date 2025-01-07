import 'package:collection/collection.dart';
import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
import 'package:estilodevida_adm/service/register_lesson_service.dart';
import 'package:estilodevida_adm/ui/drawer/custom_drawer.dart';
import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class RegisterLessonListScreen extends StatefulWidget {
  const RegisterLessonListScreen({super.key});

  @override
  RegisterLessonListScreenState createState() =>
      RegisterLessonListScreenState();
}

class RegisterLessonListScreenState extends State<RegisterLessonListScreen> {
  // Servicio para obtener las lecciones
  final RegisterLessonService _service = RegisterLessonService();

  // Controlador para el filtro por nombre de usuario
  final TextEditingController _nameController = TextEditingController();

  // Fechas de inicio y fin para los filtros
  DateTime? _startDate;
  DateTime? _endDate;

  // Para escuchar eventos de teclado
  final FocusNode _focusNode = FocusNode();

  // Por defecto marcamos "Clases de hoy" en true
  bool _filterToday = true;

  // Colores de la marca
  final Color brandPurple = const Color(0xFF81327D);
  final Color brandBlue = const Color(0xFF3155A1);

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
          // Ajustar fecha final si la de inicio es posterior
          if (_endDate != null && _startDate!.isAfter(_endDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          // Ajustar fecha de inicio si la final es anterior
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
      _filterToday = false;
    });
  }

  // Función para aplicar filtros
  void _applyFilters() {
    setState(() {});
  }

  // Manejador de eventos de teclado (aplica filtros con Enter)
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
      // Color de fondo para toda la pantalla
      backgroundColor: Colors.white,

      // AppBar con color de marca
      appBar: AppBar(
        backgroundColor: brandPurple,
        title: const Text(
          'Lista de Lecciones Registradas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: const CustomDrawer(),

      // Contenedor principal para el contenido
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKey,
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sección de filtros
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
                              enabledBorder: OutlineInputBorder(
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

                  // Checkbox para "Clases de hoy" (true por defecto)
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

            // Expanded para la lista de resultados
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

                  // Obtenemos la lista de lecciones
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

                  // --- Agrupar por lessons ---
                  final grouped = groupBy(
                    lessons,
                    (RegisterLessonModel lesson) => lesson.lessons ?? 0,
                  );

                  // Contador total de lecciones encontradas
                  final totalCount = lessons.length;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95), // Color de fondo
                      border: const Border(
                        top: BorderSide(
                          color:
                              Colors.purple, // Color del borde superior púrpura
                          width: 2.0, // Grosor del borde
                        ),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                            20.0), // Redondeo de la esquina inferior izquierda
                        bottomRight: Radius.circular(
                            20.0), // Redondeo de la esquina inferior derecha
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
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

                        // Listado de packs con ExpansionTile agrupados por lessons
                        Expanded(
                          child: ListView.builder(
                            itemCount: grouped.keys.length,
                            itemBuilder: (context, index) {
                              final lessonsCount =
                                  grouped.keys.elementAt(index);
                              final packLessons = grouped[lessonsCount] ?? [];

                              // Contar la cantidad de registros en este grupo
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
                                      // Título con "Packs de X lessons (Total: Y)"
                                      'Packs de $lessonsCount clases: $totalRegistrosEnPack',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Color negro
                                      ),
                                    ),
                                    children: packLessons.map((lesson) {
                                      return RegisterLessonTile(
                                        lesson: lesson,
                                        // Para el index global, podemos buscar su posición en la lista completa
                                        index: lessons.indexOf(lesson),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
