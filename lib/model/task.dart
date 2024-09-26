class Task {
  int? taskID;
  int userID;
  String title;
  DateTime startDate;
  DateTime endDate;
  String? location;
  String? assignedTo;
  String status;
  int priority;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  // Constructor
  Task({
    this.taskID,
    required this.userID,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.location,
    this.assignedTo,
    this.status = 'New',
    this.priority = 1,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  })
      : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // From JSON (chuyển từ JSON sang Task object)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskID: json['taskID'],
      userID: json['userID'],
      title: json['title'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      location: json['location'],
      assignedTo: json['assignedTo'],
      status: json['status'],
      priority: json['priority'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // To JSON (chuyển từ Task object sang JSON)
  // To JSON (chuyển từ Task object sang JSON)
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'title': title,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'assignedTo': assignedTo,
      'status': status,
      'priority': priority,
      'notes': notes,
      // Không gửi taskID, createdAt, updatedAt nếu không cần thiết
    };
  }
}
