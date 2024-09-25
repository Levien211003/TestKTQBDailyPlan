class User {
  int? userID; // Khóa chính
  String email; // Email người dùng
  String password; // Mật khẩu
  String? studentID; // Mã số sinh viên (nếu sử dụng SSO)
  String? name; // Tên người dùng
  String? profilePicture; // Đường dẫn hình đại diện
  DateTime? lastLogin; // Thời gian đăng nhập lần cuối
  bool isDarkMode; // Chế độ tối
  String language; // Ngôn ngữ

  // Constructor
  User({
    this.userID,
    required this.email,
    required this.password,
    this.studentID,
    this.name,
    this.profilePicture,
    this.lastLogin,
    this.isDarkMode = false, // Giá trị mặc định
    this.language = 'vi', // Giá trị mặc định
  });

  // Phương thức chuyển đổi từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['UserID'],
      email: json['Email'],
      password: json['Password'], // Thông thường bạn không nên lưu mật khẩu ở đây
      studentID: json['StudentID'],
      name: json['Name'],
      profilePicture: json['ProfilePicture'],
      lastLogin: json['LastLogin'] != null ? DateTime.parse(json['LastLogin']) : null,
      isDarkMode: json['IsDarkMode'] == 1, // Hoặc tùy thuộc vào kiểu dữ liệu của bạn
      language: json['Language'] ?? 'vi',
    );
  }

  // Phương thức chuyển đổi sang JSON
  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'Email': email,
      'Password': password, // Không lưu mật khẩu trong JSON
      'StudentID': studentID,
      'Name': name,
      'ProfilePicture': profilePicture,
      'LastLogin': lastLogin?.toIso8601String(),
      'IsDarkMode': isDarkMode ? 1 : 0,
      'Language': language,
    };
  }
}
