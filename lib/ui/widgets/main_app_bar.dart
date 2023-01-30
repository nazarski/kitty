import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/ui/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/ui/screens/search_screen/search_screen.dart';

import 'mini_avatar.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  const MainAppBar({
    Key? key, required this.leading,
  }) : super(key: key);
final Widget leading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: leading,
        actions: [
          IconButton(
              onPressed: () {
                context
                    .read<NavigationBloc>()
                    .add(NavigateTab(tabIndex: 5, route: SearchScreen
                    .routeName));
              },
              icon: SvgPicture.asset(AppIcons.search)),
          const SizedBox(
            width: 16,
          ),
          const MiniAvatar()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(0, 48);
}


