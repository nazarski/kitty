import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/date_bloc/date_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/month_picker/overlay_calendar_window.dart';
import 'package:kitty/widgets/month_picker/place_holder.dart';

class MonthPicker extends StatefulWidget {
  const MonthPicker({
    Key? key,
    required this.selectType,
  }) : super(key: key);
  final String selectType;

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  OverlayEntry? _overlayEntry;
  OverlayState? _overlay;
  DateBloc? provider;

  @override
  void dispose() {
    _overlayDispose();
    provider!.close();
    super.dispose();
  }

  @override
  void initState() {
    provider = DateBloc(RepositoryProvider.of<DatabaseRepository>(context));
    super.initState();
  }

  void _overlayDispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  final List<String> listOfMonths = [
    LocaleKeys.months_jan.tr(),
    LocaleKeys.months_feb.tr(),
    LocaleKeys.months_mar.tr(),
    LocaleKeys.months_apr.tr(),
    LocaleKeys.months_may.tr(),
    LocaleKeys.months_jun.tr(),
    LocaleKeys.months_jul.tr(),
    LocaleKeys.months_aug.tr(),
    LocaleKeys.months_sep.tr(),
    LocaleKeys.months_oct.tr(),
    LocaleKeys.months_nov.tr(),
    LocaleKeys.months_dec.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => provider!..add(InitialDateEvent()),
      child: BlocConsumer<DateBloc, DateState>(
        listenWhen: (previous, current) {
          return (previous.selectedYear != current.selectedYear ||
                  previous.selectedMonth != current.selectedMonth) &&
              current.selectedYear != 0;
        },
        listener: (context, state) {
          context.read<EntriesControlBloc>().add(SetDateToEntriesEvent(
              type: widget.selectType,
              year: state.selectedYear,
              month: state.selectedMonth));
        },
        builder: (context, state) {
          if (state.selectedYear == 0) {
            return PlaceHolder(listOfMonths: listOfMonths);
          }
          final bool back = state.allYears.contains(state.selectedYear - 1) ||
              state.selectedMonth != state.activeMonths.last &&
                  state.selectedYear == state.year;
          final bool forward =
              state.allYears.contains(state.selectedYear + 1) ||
                  state.selectedMonth != state.activeMonths.first &&
                      state.selectedYear == state.year;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: back
                      ? () {
                          context
                              .read<DateBloc>()
                              .add(CallMonthDateEvent('back'));
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: back ? AppColors.subTitle : Colors.white,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showOverlay(context);
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
            ),
          );
        },
      ),
    );
  }

  _showOverlay(BuildContext context) {
    _overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    _overlayEntry = OverlayEntry(builder: (_) {
      return BlocProvider.value(
        value: BlocProvider.of<DateBloc>(context),
        child: Stack(children: [
          InkWell(
            onTap: () {
              context.read<DateBloc>().add(ToSelectedDateEvent());
              _overlayDispose();
            },
          ),
          Positioned(
              width: size.width,
              top: offset.dy + size.height,
              left: offset.dx,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OverlayCalendarWindow(
                  listOfMonths: listOfMonths,
                ),
              ))
        ]),
      );
    });
    _overlay!.insert(_overlayEntry!);
  }
}
