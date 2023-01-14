import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/models/entry_category_model/entry_category.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/icon_view.dart';

class EntriesListBuilder extends StatelessWidget {
  const EntriesListBuilder({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: state.entries.length,
          itemBuilder: (context, index,) {
            final EntryCategory category =
            state.expCategories.firstWhere((element) {
              return element.categoryId == state.entries[index].categoryId;
            });
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderGrey,  width: 1),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('data', style: AppStyles.overline,),
                      Text('data', style: AppStyles.overline,)
                    ],
                  ),
                  ListTile(
                    leading: IconView(
                      icon: category.icon.localPath,
                      color: category.icon.color,
                    ),
                    title: Text(
                      category.title,
                      style: AppStyles.body2,
                    ),
                    subtitle: Text(
                      state.entries[index].description,
                      style: AppStyles.caption,
                    ),
                    trailing: Text(
                      '-${state.entries[index].amount}',
                      style: AppStyles.appRed,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}