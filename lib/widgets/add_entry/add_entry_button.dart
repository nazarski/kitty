import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/entries_control_bloc.dart';
import 'package:kitty/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_text_styles.dart';

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({
    Key? key,
    required this.option,
    required this.isActive,
    required this.action,
  }) : super(key: key);

  final String option;
  final bool isActive;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppStyles.buttonStyle,
      onPressed: isActive ? action : null,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Center(
          child: option == 'income'
              ? Text(LocaleKeys.add_income.tr())
              : option == 'expense'
                  ? Text(LocaleKeys.add_expense.tr())
                  : Text(LocaleKeys.add_smth.tr()),
        ),
      ),
    );
  }
}
