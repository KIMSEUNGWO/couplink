
import 'package:couplink_app/component/bottom_bar_widget.dart';
import 'package:couplink_app/component/svg_icon.dart';
import 'package:couplink_app/widget/calendar_page.dart';
import 'package:couplink_app/widget/my_page.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  late final PageController _pageController;
  int _currentIndex = 0;


  _onChangePage(int page) {
    if (_currentIndex == page) return;

    setState(() => _currentIndex = page);
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          CalendarPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        height: 60,
        children: [
          BottomIcon(
            sIcon: SIcon.calendar,
            title: '일정',
            callback: () => _onChangePage(0),
            isPressed: _currentIndex == 0,
          ),
          BottomIcon(
            sIcon: SIcon.user,
            title: '프로필',
            callback: () => _onChangePage(1),
            isPressed: _currentIndex == 1,
          ),
        ],
      ),
    );
  }
}
