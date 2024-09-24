import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool weatherEnabled = false;
  bool notificationEnabled = true;
  bool alarmEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212020), // Nền tối
      appBar: AppBar(
        title: Text('Cài Đặt'),
        backgroundColor: Color(0xFF44462E), // Màu của AppBar
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

          SizedBox(height: 20),
          // Container chứa các mục "Theo dõi tôi"
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF44462E), // Màu nền của Container
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
        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
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
        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
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
        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      ),
      onTap: () {
        // Xử lý sự kiện khi click vào các mục social
      },
    );
  }
}
