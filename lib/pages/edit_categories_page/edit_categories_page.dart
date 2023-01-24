import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/icon_view.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class EditCategoriesPage extends StatefulWidget {
  const EditCategoriesPage({Key? key}) : super(key: key);
  static const routeName = '/edit_categories_page';

  @override
  State<EditCategoriesPage> createState() => _EditCategoriesPageState();
}

class _EditCategoriesPageState extends State<EditCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        text: 'Manage categories',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text(
          'Add new category',
          style: AppStyles.buttonWhite,
        ),
      ),
      body: BlocBuilder<EntriesControlBloc, EntriesControlState>(
        builder: (context, state) {
          return ReorderableListView.builder(
              onReorderStart: (_) {
                HapticFeedback.vibrate();
              },
              padding: EdgeInsets.only(top: 12),
              itemBuilder: (context, index) {
                return ListTile(
                  key: ValueKey(index),
                  leading: SizedBox(
                    height: 40,
                    child: IconView(
                      icon: state.expCategories[index].icon.localPath,
                      color: state.expCategories[index].icon.color,
                    ),
                  ),
                  title: Text(state.expCategories[index].title,
                      style: AppStyles.body2),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Edit',
                            style: AppStyles.button,
                          )),
                      const SizedBox(
                        width: 12,
                      ),
                      const Icon(
                        Icons.drag_indicator_outlined,
                        color: AppColors.subTitle,
                      )
                    ],
                  ),
                );
              },
              itemCount: state.expCategories.length,
              onReorder: (oldIndex, newIndex) {
                context.read<EntriesControlBloc>().add(ReorderCategoriesEvent(
                    oldIndex: oldIndex, newIndex: newIndex));
              });
        },
      ),
    );
  }
}
