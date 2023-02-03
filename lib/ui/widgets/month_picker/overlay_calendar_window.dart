import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/domain/resources/initial_values.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/ui/bloc/date_bloc/date_bloc.dart';

import 'month_item.dart';

class OverlayCalendarWindow extends StatelessWidget {
  const OverlayCalendarWindow({
    Key? key,
  }) : super(key: key);

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
              Text(
                LocaleKeys.pick_month.tr(),
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
                      month: InitialValues.listOfMonths[index].substring(0, 3),
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