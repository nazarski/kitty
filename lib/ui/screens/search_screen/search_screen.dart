import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/repository/database_repository.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/ui/bloc/entries_control_bloc/entries_control_bloc.dart';
import 'package:kitty/ui/bloc/search_bloc/search_bloc.dart';
import 'package:kitty/ui/widgets/entries_list.dart';

import 'widgets/category_filter_chip.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const routeName = 'search_page';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(RepositoryProvider.of<DatabaseRepository>(context))
            ..add(GetAvailableSearchData()),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          context
              .read<EntriesControlBloc>()
              .add(SearchEntries(state.searchCategories, state.searchValue));
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: ()async{
              context.read<EntriesControlBloc>().add(CallAllDataEvent());
              return true;
            },
            child: SafeArea(
              child: Scaffold(
                body: Column(
                  children: [
                    TextField(
                      controller: controller,
                      onEditingComplete: () {
                        context
                            .read<SearchBloc>()
                            .add(SaveRecentSearchValue(controller.text));
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (String value) {
                        context
                            .read<SearchBloc>()
                            .add(SearchByValueEvent(searchValue: value));
                      },
                      cursorColor: AppColors.mainText,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<EntriesControlBloc>().add(CallAllDataEvent());
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: AppColors.mainText,
                            ),
                          ),
                          hintText: LocaleKeys.search.tr(),
                          hintStyle: AppStyles.body2),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return CategoryFilterChip(
                              icon:
                                  state.availableCategories[index].icon.localPath,
                              title: state.availableCategories[index].title,
                              categoryId:
                                  state.availableCategories[index].categoryId,
                              selected: state.searchCategories.contains(
                                  state.availableCategories[index].categoryId),
                            );
                          },
                          separatorBuilder: (_, __) {
                            return const SizedBox(
                              width: 12,
                            );
                          },
                          itemCount: state.availableCategories.length),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (state.searchValue.isEmpty &&
                        state.searchCategories.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children:
                              List.generate(state.searchHistory.length, (index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.history,
                                  color: AppColors.subTitle,
                                ),
                                Text(
                                  state.searchHistory[index],
                                  style: AppStyles.body2,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.north_west,
                                    color: AppColors.subTitle,
                                  ),
                                  onPressed: () {
                                    context.read<SearchBloc>().add(
                                        SearchByValueEvent(
                                            searchValue:
                                                state.searchHistory[index]));
                                    controller.text = state.searchHistory[index];
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                      )
                    ] else ...[
                      const EntriesListBuilder(),
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
