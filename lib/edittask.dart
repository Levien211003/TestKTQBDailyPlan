import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/data/AuthService.dart';

class EditTask extends StatefulWidget {
  final Task task; // Nhận task cần chỉnh sửa
  final Function onTaskUpdated; // Callback để gọi khi task được cập nhật

  EditTask({required this.task, required this.onTaskUpdated});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final AuthService _authService = AuthService(); // Khởi tạo AuthService
  final _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _locationController = TextEditingController();
  final _assignedToController = TextEditingController();
  String _status = 'New';
  int _priority = 1;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo các controller với dữ liệu task hiện tại
    _titleController.text = widget.task.title;
    _startDate = widget.task.startDate;
    _endDate = widget.task.endDate;
    _locationController.text = widget.task.location ?? '';
    _assignedToController.text = widget.task.assignedTo ?? '';
    _status = widget.task.status; // Đảm bảo giá trị này đúng
    _priority = widget.task.priority;
    _notesController.text = widget.task.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        backgroundColor: isDarkMode ? Colors.teal[800] : Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_titleController, 'Title', Icons.title, isDarkMode),
              _buildDateField('Select Start Date', _startDate, true, isDarkMode),
              _buildDateField('Select End Date', _endDate, false, isDarkMode),
              _buildTextField(_locationController, 'Location', Icons.location_on, isDarkMode),
              _buildTextField(_assignedToController, 'Assigned To', Icons.person, isDarkMode),
              _buildDropdown<String>(
                'Status',
                _status,
                ['New', 'In Progress'], // Đảm bảo giá trị khớp
                    (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                isDarkMode,
              ),
              _buildDropdown<int>(
                'Priority',
                _priority,
                [1, 2, 3],
                    (int? newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
                isDarkMode,
              ),
              _buildTextField(_notesController, 'Notes', Icons.notes, isDarkMode),
              _buildButton('Save', _updateTask, Colors.teal, isDarkMode),
              _buildButton('Cancel', () {
                Navigator.of(context).pop();
              }, Colors.grey, isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool isDarkMode) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isStartDate, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: AbsorbPointer(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          child: TextField(
            decoration: InputDecoration(
              labelText: date == null
                  ? label
                  : '${DateFormat('yyyy-MM-dd').format(date)} ${isStartDate ? (_startTime != null ? _startTime!.format(context) : '') : (_endTime != null ? _endTime!.format(context) : '')}',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged, bool isDarkMode) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white,
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, Color color, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: TextStyle(color: isDarkMode ? Colors.black : Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = DateTime.now();
    if (!isStartDate && _startDate != null) {
      initialDate = _startDate!.add(Duration(days: 1));
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _selectTime(context, isStartDate);
        } else {
          if (_startDate == null || pickedDate.isAfter(_startDate!)) {
            _endDate = pickedDate;
            _selectTime(context, isStartDate);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('End date must be after start date!')),
            );
          }
        }
      });
    }
  }

  void _selectTime(BuildContext context, bool isStartDate) async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (!isStartDate && _startTime != null) {
      initialTime = _startTime!;
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartDate) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _updateTask() async {
    if (_titleController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    DateTime startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime?.hour ?? 0,
      _startTime?.minute ?? 0,
    );

    DateTime endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime?.hour ?? 23,
      _endTime?.minute ?? 59,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End time must be after start time!')),
      );
      return;
    }

    // Cập nhật task
    final updatedTask = Task(
      taskID: widget.task.taskID,
      userID: widget.task.userID,
      title: _titleController.text,
      startDate: startDateTime,
      endDate: endDateTime,
      location: _locationController.text,
      assignedTo: _assignedToController.text,
      status: _status,
      priority: _priority,
      notes: _notesController.text,
    );

    await _authService.updateTask(updatedTask);

    // Hiển thị thông báo thành công
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task updated successfully!')),
    );

    // Gọi hàm callback để cập nhật task ở TaskDetails
    widget.onTaskUpdated(updatedTask);

    // Quay lại TaskDetails
    Navigator.of(context).pop(); // Đóng màn hình EditTask
  }

}
