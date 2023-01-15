import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/utils/helper.dart';
import 'package:kitty/widgets/icon_view.dart';

class EntriesListBuilder extends StatelessWidget {
  const EntriesListBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        if (state.status == DatabaseStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.entries.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.borderGrey, width: 1)),
            child: const Center(
              child: Text('No expenses found, tap "Add new"'),
            ),
          );
        }
        final entryData = state.entries.entries;
        return Flexible(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: state.entries.length,
            itemBuilder: (context, index,) {
              final blockEntries = entryData
                  .elementAt(index)
                  .value;
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGrey, width: 1),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entryData
                            .elementAt(index)
                            .key, style: AppStyles
                            .overline,),
                        Text(getSum(entryData
                            .elementAt(index)
                            .value), style:
                        AppStyles.overline,)
                      ],
                    ),
                    ...List.generate(blockEntries.length, (index) {
                      final category = state.expCategories.firstWhere((element) {
                        return element.categoryId ==
                            blockEntries[index].categoryId;
                      });
                      return ListTile(
                        leading: IconView(
                          icon: category.icon.localPath,
                          color: category.icon.color,
                        ),
                        title: Text(
                          category.title,
                          style: AppStyles.body2,
                        ),
                        subtitle: Text(
                          blockEntries[index].description,
                          style: AppStyles.caption,
                        ),
                        trailing: Text(
                          '-${blockEntries[index].amount}',
                          style: AppStyles.appRed,
                        ),
                      );
                    }),
                  ],
                ),
              );
            }, separatorBuilder: (_, __) {
            return const SizedBox(height: 10,);
          },
          ),
        );
      },
    );
  }
}