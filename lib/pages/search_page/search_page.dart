import 'package:flutter/material.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
static const routeName = '/search_page';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.arrow_back, color: AppColors.mainText,),
              hintText: 'Search for notes, categories or labels',
              hintStyle: AppStyles.body2
            ),
          ),

        )
      ],
    );
  }
}
