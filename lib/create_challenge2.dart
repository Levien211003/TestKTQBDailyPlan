// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//
// class CreateChallenge2 extends StatefulWidget {
//   final bool isRecurring;
//
//   CreateChallenge2({required this.isRecurring});
//
//   @override
//   _CreateChallenge2State createState() => _CreateChallenge2State();
// }
//
// class _CreateChallenge2State extends State<CreateChallenge2> {
//   String? selectedIcon;
//   Color selectedColor = Colors.orange; // Default to match the screenshot
//   String repeatOption = "Không lặp lại";
//   DateTime? startDate;
//   DateTime? endDate;
//   bool reminderEnabled = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'THỬ THÁCH MỚI',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Name input field
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Icon(Icons.calendar_today, color: Colors.orange),
//                   ),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Nhập tên',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Icon and color picker sections
//             Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _showIconPicker();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.apple, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text('Biểu tượng'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       _showColorPicker();
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(backgroundColor: selectedColor),
//                           SizedBox(width: 8),
//                           Text('Màu sắc'),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),
//
//             // Options container (Repeat, Start Date, End Date, Reminder)
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   _buildOptionRow("Lặp lại", repeatOption, () {
//                     _showRepeatOptions();
//                   }),
//                   Divider(),
//                   _buildOptionRow("Ngày bắt đầu", _formatDate(startDate), () {
//                     _selectDate(context, "Ngày bắt đầu", (date) {
//                       setState(() {
//                         startDate = date;
//                       });
//                     });
//                   }),
//                   Divider(),
//                   _buildOptionRow("Ngày kết thúc", _formatDate(endDate), () {
//                     _selectDate(context, "Ngày kết thúc", (date) {
//                       if (startDate == null || date.isAfter(startDate!)) {
//                         setState(() {
//                           endDate = date;
//                         });
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content:
//                                   Text('Ngày kết thúc phải sau ngày bắt đầu!')),
//                         );
//                       }
//                     });
//                   }),
//                   Divider(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Nhắc nhở"),
//                       Switch(
//                         value: reminderEnabled,
//                         onChanged: (value) {
//                           setState(() {
//                             reminderEnabled = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Save button
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Save logic here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                 ),
//                 child: Text("Hứa hẹn"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Utility function to format the date
//   String _formatDate(DateTime? date) {
//     return date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Chưa chọn';
//   }
//
//   // Function to build rows in the options container
//   Widget _buildOptionRow(String label, String value, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label),
//           Row(
//             children: [
//               Text(value),
//               SizedBox(width: 8),
//               Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Show icon picker
//   void _showIconPicker() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Chọn biểu tượng"),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.star),
//                 onPressed: () {
//                   setState(() {
//                     selectedIcon = "Biểu tượng 1";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.favorite),
//                 onPressed: () {
//                   setState(() {
//                     selectedIcon = "Biểu tượng 2";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.thumb_up),
//                 onPressed: () {
//                   setState(() {
//                     selectedIcon = "Biểu tượng 3";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Show color picker
//   void _showColorPicker() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Chọn màu sắc"),
//           content: SingleChildScrollView(
//             child: BlockPicker(
//               pickerColor: selectedColor,
//               onColorChanged: (color) {
//                 setState(() {
//                   selectedColor = color;
//                 });
//                 Navigator.pop(context);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Show repeat options
//   void _showRepeatOptions() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Chọn lặp lại"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text("Không lặp lại"),
//                 onTap: () {
//                   setState(() {
//                     repeatOption = "Không lặp lại";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text("Hằng ngày"),
//                 onTap: () {
//                   setState(() {
//                     repeatOption = "Hằng ngày";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text("Hàng tuần"),
//                 onTap: () {
//                   setState(() {
//                     repeatOption = "Hàng tuần";
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Select date function
//   void _selectDate(
//       BuildContext context, String title, Function(DateTime) onDateSelected) {
//     showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2022),
//       lastDate: DateTime(2100),
//     ).then((date) {
//       if (date != null) {
//         onDateSelected(date);
//       }
//     });
//   }
// }
