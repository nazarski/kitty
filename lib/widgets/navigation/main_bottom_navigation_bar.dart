import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/resources/app_icons.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    Key? key,
    required this.navigateTo, required this.currentIndex,
  }) : super(key: key);

final ValueChanged navigateTo;
final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: navigateTo,
      currentIndex: currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcons.pieChart),
          activeIcon: SvgPicture.asset(AppIcons.pieChartFilled),
          label: 'Statistics',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcons.home),
          activeIcon: SvgPicture.asset(AppIcons.homeFilled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppIcons.settings),
          activeIcon: SvgPicture.asset(AppIcons.settingsFilled),
          label: 'Settings',
        ),
      ],
    );
  }
}