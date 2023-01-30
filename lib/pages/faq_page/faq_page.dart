import 'package:flutter/material.dart';
import 'package:kitty/resources/app_colors.dart';
import 'package:kitty/resources/app_text_styles.dart';
import 'package:kitty/resources/initial_values.dart';
import 'package:kitty/utils/helper.dart';
import 'package:kitty/widgets/navigation/back_app_bar.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);
  static const routeName = '/faq';

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        text: 'FAQ',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Flexible(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderGrey),
                            borderRadius: BorderRadius.circular(8)),
                        child: ExpansionTile(
                          childrenPadding: const EdgeInsets.all(8),
                          title: Text(
                            InitialValues.faq[i]['question']!,
                            style: AppStyles.buttonBlack,
                          ),
                          children: [
                            Text(
                              InitialValues.faq[i]['answer']!,
                              style: AppStyles.body2,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: InitialValues.faq.length)),
            TextButton(
                onPressed: () async => await openPP(),
                child: const Text('Privacy policy', style: AppStyles.button))
          ],
        ),
      ),
    );
  }
}
