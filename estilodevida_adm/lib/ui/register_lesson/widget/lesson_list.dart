// import 'package:estilodevida_adm/model/register_lesson/register_lesson_model.dart';
// import 'package:estilodevida_adm/service/register_lesson_service.dart';
// import 'package:estilodevida_adm/ui/register_lesson/widget/register_lesson_title.dart';
// import 'package:flutter/material.dart';

// class LessonList extends StatelessWidget {
//   const LessonList({
//     super.key,
//     required RegisterLessonService service,
//     required TextEditingController nameController,
//     required DateTime? startDate,
//     required DateTime? endDate,
//   })  : _service = service,
//         _startDate = startDate,
//         _endDate = endDate;

//   final RegisterLessonService _service;
//   final DateTime? _startDate;
//   final DateTime? _endDate;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: StreamBuilder<List<RegisterLessonModel>>(
//         stream: _service.getRegisterLessons(
//           startDate: _startDate,
//           endDatea: _endDate,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Error al cargar las lecciones'),
//             );
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final lessons = snapshot.data;

//           if (lessons == null || lessons.isEmpty) {
//             return const Center(
//               child: Text('No se encontraron lecciones'),
//             );
//           }

//           return ListView.builder(
//             itemCount: lessons.length,
//             itemBuilder: (context, index) {
//               final lesson = lessons[index];
//               return RegisterLessonTile(
//                 lesson: lesson,
//                 index: index,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
