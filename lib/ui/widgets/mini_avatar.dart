import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/ui/bloc/user_bloc/user_bloc.dart';

class MiniAvatar extends StatelessWidget {
  const MiniAvatar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Container(
          height: 32,
          width: 32,
          decoration: const BoxDecoration(
            color: AppColors.basicGrey,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: state.user.avatarLocalPath.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
                child: Image.file(
                    File(state.user.avatarLocalPath,),fit: BoxFit.cover))
                : Text(
                    context.read<UserBloc>().state.user.name.substring(0, 1),
                    style: AppStyles.buttonBlack,
                  ),
          ),
        );
      },
    );
  }
}
