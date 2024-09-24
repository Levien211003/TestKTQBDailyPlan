import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode; // Thêm tham số isDarkMode

  HomeScreen({required this.isDarkMode}); // Khởi tạo với isDarkMode

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode ? Color(0xFF212020) : Colors.white, // Sử dụng isDarkMode để xác định màu nền
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Planner',
                    style: TextStyle(
                      color: widget.isDarkMode ? Colors.white : Colors.black, // Thay đổi màu chữ
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(
                    Icons.notifications,
                    color: widget.isDarkMode ? Colors.white : Colors.black, // Thay đổi màu icon
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black), // Thay đổi màu chữ
                weekendTextStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black), // Thay đổi màu chữ
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black, // Thay đổi màu chữ tiêu đề
                  fontSize: 18,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: widget.isDarkMode ? Colors.white : Colors.black, // Thay đổi màu icon
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: widget.isDarkMode ? Colors.white : Colors.black, // Thay đổi màu icon
                ),
              ),
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black), // Thay đổi màu chữ
                weekdayStyle: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black), // Thay đổi màu chữ
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.add, 'Add Task'),
                _buildActionButton(Icons.check_circle, 'Completed'),
                _buildActionButton(Icons.calendar_today, 'Schedule'),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF44462E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Tasks',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  _buildTaskItem('Complete Flutter project', true),
                  _buildTaskItem('Morning Exercise', false),
                  _buildTaskItem('Read 20 pages of book', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo nút hành động
  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: () {
            // Logic cho các hành động
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Widget tạo mục công việc
  Widget _buildTaskItem(String taskName, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            taskName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
