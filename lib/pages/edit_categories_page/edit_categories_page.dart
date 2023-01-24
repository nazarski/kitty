import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/widgets/icon_view.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class EditCategoriesPage extends StatefulWidget {
  const EditCategoriesPage({Key? key}) : super(key: key);

  @override
  State<EditCategoriesPage> createState() => _EditCategoriesPageState();
}

class _EditCategoriesPageState extends State<EditCategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        text: 'Manage categories',
      ),
      body: BlocBuilder<EntriesControlBloc, EntriesControlState>(
        builder: (context, state) {
          return ReorderableListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconView(
                    icon: state.expCategories[index].icon.localPath,
                    color: state.expCategories[index].icon.color,
                  ),
                  title: Text(state.expCategories[index].title, ),
                );
              },
              itemCount: state.expCategories.length,
              onReorder: (oldIndex, newIndex) {});
        },
      ),
    );
  }
}
