import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/bloc/search_bloc/search_bloc.dart';
import 'package:kitty/repository/database_repository.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/widgets/home_page/entries_list.dart';
import 'package:kitty/widgets/search_page/category_filter_chip.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const routeName = '/search_page';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          return SafeArea(
            child: Column(
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
                            context.read<NavigationBloc>().add(NavigationPop());
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.mainText,
                          )),
                      hintText: 'Search for notes, categories or labels',
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
                          icon: state.availableCategories[index].icon.localPath,
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
                          children: List.generate(state.searchHistory.length, (index) {
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
                                  onPressed: (){
                                    context
                                        .read<SearchBloc>()
                                        .add(SearchByValueEvent(searchValue: state.searchHistory[index]));
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
          );
        },
      ),
    );
  }
}
