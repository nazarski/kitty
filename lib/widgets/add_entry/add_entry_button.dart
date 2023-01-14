import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitty/bloc/database_bloc/database_bloc.dart';
import 'package:kitty/resources/app_text_styles.dart';

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({
    Key? key,
    required this.option,
    required this.isActive,
    required this.amount,
    required this.description,
  }) : super(key: key);

  final String option;
  final bool isActive;
  final String amount;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppStyles.buttonStyle,
      onPressed: isActive
          ? () => context.read<DatabaseBloc>().add(
                CreateEntryEvent(
                  amount: amount,
                  description: description,
                ),
              )
          : null,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Center(
          child: Text('Add new $option'),
        ),
      ),
    );
  }
}
