import 'package:flutter/material.dart';
import 'package:kitty/resources/app_text_styles.dart';

class AddEntryButton extends StatelessWidget {
  const AddEntryButton({
    Key? key,
    required this.option,
    required this.isActive,
  }) : super(key: key);

  final String option;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: AppStyles.buttonStyle,
      onPressed: isActive ? () {} : null,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: Center(
          child: Text('Add new $option'),
        ),
      ),
    );
  }
}