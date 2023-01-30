import 'package:easy_localization/easy_localization.dart';
import 'package:kitty/generated/locale_keys.g.dart';
import 'package:kitty/resources/app_icons.dart';

class InitialValues {
  static const List<String> incomeCategories = [
    'Salary',
    'Gifts',
    'Wages',
    'Interest',
    'Savings',
    'Allowance',
  ];

  static const List<String> expenseCategories = [
    'Groceries',
    'Cafe',
    'Electronics'
  ];

  static const List<Map<String, String>> allIcons = [
    {'color': 'C8E6C9', 'icon': AppIcons.groceries},
    {'color': 'FFECB3', 'icon': AppIcons.cafe},
    {'color': 'FFCDD2', 'icon': AppIcons.electronics},
    {'color': 'B3E5FC', 'icon': AppIcons.laundry},
    {'color': 'BBDEFB', 'icon': AppIcons.party},
    {'color': 'FFECB3', 'icon': AppIcons.savings},
    {'color': 'DCEDC8', 'icon': AppIcons.liquor},
    {'color': 'D7CCC8', 'icon': AppIcons.fuel},
    {'color': 'B39DDB', 'icon': AppIcons.maintenance},
    {'color': 'C8E6C9', 'icon': AppIcons.education},
    {'color': 'CFD8DC', 'icon': AppIcons.selfDevelopment},
    {'color': 'F8BBD0', 'icon': AppIcons.health},
    {'color': 'B2EBF2', 'icon': AppIcons.transportation},
    {'color': 'C5CAE9', 'icon': AppIcons.restaurant},
    {'color': 'E6EE9C', 'icon': AppIcons.sport},
    {'color': 'FFCCBC', 'icon': AppIcons.money},
    {'color': 'E1BEE7', 'icon': AppIcons.giftCard},
    {'color': 'FFF9C4', 'icon': AppIcons.donate},
    {'color': 'FFE0B2', 'icon': AppIcons.institute},
    {'color': 'C5CAE9', 'icon': AppIcons.savings},
    {'color': 'C8E6C9', 'icon': AppIcons.money},
  ];

  static final List<Map<String, String>> faq = [
    {
      'question': LocaleKeys.faq_data_questions_how_add_trans.tr(),
      'answer': LocaleKeys.faq_data_answers_how_add_trans.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_add_cat.tr(),
      'answer': LocaleKeys.faq_data_answers_how_add_cat.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_edit_trans.tr(),
      'answer': LocaleKeys.faq_data_answers_how_edit_trans.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_del_trans.tr(),
      'answer': LocaleKeys.faq_data_answers_how_del_trans.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_stats_work.tr(),
      'answer': LocaleKeys.faq_data_answers_how_stats_work.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_balance_work.tr(),
      'answer': LocaleKeys.faq_data_answers_how_balance_work.tr()
    },
    {
      'question': LocaleKeys.faq_data_questions_how_change_date.tr(),
      'answer': LocaleKeys.faq_data_answers_how_change_date.tr()
    },
  ];
}
