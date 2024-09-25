import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'create_challenge.dart'; // Nhập trang CreateChallenge

class ChallengeScreen extends StatefulWidget {
  final bool isDarkMode;

  ChallengeScreen({required this.isDarkMode});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late bool isDarkMode;
  late ScrollController _scrollController;
  late List<DateTime> dates;
  late int currentDateIndex;
  String selectedMonth = "";
  late DateTime selectedDate; 

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    _scrollController = ScrollController();
    dates = getDates();
    selectedDate = DateTime.now(); // Mặc định chọn ngày hôm nay

    // Tìm chỉ số của ngày hôm nay
    currentDateIndex = dates.indexWhere((date) =>
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day);

    // Đặt vị trí cuộn về giữa danh sách (ngày hôm nay)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController
          .jumpTo(currentDateIndex * 88.0); // Chiều rộng của từng item
    });

    // Thiết lập tháng hiện tại là tháng của ngày hôm nay
    selectedMonth = DateFormat('MMMM').format(DateTime.now());
  }

  List<DateTime> getDates() {
    List<DateTime> dates = [];
    DateTime today = DateTime.now();

    // Tạo danh sách ngày với 182 ngày trước và 182 ngày sau
    for (int i = -182; i <= 182; i++) {
      dates.add(today.add(Duration(days: i)));
    }

    return dates;
  }

  void _onDateTap(int index) {
    setState(() {
      currentDateIndex = index;
      selectedDate = dates[index];
      // Cập nhật tháng khi người dùng nhấn vào ngày
      selectedMonth = DateFormat('MMMM').format(selectedDate);
    });
    // Xử lý sự kiện nhấn vào ngày, có thể thêm logic ở đây
    print('Selected Date: $selectedDate');
  }

  void _onSwipe(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      // Vuốt sang trái
      if (currentDateIndex > 0) {
        _scrollController.jumpTo(_scrollController.position.pixels - 88);
        _onDateTap(currentDateIndex - 1);
      }
    } else if (details.delta.dx < 0) {
      // Vuốt sang phải
      if (currentDateIndex < dates.length - 1) {
        _scrollController.jumpTo(_scrollController.position.pixels + 88);
        _onDateTap(currentDateIndex + 1);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToCreateChallenge() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateChallenge()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            selectedMonth.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        backgroundColor: isDarkMode ? Color(0xFF44462E) : Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Phần hiển thị tháng và các ngày
          Container(
            padding: EdgeInsets.all(10),
            color: isDarkMode ? Color(0xFF44462E) : Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add,
                      color: isDarkMode ? Colors.white : Colors.black),
                  onPressed:
                      _navigateToCreateChallenge, // Điều hướng tới CreateChallenge
                ),
              ],
            ),
          ),
          // Phần hiển thị thanh lịch cuộn ngang
          GestureDetector(
            onHorizontalDragUpdate: _onSwipe,
            child: Container(
              height: 100, // Chiều cao cố định cho thanh lịch
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ScrollConfiguration(
                behavior: ScrollBehavior().copyWith(overscroll: true),
                // Loại bỏ hiệu ứng cuộn
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    DateTime date = dates[index];
                    String formattedDate = DateFormat('dd').format(date);
                    String dayOfWeek = DateFormat('E').format(date);
                    bool isToday = date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;

                    // Kiểm tra tháng của ngày hiện tại
                    String monthDisplay = (date.month != DateTime.now().month)
                        ? DateFormat('MMMM').format(date)
                        : '';

                    return GestureDetector(
                      onTap: () => _onDateTap(index),
                      child: Container(
                        width: 80,
                        // Chiều rộng cố định cho mỗi item
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isToday
                              ? Colors.blue
                              : (isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (monthDisplay.isNotEmpty)
                              Text(
                                monthDisplay,
                                // Hiển thị tháng nếu không cùng tháng với hôm nay
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isToday
                                    ? Colors.white
                                    : (isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            Text(
                              dayOfWeek,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            if (isToday)
                              Text(
                                "Today",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Phần hiển thị thông tin hoạt động trong ngày
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.create, size: 40, color: Colors.blue),
                // Biểu tượng hoạt động
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ăn cữ', // Hoạt động
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, dd/MM/yyyy').format(selectedDate),
                      // Ngày tháng
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Phần nội dung chính
          Expanded(
            child: Center(
              child: Text(
                'Welcome to the Favorite Screen',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
    );
  }
}
