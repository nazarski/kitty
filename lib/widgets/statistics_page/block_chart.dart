import 'package:flutter/material.dart';
import 'package:kitty/models/statistics_element_model/statistics_element.dart';
import 'package:kitty/utils/helper.dart';

class BlockChart extends StatefulWidget {
  const BlockChart({Key? key, required this.stats}) : super(key: key);
  final List<StatisticsElement> stats;

  @override
  State<BlockChart> createState() => _BlockChartState();
}

class _BlockChartState extends State<BlockChart> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: List.generate(widget.stats.length, (index) {
            return Flexible(
              flex: (widget.stats[index].monthShare).round(),
              child: AnimatedContainer(
                curve: Curves.easeIn,
                color: fromHex(widget.stats[index].icon.color),
                duration: const Duration(milliseconds: 500),
              ),
            );
          }),
        ),
      ),
    );
  }
}
