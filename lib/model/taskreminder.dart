class TaskReminder {
  int reminderID;  // Khóa chính
  int taskID;
  DateTime reminderTime;  // Thời gian nhắc nhở
  bool isNotified;

  // Constructor
  TaskReminder({
    required this.reminderID,
    required this.taskID,
    required this.reminderTime,
    required this.isNotified,
  });

  // Phương thức để tạo từ Map
  factory TaskReminder.fromMap(Map<String, dynamic> map) {
    return TaskReminder(
      reminderID: map['ReminderID'],
      taskID: map['TaskID'],
      reminderTime: DateTime.parse(map['ReminderTime']),
      isNotified: map['IsNotified'] == 1, // Giả sử IsNotified lưu dưới dạng int
    );
  }

  // Phương thức để chuyển đổi thành Map
  Map<String, dynamic> toMap() {
    return {
      'ReminderID': reminderID,
      'TaskID': taskID,
      'ReminderTime': reminderTime.toIso8601String(),
      'IsNotified': isNotified ? 1 : 0, // Chuyển đổi về int
    };
  }
}
