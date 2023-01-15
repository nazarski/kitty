import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/entries_list.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = 'home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  OverlayEntry? _overlayEntry;
  // @override
  // void initState() {
  //   super.initState();
  // }
  _showOverlay(BuildContext context){
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(builder: (context){
      return Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        child: Container(
          height: 100,
          color: AppColors.appGreen,
        ),
      );
    });


    overlay!.insert(_overlayEntry!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomePageAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: SvgPicture.asset(
          AppIcons.addPlus,
          color: Colors.white,
        ),
        label: const Text('Add new'),
        onPressed: () {
          context
              .read<NavigationBloc>()
              .add(NavigateTab(tabIndex: 3, route: AddEntry.routeName));
        },
      ),
      body: BlocBuilder<DatabaseBloc, DatabaseState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.subTitle,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_)=>
                            _showOverlay(context));

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.basicGrey),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.subTitle,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'January, 2023',
                              style: AppStyles.buttonBlack,
                            )
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: AppColors.subTitle),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.borderGrey, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.expenses,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '-12000',
                            style: AppStyles.appRed,
                          ),
                          const Text(
                            'Expenses',
                            style: AppStyles.caption,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.wallet,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '48000',
                            style: AppStyles.appGreen,
                          ),
                          const Text(
                            'Balance',
                            style: AppStyles.caption,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.institute,
                            color: AppColors.subTitle,
                          ),
                          const Text(
                            '70000',
                            style: AppStyles.buttonBlack,
                          ),
                          const Text(
                            'Income',
                            style: AppStyles.caption,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                EntriesListBuilder()
              ],
            ),
          );
        },
      ),
    );
  }
}
