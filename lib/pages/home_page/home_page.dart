import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/bloc/date_bloc/date_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/pages/add_entry/add_entry.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_icons.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/utils/helper.dart';
import 'package:kitty/widgets/home_page/entries_list.dart';
import 'package:kitty/widgets/home_page/home_page_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = 'home_page';

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
      body: BlocConsumer<DatabaseBloc, DatabaseState>(
        listener: (context, state) {
          if (state.entriesData.isNotEmpty) {
            BlocProvider.of<DateBloc>(context).add(
              InitialDateEvent(
                state.entriesData,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Column(
              children: [
                if (state.entries.isNotEmpty) ...[
                  const MonthPicker()
                ] else ...[
                  const SizedBox.shrink()
                ],
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
                const EntriesListBuilder()
              ],
            ),
          );
        },
      ),
    );
  }
}

class MonthPicker extends StatefulWidget {
  const MonthPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayDispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
void _overlayDispose(){
    context.read<DateBloc>().add(ToDefaultsDateEvent());
    _overlayEntry!.remove();
    _overlayEntry!.dispose();
}
  _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(builder: (context) {
      return Stack(children: [
        InkWell(
          onTap: () {
            _overlayDispose();
          },
        ),
        Positioned(
            width: size.width,
            top: offset.dy + size.height,
            left: offset.dx,
            child: OverlayPicker(
              listOfMonths: listOfMonths,
            ))
      ]);
    });
    overlay!.insert(_overlayEntry!);
  }

  final List<String> listOfMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateBloc, DateState>(
      builder: (context, state) {
        final bool back = state.allYears.contains(state.selectedYear - 1) ||
            state.selectedMonth != state.activeMonths.last && state
                .selectedYear == state.year;

        final bool forward =  state.allYears.contains(state.selectedYear + 1)||
            state.selectedMonth != state.activeMonths.first && state
                .selectedYear == state.year;


        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: back
                  ? () {
                      context.read<DateBloc>().add(CallMonthDateEvent('back'));
                    }
                  : null,
              icon: Icon(
                Icons.arrow_back_ios,
                color: back ? AppColors.subTitle : Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _showOverlay(context));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.basicGrey),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.subTitle,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${listOfMonths[state.selectedMonth - 1]}, ${state.selectedYear}',
                      style: AppStyles.buttonBlack,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: forward
                  ? () {
                      context
                          .read<DateBloc>()
                          .add(CallMonthDateEvent('forward'));
                    }
                  : null,
              icon: Icon(Icons.arrow_forward_ios,
                  color: forward ? AppColors.subTitle : Colors.white),
            ),
          ],
        );
      },
    );
  }
}

class OverlayPicker extends StatefulWidget {
  const OverlayPicker({
    Key? key,
    required this.listOfMonths,
  }) : super(key: key);
  final List<String> listOfMonths;

  @override
  State<OverlayPicker> createState() => _OverlayPickerState();
}

class _OverlayPickerState extends State<OverlayPicker> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateBloc, DateState>(
      builder: (context, state) {
        final bool back = state.allYears.last != state.year;
        final bool forward = state.allYears.first != state.year;
        return Container(
          width: MediaQuery.of(context).size.width - 32,
          padding:
              const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: AppColors.title.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 7)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'PICK A MONTH',
                style: AppStyles.overline,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                IconButton(
                  iconSize: 14,
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: back ? AppColors.subTitle : Colors.white,
                  ),
                  onPressed: back
                      ? () {
                          context
                              .read<DateBloc>()
                              .add(CallYearDateEvent('back'));
                        }
                      : null,
                ),
                Text(
                  '${state.year}',
                  style: AppStyles.overline,
                ),
                IconButton(
                  iconSize: 14,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: forward ? AppColors.subTitle : Colors.white,
                  ),
                  onPressed: forward
                      ? () {
                          context
                              .read<DateBloc>()
                              .add(CallYearDateEvent('forward'));
                        }
                      : null,
                ),
              ]),
              Flexible(
                child: GridView.count(
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 20,
                  padding: const EdgeInsets.only(top: 8),
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List.generate(12, (index) {
                    return MonthItem(
                      isActive: state.selectedYear == state.year &&
                          state.selectedMonth == index + 1,
                      month: widget.listOfMonths[index].substring(0, 3),
                      inRange: state.activeMonths.contains(index + 1),
                      onTap: () {
                        context.read<DateBloc>().add(
                            SetDateEvent(month: index + 1, year: state.year));
                      },
                    );
                  }),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class MonthItem extends StatelessWidget {
  const MonthItem({
    Key? key,
    required this.month,
    required this.isActive,
    required this.inRange,
    required this.onTap,
  }) : super(key: key);
  final String month;
  final bool isActive;
  final bool inRange;
  final VoidCallback onTap;

  MonthItemStatus _getStatus() {
    if (isActive) {
      return MonthItemStatus.selected;
    }
    if (inRange) {
      return MonthItemStatus.enabled;
    }
    return MonthItemStatus.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatus();
    switch (status) {
      case MonthItemStatus.disabled:
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              month,
              style: AppStyles.buttonInactive,
            ),
          ),
        );
      case MonthItemStatus.enabled:
        return InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGrey)),
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: double.infinity,
            child: Center(
              child: Text(
                month,
                style: AppStyles.buttonBlack,
              ),
            ),
          ),
        );
      case MonthItemStatus.selected:
        return Container(
          decoration: BoxDecoration(
              color: AppColors.activeBlue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey)),
          padding: const EdgeInsets.symmetric(vertical: 8),
          width: double.infinity,
          child: Center(
            child: Text(
              month,
              style: AppStyles.buttonWhite,
            ),
          ),
        );
    }
  }
}

enum MonthItemStatus { disabled, enabled, selected }
