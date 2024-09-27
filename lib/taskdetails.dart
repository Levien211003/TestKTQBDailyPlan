import 'package:flutter/material.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:intl/intl.dart';

class TaskDetails extends StatelessWidget {
  final Task task;

  TaskDetails({required this.task});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title, style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTaskDetailRow('Title', task.title, Icons.title, isDarkMode),
            _buildTaskDetailRow('Start Date', DateFormat('dd/MM/yyyy').format(task.startDate), Icons.date_range, isDarkMode),
            _buildTaskDetailRow('End Date', DateFormat('dd/MM/yyyy').format(task.endDate), Icons.date_range, isDarkMode),
            _buildTaskDetailRow('Location', task.location ?? 'N/A', Icons.location_on, isDarkMode),
            _buildTaskDetailRow('Assigned To', task.assignedTo ?? 'N/A', Icons.person, isDarkMode),
            _buildTaskDetailRow('Status', task.status, Icons.check_circle, isDarkMode),
            _buildTaskDetailRow('Priority', task.priority.toString(), Icons.priority_high, isDarkMode),
            _buildTaskDetailRow('Notes', task.notes ?? 'N/A', Icons.note, isDarkMode),
            _buildTaskDetailRow('Created At', DateFormat('dd/MM/yyyy').format(task.createdAt), Icons.create, isDarkMode),
            _buildTaskDetailRow('Updated At', DateFormat('dd/MM/yyyy').format(task.updatedAt), Icons.update, isDarkMode),
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
              // Navigate to edit task screen (implement this)
            },
          ),
        ),
        FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.red : Colors.redAccent,
          child: Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            // Implement delete functionality (show confirmation dialog)
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete Task', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
                  content: Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Call delete function here
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text('Yes', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: Text('No', style: TextStyle(color: isDarkMode ? Colors.yellow : Colors.blue)),
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

  Widget _buildTaskDetailRow(String title, String value, IconData icon, bool isDarkMode) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 4, // Add elevation for a shadow effect
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.yellow : Colors.blue, size: 28), // Bigger icon for visibility
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
