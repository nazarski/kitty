import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.basicGrey,
          ),
          padding: const EdgeInsets.only(
              top: 12, left: 16, bottom: 24, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                LocaleKeys.settings.tr(),
                style: AppStyles.menuPageTitle,
              ),
              const SizedBox(
                height: 16,
              ),
              Wrap(
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(state.user.name.substring(0,1), style:
                    AppStyles
                        .menuPageTitle),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user.name,
                        style: AppStyles.subtitle1,
                      ),
                      Text(
                        state.user.email,
                        style: AppStyles.caption,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}