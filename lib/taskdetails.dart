import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/data/AuthService.dart'; // Import AuthService để gọi delete
import 'package:testktdailyplan/list_screen.dart'; // Import màn hình ListScreen
import 'package:shared_preferences/shared_preferences.dart';
import 'edittask.dart';// Import SharedPreferences để lấy userId

class TaskDetails extends StatefulWidget {
  final Task task;

  TaskDetails({required this.task});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late Task task; // Khai báo biến task không final

  final AuthService authService = AuthService(); // Khởi tạo AuthService để gọi các API

  @override
  void initState() {
    super.initState();
    task = widget.task; // Khởi tạo task từ widget.task
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title, style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.yellow : Colors.blue),
          onPressed: () {
            Navigator.pop(context, true); // Trả về true khi quay lại
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTaskDetailRow('Tiêu đề', task.title, Icons.title, isDarkMode),
            _buildTaskDetailRow('Ngày bắt đầu', DateFormat('dd/MM/yyyy').format(task.startDate), Icons.date_range, isDarkMode),
            _buildTaskDetailRow('Ngày kết thúc', DateFormat('dd/MM/yyyy').format(task.endDate), Icons.date_range, isDarkMode),
            _buildTaskDetailRow('Địa điểm', task.location ?? 'N/A', Icons.location_on, isDarkMode),
            _buildTaskDetailRow('Người được giao', task.assignedTo ?? 'N/A', Icons.person, isDarkMode),
            _buildTaskDetailRow('Trạng thái', task.status, Icons.check_circle, isDarkMode),
            _buildTaskDetailRow('Ưu tiên', task.priority.toString(), Icons.priority_high, isDarkMode),
            _buildTaskDetailRow('Ghi chú', task.notes ?? 'N/A', Icons.note, isDarkMode),
            _buildTaskDetailRow('Tạo vào', DateFormat('dd/MM/yyyy').format(task.createdAt), Icons.create, isDarkMode),
            _buildTaskDetailRow('Cập nhật vào', DateFormat('dd/MM/yyyy').format(task.updatedAt), Icons.update, isDarkMode),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(context, isDarkMode),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FloatingActionButton(
            backgroundColor: isDarkMode ? Colors.yellow : Colors.blue,
            child: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditTask(
                  task: task,
                  onTaskUpdated: (updatedTask) {
                    setState(() {
                      task = updatedTask; // Cập nhật task trong trạng thái
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Công việc đã được cập nhật!')),
                    );
                  },
                )),
              );
            },
          ),
        ),
        FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.red : Colors.redAccent,
          child: Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            // Hiển thị hộp thoại xác nhận trước khi xóa
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Xóa công việc', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
                  content: Text('Bạn có chắc chắn muốn xóa công việc này không?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        // Gọi hàm xóa công việc
                        bool success = await authService.deleteTask(task.taskID!); // Đảm bảo taskID không null
                        if (success) {
                          // Làm mới danh sách sau khi xóa thành công
                          int userId = await _getUserId(); // Lấy userId từ SharedPreferences
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => ListScreen(isDarkMode: isDarkMode, userId: userId)), // Điều hướng về ListScreen
                          );
                        } else {
                          // Hiển thị thông báo lỗi nếu xóa không thành công
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Xóa công việc thất bại.')),
                          );
                        }
                      },
                      child: Text('Có', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng hộp thoại
                      },
                      child: Text('Không', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  // Hàm lấy userId từ SharedPreferences
  Future<int> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userID') ?? 0; // Đảm bảo trả về 0 nếu không có userID
  }

  Widget _buildTaskDetailRow(String title, String value, IconData icon, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.yellow : Colors.blue, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(value, style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
