
// import 'package:estilodevida_adm/model/user_pack/user_pack.dart';
// import 'package:flutter/material.dart';

// class UserPackDialog extends StatefulWidget {
//   final String userId;
//   final UserPackModel? existingPack;
//   final Future<void> Function(UserPackModel pack) onSave;

//   const UserPackDialog({
//     super.key,
//     required this.userId,
//     this.existingPack,
//     required this.onSave,
//   });

//   @override
//   _UserPackDialogState createState() => _UserPackDialogState();
// }

// class _UserPackDialogState extends State<UserPackDialog> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _packIdController;
//   late TextEditingController _buyDateController;
//   late TextEditingController _dueDateController;
//   late TextEditingController _totalLessonsController;
//   late TextEditingController _usedLessonsController;

//   @override
//   void initState() {
//     super.initState();
//     _packIdController = TextEditingController(
//         text: widget.existingPack != null ? widget.existingPack!.packId : '');
//     _buyDateController = TextEditingController(
//         text: widget.existingPack != null
//             ? widget.existingPack!.buyDate.toIso8601String()
//             : '');
//     _dueDateController = TextEditingController(
//         text: widget.existingPack != null
//             ? widget.existingPack!.dueDate.toIso8601String()
//             : '');
//     _totalLessonsController = TextEditingController(
//         text: widget.existingPack != null
//             ? widget.existingPack!.totalLessons.toString()
//             : '');
//     _usedLessonsController = TextEditingController(
//         text: widget.existingPack != null &&
//                 widget.existingPack!.usedLessons != null
//             ? widget.existingPack!.usedLessons.toString()
//             : '');
//   }

//   @override
//   void dispose() {
//     _packIdController.dispose();
//     _buyDateController.dispose();
//     _dueDateController.dispose();
//     _totalLessonsController.dispose();
//     _usedLessonsController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate(
//       BuildContext context, TextEditingController controller) async {
//     DateTime initialDate = DateTime.now();
//     if (controller.text.isNotEmpty) {
//       initialDate = DateTime.parse(controller.text);
//     }
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       controller.text = picked.toIso8601String();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//           widget.existingPack != null ? 'Editar Paquete' : 'Agregar Paquete'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _packIdController,
//                 decoration: const InputDecoration(labelText: 'ID del Paquete'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, ingresa el ID del paquete';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _buyDateController,
//                 decoration: InputDecoration(
//                   labelText: 'Fecha de Compra',
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () => _selectDate(context, _buyDateController),
//                   ),
//                 ),
//                 readOnly: true,
//                 onTap: () => _selectDate(context, _buyDateController),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, selecciona la fecha de compra';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _dueDateController,
//                 decoration: InputDecoration(
//                   labelText: 'Fecha de Vencimiento',
//                   suffixIcon: IconButton(
//                     icon: const Icon(Icons.calendar_today),
//                     onPressed: () => _selectDate(context, _dueDateController),
//                   ),
//                 ),
//                 readOnly: true,
//                 onTap: () => _selectDate(context, _dueDateController),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, selecciona la fecha de vencimiento';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _totalLessonsController,
//                 decoration:
//                     const InputDecoration(labelText: 'Total de Lecciones'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, ingresa el total de lecciones';
//                   }
//                   if (int.tryParse(value) == null) {
//                     return 'Por favor, ingresa un número válido';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 controller: _usedLessonsController,
//                 decoration: const InputDecoration(
//                     labelText: 'Lecciones Usadas (Opcional)'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value != null &&
//                       value.isNotEmpty &&
//                       int.tryParse(value) == null) {
//                     return 'Por favor, ingresa un número válido';
//                   }
//                   return null;
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Cancelar'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             if (_formKey.currentState!.validate()) {
//               final newPack = UserPackModel(
//                 id: widget.existingPack?.id ?? '', // Se ignora en creación
//                 buyDate: DateTime.parse(_buyDateController.text),
//                 dueDate: DateTime.parse(_dueDateController.text),
//                 totalLessons: int.parse(_totalLessonsController.text),
//                 usedLessons: _usedLessonsController.text.isNotEmpty
//                     ? int.parse(_usedLessonsController.text)
//                     : null,
//                 packId: _packIdController.text,
//               );

//               if (widget.existingPack != null) {
//                 // Para actualización, mantener el mismo ID
//                 final updatedPack = UserPackModel(
//                   id: widget.existingPack!.id,
//                   buyDate: newPack.buyDate,
//                   dueDate: newPack.dueDate,
//                   totalLessons: newPack.totalLessons,
//                   usedLessons: newPack.usedLessons,
//                   packId: newPack.packId,
//                   userName: user.
//                 );
//                 await widget.onSave(updatedPack);
//               } else {
//                 // Para creación, el ID será generado por Firestore
//                 await widget.onSave(newPack);
//               }

//               Navigator.pop(context);
//             }
//           },
//           child: const Text('Guardar'),
//         ),
//       ],
//     );
//   }
// }
