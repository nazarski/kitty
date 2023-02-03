import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_icons.dart';
import 'package:kitty/ui/bloc/user_bloc/user_bloc.dart';
import 'package:kitty/utils/helper.dart';

class AvatarPick extends StatefulWidget {
  const AvatarPick({Key? key}) : super(key: key);

  @override
  State<AvatarPick> createState() => _AvatarPickState();
}

class _AvatarPickState extends State<AvatarPick> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return DottedBorder(
          borderType: BorderType.Circle,
          strokeWidth: 2,
          dashPattern: const [5, 2],
          child: Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: InkWell(
                      onTap:
                          () async {
                        final image = await pickImage();
                        if (mounted) {
                          context.read<UserBloc>().add(
                              ChooseAvatarEvent(image));
                        }
                      },
                      child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                      if(state.avatarLocalPath.isEmpty)...[
                  SvgPicture.asset(
                  AppIcons.noAvatar, width: 96, height: 96, color:
                AppColors.subTitle,), ]else...[
            Image.file(File(state.avatarLocalPath), width: 96,
            height: 96, fit: BoxFit.cover,)
          ],
          Center(child: SvgPicture.asset(AppIcons.addPlus,
            color: AppColors.activeBlue,))
          ],
        ),
        )
        ),
        ),
        ),
        );
        },
    );
  }
}
