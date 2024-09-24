import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  final bool isDarkMode; // Nhận trạng thái dark mode từ ngoài
  final Function(bool) onDarkModeChanged; // Hàm callback để thông báo về sự thay đổi

  SettingScreen({required this.isDarkMode, required this.onDarkModeChanged});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  bool weatherEnabled = false;
  bool notificationEnabled = true;
  bool alarmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF212020) : Colors.white, // Nền sáng/tối tùy thuộc vào dark mode
      appBar: AppBar(
        title: Text('Cài Đặt'),
        backgroundColor: isDarkMode ? Color(0xFF44462E) : Color(0xFF67A867), // Màu của AppBar
        automaticallyImplyLeading: false, // Không tự động thêm nút trở về
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Các mục cài đặt
          _buildSettingsItem(Icons.calendar_today, 'Lịch của bạn'),
          _buildSettingsItem(Icons.access_time, 'Định dạng thời gian'),
          _buildSettingsItem(Icons.date_range, 'Định dạng ngày'),
          _buildSettingsItem(Icons.calendar_view_day, 'Bắt đầu Tuần từ'),
          _buildSwitchItem(Icons.cloud, 'Thời tiết', weatherEnabled, (value) {
            setState(() {
              weatherEnabled = value;
            });
          }),
          _buildSettingsItem(Icons.lock, 'Mật khẩu'),
          _buildSwitchItem(Icons.notifications, 'Thông báo', notificationEnabled, (value) {
            setState(() {
              notificationEnabled = value;
            });
          }),
          _buildSwitchItem(Icons.alarm, 'Báo thức', alarmEnabled, (value) {
            setState(() {
              alarmEnabled = value;
            });
          }),
          _buildSettingsItem(Icons.article, 'Điều khoản'),
          _buildSettingsItem(Icons.security, 'Chính sách bảo mật'),
          // Nút Dark Mode
          _buildSwitchItem(Icons.dark_mode, 'Dark Mode', isDarkMode, (value) {
            setState(() {
              isDarkMode = value;
              widget.onDarkModeChanged(value); // Gọi hàm callback
            });
          }),

          SizedBox(height: 20),
          // Container chứa các mục "Theo dõi tôi"
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF44462E) : Color(0xFFE0E0E0), // Màu nền của Container tùy thuộc vào dark mode
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo dõi tôi',
                  style: TextStyle(
                    color: Color(0xFFE2F163),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                _buildSocialItem(Icons.video_library, 'Youtube'),
                _buildSocialItem(Icons.facebook, 'Facebook'),
                _buildSocialItem(Icons.camera_alt, 'Instagram'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget cho mục cài đặt thông thường
  Widget _buildSettingsItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFE2F163)),
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : Colors.black),
      onTap: () {
        // Xử lý sự kiện khi click vào mục cài đặt
      },
    );
  }

  // Widget cho mục cài đặt với switch
  Widget _buildSwitchItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFE2F163)),
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFFE2F163),
      ),
    );
  }

  // Widget cho các mục "Theo dõi tôi"
  Widget _buildSocialItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFFE2F163)),
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'
        ),
      ),
      onTap: () {
        // Xử lý sự kiện khi click vào các mục social
      },
    );
  }
}
