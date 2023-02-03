import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kitty/domain/resources/app_colors.dart';
import 'package:kitty/domain/resources/app_text_styles.dart';
import 'package:kitty/generated/locale_keys.g.dart';


class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({
    Key? key, required this.onChanged,
  }) : super(key: key);
  final ValueChanged onChanged;
  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  void _showDeleteOption(BuildContext context) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();
    final switchLanguage = await showMenu(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        context: context,
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),
        items: [
          if (context.locale.languageCode == 'uk') ...[
            const PopupMenuItem(value: 'en', child: Text('Switch to English'))
          ] else ...[
            const PopupMenuItem(value: 'uk', child: Text('Українською'))
          ]
        ]).then((value) {
      if (value != null) {
        widget.onChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTapDown: (details) => _getTapPosition(details),
      onTap: () {
        _showDeleteOption(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(
                  Icons.translate_outlined,
                  color: AppColors.subTitle,
                  size: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  LocaleKeys.language.tr(),
                  style: AppStyles.body2,
                )
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.borderGrey,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}