import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final bool isDarkMode; // Nhận trạng thái dark mode từ ngoài
  final Function(bool)
      onDarkModeChanged; // Hàm callback để thông báo về sự thay đổi

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
      backgroundColor: isDarkMode ? Color(0xFF212020) : Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            'CÀI ĐẶT',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF44462E) : Colors.white,
        automaticallyImplyLeading: false,
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
          _buildSwitchItem(
              Icons.notifications, 'Thông báo', notificationEnabled, (value) {
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
              widget.onDarkModeChanged(value);
            });
          }),

          SizedBox(height: 20),
          // Container chứa các mục "Theo dõi tôi"
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF44462E) : Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theo dõi tôi',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                _buildSocialItem(Icons.video_library, 'Youtube',
                    'https://www.youtube.com/@leviennguyen5093'),
                _buildSocialItem(Icons.facebook, 'Facebook',
                    'https://www.facebook.com/sieucapvjppr0iubeDau.0602110'),
                _buildSocialItem(Icons.discord, 'Discord',
                    'https://www.discord.com/'), // Thay link Instagram nếu có
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
      leading: Icon(icon, color: isDarkMode ? Color(0xFFE2F163) : Colors.green),
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          color: isDarkMode ? Colors.white : Colors.black),
      onTap: () {
        // Xử lý sự kiện khi click vào mục cài đặt
      },
    );
  }

  // Widget cho mục cài đặt với switch
  Widget _buildSwitchItem(
      IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Color(0xFFE2F163) : Colors.green),
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: isDarkMode ? Color(0xFFE2F163) : Colors.green,
      ),
    );
  }

  // Widget cho các mục "Theo dõi tôi"
  Widget _buildSocialItem(IconData icon, String title, String url) {
    return ListTile(
      leading: Icon(icon, color: _getIconColor(title)), // Sử dụng màu sắc gốc
      title: Text(
        title,
        style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins'),
      ),
      onTap: () => _launchURL(url), // Gọi hàm mở URL
    );
  }

  // Hàm mở URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Không thể mở $url';
    }
  }

  // Hàm lấy màu icon theo tiêu đề
  Color _getIconColor(String title) {
    switch (title) {
      case 'Youtube':
        return Color(0xFFFF0000); // Màu gốc của YouTube
      case 'Facebook':
        return Color(0xFF4267B2); // Màu gốc của Facebook
      case 'Discord':
        return Color(0xFF7D31F6); // Màu gốc của Instagram
      default:
        return isDarkMode ? Color(0xFFE2F163) : Colors.green; // Màu mặc định
    }
  }
}
