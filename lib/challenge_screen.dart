import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/data/AuthService.dart';

class ChallengeScreen extends StatefulWidget {
  final bool isDarkMode;
  final int userId;

  ChallengeScreen({required this.isDarkMode, required this.userId});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late Future<List<Task>?> _tasks;

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Tải danh sách công việc khi màn hình được khởi tạo
  }

  void _loadTasks() {
    AuthService authService = AuthService();
    _tasks = authService.getTasksByUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quá Trình' ,style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),),
        backgroundColor: widget.isDarkMode ? Color(0xFF44462E) : Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: widget.isDarkMode ? Colors.black : Colors.white, // Thay đổi màu nền ở đây
        child: FutureBuilder<List<Task>?>(  // Chờ danh sách các công việc
          future: _tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _loadTasks,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No tasks available.'));
            }

            final tasks = snapshot.data!;
            final newTasks = tasks.where((task) => task.status == 'New').toList();
            final inProgressTasks = tasks.where((task) => task.status == 'Inprogress').toList();
            final completedTasks = tasks.where((task) => task.status == 'Completed').toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Biểu đồ hình tròn hiển thị số lượng công việc
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: newTasks.length.toDouble(),
                            title: 'New\n${newTasks.length}',
                            color: Colors.red,
                            radius: 50,
                          ),
                          PieChartSectionData(
                            value: inProgressTasks.length.toDouble(),
                            title: 'In Progress\n${inProgressTasks.length}',
                            color: Colors.blue,
                            radius: 50,
                          ),
                          PieChartSectionData(
                            value: completedTasks.length.toDouble(),
                            title: 'Completed\n${completedTasks.length}',
                            color: Colors.green,
                            radius: 50,
                          ),
                        ],
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Tổng số công việc
                  Text(
                    'Total Tasks: ${tasks.length}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTaskColumn('New Tasks', newTasks, Colors.red),
                        _buildTaskColumn('In Progress', inProgressTasks, Colors.blue),
                        _buildTaskColumn('Completed', completedTasks, Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTaskColumn(String title, List<Task> tasks, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (tasks.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      color: color, // Sử dụng màu tương ứng với từng cột
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date: ${task.startDate.toLocal()}',
                              style: TextStyle(color: widget.isDarkMode ? Colors.grey[300] : Colors.black),
                            ),
                            Text(
                              'End Date: ${task.endDate.toLocal()}',
                              style: TextStyle(color: widget.isDarkMode ? Colors.grey[300] : Colors.black),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: task.status == 'Completed', // Kiểm tra trạng thái của task
                          onChanged: (value) {
                            // Cập nhật trạng thái của task khi checkbox được tích hoặc bỏ
                            String newStatus = value == true ? 'Completed' : 'Inprogress'; // Cập nhật trạng thái

                            // Gọi API để cập nhật trạng thái trên server
                            AuthService authService = AuthService();
                            authService.updateTaskStatus(task.taskID!, newStatus).then((success) {
                              if (success) {
                                setState(() {
                                  task.status = newStatus; // Cập nhật trạng thái trong UI
                                });
                              } else {
                                // Nếu có lỗi, bạn có thể hiển thị thông báo lỗi cho người dùng
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Failed to update task status.'),
                                ));
                              }
                            });
                          },
                          activeColor: Colors.green, // Màu xanh khi checkbox được tích
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No tasks available in this category.',
                  style: TextStyle(color: widget.isDarkMode ? Colors.white70 : Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
