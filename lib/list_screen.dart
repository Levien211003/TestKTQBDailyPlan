import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testktdailyplan/data/AuthService.dart';
import 'package:testktdailyplan/model/task.dart';
import 'addtask.dart';
import 'dart:math';
import 'taskdetails.dart';

class ListScreen extends StatefulWidget {
  final bool isDarkMode;
  final int userId;

  ListScreen({required this.isDarkMode, required this.userId});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late bool isDarkMode;
  late ScrollController _scrollController;
  late List<DateTime> dates;
  late int currentDateIndex;
  String selectedMonth = "";
  late DateTime selectedDate;
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  bool isLoading = true;
  final AuthService _authService = AuthService();

  // Danh sách biểu tượng và màu sắc
  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.alarm,
    Icons.local_grocery_store,
    Icons.lightbulb,
    Icons.work,
    Icons.person,
    Icons.email,
    Icons.camera,
    Icons.check_circle,
  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    _scrollController = ScrollController();
    dates = getDates();
    selectedDate = DateTime.now();

    currentDateIndex = dates.indexWhere((date) =>
    date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;
      double itemWidth = 88.0;
      double centerOffset = (screenWidth / 2) - (itemWidth / 2);
      double scrollPosition = (currentDateIndex * itemWidth) - centerOffset;
      _scrollController.jumpTo(scrollPosition);
    });

    selectedMonth = DateFormat('MMMM').format(DateTime.now());
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final fetchedTasks = await _authService.getTasksByUser(widget.userId);
    setState(() {
      tasks = fetchedTasks ?? [];
      isLoading = false;
      filteredTasks = _filterTasksBySelectedDate();
    });
  }

  List<DateTime> getDates() {
    DateTime today = DateTime.now();
    return List.generate(19, (index) => today.add(Duration(days: index)));
  }

  void _refreshTasks() {
    _fetchTasks();
  }

  void _onDateTap(int index) {
    setState(() {
      currentDateIndex = index;
      selectedDate = dates[index];
      selectedMonth = DateFormat('MMMM').format(selectedDate);
      filteredTasks = _filterTasksBySelectedDate();
    });

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 88.0;
    double centerOffset = (screenWidth / 2) - (itemWidth / 2);
    double scrollPosition = (index * itemWidth) - centerOffset;
    _scrollController.animateTo(scrollPosition,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  List<Task> _filterTasksBySelectedDate() {
    return tasks.where((task) {
      DateTime start = task.startDate;
      DateTime end = task.endDate;

      return (start.year == selectedDate.year &&
          start.month == selectedDate.month &&
          start.day == selectedDate.day) ||
          (end.year == selectedDate.year &&
              end.month == selectedDate.month &&
              end.day == selectedDate.day) ||
          (start.isBefore(selectedDate) && end.isAfter(selectedDate));
    }).toList();
  }

  void _onSwipe(DragUpdateDetails details) {
    if (details.delta.dx > 0 && currentDateIndex > 0) {
      _onDateTap(currentDateIndex - 1);
    } else if (details.delta.dx < 0 && currentDateIndex < dates.length - 1) {
      _onDateTap(currentDateIndex + 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
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
                  )
                ],
              ),
            ),
            GestureDetector(
              onHorizontalDragUpdate: _onSwipe,
              child: Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ScrollConfiguration(
                  behavior: ScrollBehavior().copyWith(overscroll: true),
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

                      String monthDisplay =
                      (date.month != DateTime.now().month)
                          ? DateFormat('MMMM').format(date)
                          : '';

                      return GestureDetector(
                        onTap: () => _onDateTap(index),
                        child: Container(
                          width: 80,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedDate == date
                                ? Colors.blue
                                : (isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(8),
                            border: isToday && selectedDate != date
                                ? Border.all(color: Colors.blue, width: 2)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (monthDisplay.isNotEmpty)
                                Text(
                                  monthDisplay,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selectedDate == date
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
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              if (isToday)
                                Text(
                                  "Today",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selectedDate == date
                                        ? Colors.white
                                        : Colors.blue,
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
            Expanded(
              child: filteredTasks.isEmpty
                  ? Center(
                child: Text(
                  'No tasks found',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              )
                  : _buildPriorityContainers(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddTask(
              userId: widget.userId,
              onTaskAdded: _refreshTasks,
            ),
          ));
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPriorityContainers() {
    // Phân loại task theo priority
    List<Task> priority1Tasks = filteredTasks.where((task) => task.priority == 1).toList();
    List<Task> priority2Tasks = filteredTasks.where((task) => task.priority == 2).toList();
    List<Task> priority3Tasks = filteredTasks.where((task) => task.priority == 3).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildPriorityContainer("Priority 1", priority1Tasks),
          _buildPriorityContainer("Priority 2", priority2Tasks),
          _buildPriorityContainer("Priority 3", priority3Tasks),
        ],
      ),
    );
  }

  Widget _buildPriorityContainer(String title, List<Task> tasks) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      color: Colors.grey[300],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            onReorder: (int oldIndex, int newIndex) async {
              // Điều chỉnh vị trí newIndex nếu cần thiết
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }

              // Cập nhật vị trí các mục trong danh sách
              setState(() {
                final task = tasks.removeAt(oldIndex);
                tasks.insert(newIndex, task);
              });

              // Cập nhật ưu tiên của chỉ một công việc sau khi kéo thả
              final task = tasks[newIndex]; // Lấy task đã được thay đổi vị trí
              final newPriority = newIndex + 1; // Thiết lập ưu tiên mới dựa trên vị trí

              // Cập nhật trong cơ sở dữ liệu
              final success = await _authService.updatePriority(task.taskID!, newPriority);

              if (success) {
                setState(() {
                  task.priority = newPriority; // Cập nhật giá trị priority trong danh sách
                });
              }
            },

            children: List.generate(tasks.length, (index) {
              Task task = tasks[index];

              // Chọn ngẫu nhiên biểu tượng và màu sắc
              final randomIndex = Random().nextInt(_icons.length);
              IconData randomIcon = _icons[randomIndex];
              Color randomColor = _colors[randomIndex];

              return Card(
                key: ValueKey(task.taskID),
                margin: EdgeInsets.symmetric(vertical: 5),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                child: ListTile(
                  leading: Icon(randomIcon, color: randomColor),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      color: task.status == 'Completed'
                          ? (isDarkMode ? Colors.yellow : Colors.green)
                          : (isDarkMode ? Colors.white : Colors.black),
                      decoration: task.status == 'Completed'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    'Start: ${DateFormat('dd/MM/yyyy').format(task.startDate)} - End: ${DateFormat('dd/MM/yyyy').format(task.endDate)}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TaskDetails(task: task),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
