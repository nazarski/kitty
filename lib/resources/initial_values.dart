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
    'Electronics',
  ];
  static const Map<String, Map<String, String>> incomeIcons = {
    'money': {'color': 'FFCCBC', 'icon': AppIcons.money},
    'giftcard': {'color': 'E1BEE7', 'icon': AppIcons.giftCard},
    'donation': {'color': 'FFF9C4', 'icon': AppIcons.donate},
    'institute': {'color': 'FFE0B2', 'icon': AppIcons.institute},
    'savings': {'color': 'C5CAE9', 'icon': AppIcons.savings},
    'allowance': {'color': 'C8E6C9', 'icon': AppIcons.money},
  };
  static const Map<String, Map<String, String>> expenseIcons = {
    'groceries': {'color': 'C8E6C9', 'icon': AppIcons.groceries},
    'cafe': {'color': 'FFECB3', 'icon': AppIcons.cafe},
    'electronics': {'color': 'FFCDD2', 'icon': AppIcons.electronics},
    'laundry': {'color': 'B3E5FC', 'icon': AppIcons.laundry},
    'party': {'color': 'BBDEFB', 'icon': AppIcons.party},
    'liquor': {'color': 'DCEDC8', 'icon': AppIcons.liquor},
    'fuel': {'color': 'D7CCC8', 'icon': AppIcons.fuel},
    'maintenance': {'color': 'B39DDB', 'icon': AppIcons.maintenance},
    'education': {'color': 'C8E6C9', 'icon': AppIcons.education},
    'transportation': {'color': 'B2EBF2', 'icon': AppIcons.transportation},
    'sport': {'color': 'E6EE9C', 'icon': AppIcons.sport},
    'self_development': {'color': 'CFD8DC', 'icon': AppIcons.selfDevelopment},
    'savings': {'color': 'FFECB3', 'icon': AppIcons.savings},
    'restaurant': {'color': 'C5CAE9', 'icon': AppIcons.restaurant},
  };
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
