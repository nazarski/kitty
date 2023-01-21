import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

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
    return BlocBuilder<EntriesControlBloc, EntriesControl>(
      builder: (context, state) {
        return SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
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
              ),
              ListView.separated(
                  itemBuilder: (context, index) {
                    return FilterChip(
                        avatar: SvgPicture.asset(
                            state.allCategories[index].icon.localPath),
                        label: Text(state.allCategories[index].title),
                        onSelected: (bool value) {
                        });
                  },
                  separatorBuilder: (_, __) {
                    return const SizedBox(
                      width: 12,
                    );
                  },
                  itemCount: state.allCategories.length)
            ],
          ),
        );
      },
    );
  }
}
