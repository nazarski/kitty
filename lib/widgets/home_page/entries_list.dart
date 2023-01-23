import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/utils/helper.dart';
import 'package:kitty/widgets/icon_view.dart';

class EntriesListBuilder extends StatefulWidget {
  const EntriesListBuilder({
    Key? key,
  }) : super(key: key);

  @override
  State<EntriesListBuilder> createState() => _EntriesListBuilderState();
}

class _EntriesListBuilderState extends State<EntriesListBuilder> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  void _showDeleteOption(BuildContext context, String title, int id) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final delete = await showMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),
      items: [PopupMenuItem(
        value: 'delete',
          child: Text('Delete $title'))],
    ).then((value) {
      if (value != null) {
        context.read<EntriesControlBloc>().add(DeleteEntryEvent(id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntriesControlBloc, EntriesControlState>(
      builder: (context, state) {
        if (state.status == DatabaseStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.entries.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderGrey, width: 1)),
            child: const Center(
              child: Text('No expenses found, tap "Add new"'),
            ),
          );
        }
        final entryData = state.entries.entries;
        final categories = [...state.inCategories, ...state.expCategories];
        return Flexible(
          fit: FlexFit.loose,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: state.entries.length,
            itemBuilder: (
              context,
              index,
            ) {
              final blockEntries = entryData.elementAt(index).value;
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.borderGrey, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entryData.elementAt(index).key,
                          style: AppStyles.overline,
                        ),
                        Text(
                          getSum(entryData.elementAt(index).value),
                          style: AppStyles.overline,
                        )
                      ],
                    ),
                    ...List.generate(blockEntries.length, (index) {
                      final category = categories.firstWhere((element) {
                        return element.categoryId ==
                            blockEntries[index].categoryId;
                      });
                      return GestureDetector(
                        onTapDown: (details) => _getTapPosition(details),
                        onLongPress: () {
                          if (blockEntries[index].description.isNotEmpty) {
                            _showDeleteOption(
                                context,
                                blockEntries[index].description,
                                blockEntries[index].expenseId);
                          } else {
                            _showDeleteOption(
                                context,
                                '${category.title} transaction',
                                blockEntries[index].expenseId);
                          }
                        },
                        child: ListTile(
                          leading: IconView(
                            icon: category.icon.localPath,
                            color: category.icon.color,
                          ),
                          title: Text(
                            blockEntries[index].description.isNotEmpty
                                ? blockEntries[index].description
                                : category.title,
                            style: AppStyles.body2,
                          ),
                          subtitle: Text(
                            blockEntries[index].description.isNotEmpty
                                ? category.title
                                : blockEntries[index].description,
                            style: AppStyles.caption,
                          ),
                          trailing: Text(
                            '${blockEntries[index].amount}',
                            style: blockEntries[index].amount < 0
                                ? AppStyles.appRed
                                : AppStyles.appGreen,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) {
              return const SizedBox(
                height: 10,
              );
            },
          ),
        );
      },
    );
  }
}
