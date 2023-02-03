import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/widgets/icon_view.dart';

class StatisticsElementBuilder extends StatelessWidget {
  const StatisticsElementBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntriesControlBloc, EntriesControlState>(
      builder: (context, state) {
        return Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.statistics.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconView(
                    icon: state.statistics[index].icon.localPath,
                    color: state.statistics[index].icon.color,
                  ),
                  title: Text(
                    state.statistics[index].categoryTitle,
                  ),
                  subtitle: Text(
                      '${state.statistics[index].countOfEntries} transactions'),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${state.statistics[index].totalAmount}',
                        style: AppStyles.appRed,
                      ),
                      Text(
                          '${(state.statistics[index].monthShare).round()}%')
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
