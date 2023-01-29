import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/resources/initial_values.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {

  final List<bool> _listOfBools = List.generate(InitialValues.faq.length, (_) {
    return false;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        text: 'FAQ',
      ),
      body: ExpansionPanelList(
        children: List.generate(InitialValues.faq.length, (i) {
          return ExpansionPanel(
            isExpanded: _listOfBools[i],
              headerBuilder: (context, isOpen) {
            return Text(InitialValues.faq[i]['question']!, style: AppStyles.buttonBlack,);
          }, body: Text(InitialValues.faq[i]['answer']!, style: AppStyles.body2,));
        }),
        expansionCallback: (i, isOpen){

        },
      ),
    );
  }
}
