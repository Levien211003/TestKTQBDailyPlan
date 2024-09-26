import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/data/AuthService.dart';

class AddTask extends StatefulWidget {
  final int userId; // Nhận userId từ constructor
  final Function onTaskAdded; // Callback để gọi khi nhiệm vụ được thêm

  AddTask({required this.userId, required this.onTaskAdded}); // Cập nhật constructor

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
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
  Widget build(BuildContext context) {
    // Kiểm tra chế độ tối
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: isDarkMode ? Colors.teal[800] : Colors.teal, // Đặt màu cho AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // TextField cho Title
              _buildTextField(_titleController, 'Title', Icons.title, isDarkMode),

              // Select cho Start Date
              _buildDateField('Select Start Date', _startDate, true, isDarkMode),

              // Select cho End Date
              _buildDateField('Select End Date', _endDate, false, isDarkMode),

              // TextField cho Location
              _buildTextField(_locationController, 'Location', Icons.location_on, isDarkMode),

              // TextField cho Assigned To
              _buildTextField(_assignedToController, 'Assigned To', Icons.person, isDarkMode),

              // Select cho Status
              _buildDropdown<String>(
                'Status',
                _status,
                ['New', 'Inprogress'],
                    (String? newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
                isDarkMode,
              ),

              // Select cho Priority
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

              // TextField cho Notes
              _buildTextField(_notesController, 'Notes', Icons.notes, isDarkMode),

              // Button Save
              _buildButton('Save', _saveTask, Colors.teal, isDarkMode),

              // Button Cancel
              _buildButton('Cancel', () {
                Navigator.of(context).pop(); // Đóng màn hình
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
      color: isDarkMode ? Colors.grey[850] : Colors.white, // Màu cho Card
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Màu cho label
          prefixIcon: Icon(icon, color: Colors.teal),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Màu cho văn bản
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
          color: isDarkMode ? Colors.grey[850] : Colors.white, // Màu cho Card
          child: TextField(
            decoration: InputDecoration(
              labelText: date == null
                  ? label
                  : '${DateFormat('yyyy-MM-dd').format(date)} ${isStartDate ? (_startTime != null ? _startTime!.format(context) : '') : (_endTime != null ? _endTime!.format(context) : '')}',
              labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Màu cho label
              prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Màu cho văn bản
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged, bool isDarkMode) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: isDarkMode ? Colors.grey[850] : Colors.white, // Màu cho Card
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Màu cho label
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        dropdownColor: isDarkMode ? Colors.grey[850] : Colors.white, // Màu cho Dropdown
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Màu cho văn bản
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
        child: Text(label, style: TextStyle(color: isDarkMode ? Colors.black : Colors.white)), // Màu cho văn bản
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

  void _saveTask() async {
    // Kiểm tra dữ liệu và lưu task
    if (_titleController.text.isEmpty || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Kết hợp thời gian vào ngày
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
      _endTime?.hour ?? 0,
      _endTime?.minute ?? 0,
    );

    // Tạo Task mới
    Task newTask = Task(
      userID: widget.userId,
      title: _titleController.text,
      startDate: startDateTime,
      endDate: endDateTime,
      location: _locationController.text,
      assignedTo: _assignedToController.text,
      status: _status,
      priority: _priority,
      notes: _notesController.text,
    );

    // Ghi log để kiểm tra thông tin Task
    print('Creating Task: ${newTask.toJson()}');
    print('User ID: ${widget.userId}');
    print('Title: ${_titleController.text}');
    print('Start Date: ${startDateTime}');
    print('End Date: ${endDateTime}');
    print('Location: ${_locationController.text}');
    print('Assigned To: ${_assignedToController.text}');
    print('Status: $_status');
    print('Priority: $_priority');
    print('Notes: ${_notesController.text}');

    // Gọi API để thêm Task
    bool success = await _authService.addTask(newTask);
    if (success) {
      widget.onTaskAdded(); // Gọi callback để cập nhật danh sách
      Navigator.of(context).pop(); // Đóng màn hình sau khi lưu thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task!')),
      );
    }
  }
}
