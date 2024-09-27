class Task {
  int? taskID; // taskID là có thể null
  final int userID; // userID là bắt buộc
  final String title; // title là bắt buộc
  final DateTime startDate; // startDate là bắt buộc
  final DateTime endDate; // endDate là bắt buộc
  String? location; // location là có thể null
  String? assignedTo; // assignedTo là có thể null
  String status; // status là bắt buộc, mặc định là 'New'
  int priority; // priority là bắt buộc, mặc định là 1
  String? notes; // notes là có thể null
  final DateTime createdAt; // createdAt mặc định là thời gian hiện tại
  final DateTime updatedAt; // updatedAt mặc định là thời gian hiện tại

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
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // From JSON
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

  // To JSON
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
