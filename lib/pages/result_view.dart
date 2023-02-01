import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/result_controller.dart';
import '../utils/constants.dart';
import '../widgets/answer_button.dart';
import '../widgets/bordered_container.dart';

class ResultView extends StatefulWidget {
  const ResultView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ResultController controller;

  @override
  State<ResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  late List<bool> _isOpen;

  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(widget.controller.incorrects.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Center chart({bool isCenter = false}) {
    return Center(
      child: PieChart(
        centerText: isCenter ? null : '${widget.controller.getResult}%',
        baseChartColor: Theme.of(context).colorScheme.secondary,
        colorList: [Colors.green, Colors.red, Theme.of(context).colorScheme.primary],
        dataMap: {
          "Corrects - ${widget.controller.getCorrects}": widget.controller.getCorrects.toDouble(),
          "Incorrects - ${widget.controller.getIncorrects}": widget.controller.getIncorrects.toDouble(),
          "Blanks - ${widget.controller.blanks}": widget.controller.blanks.toDouble(),
        },
        legendOptions: LegendOptions(
          showLegends: true,
          legendPosition: isCenter ? LegendPosition.bottom : LegendPosition.right,
          legendTextStyle: TextStyle(
            fontSize: isCenter ? Constants.fontSizeLarge : Constants.fontSizeSmall,
          ),
        ),
        chartLegendSpacing: 30,
        chartValuesOptions: ChartValuesOptions(
          showChartValues: isCenter,
          showChartValuesOutside: isCenter,
          decimalPlaces: 0,
          showChartValuesInPercentage: true,
          chartValueStyle: TextStyle(
            fontSize: isCenter ? Constants.fontSizeSmall : null,
            color: Colors.black,
          ),
        ),
        chartRadius: MediaQuery.of(context).size.width / 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: widget.controller.getIncorrects == 0
            ? chart(isCenter: true)
            : ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: chart(),
                  ),
                  ...widget.controller.incorrects.asMap().entries.map((object) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isOpen[object.key] = !_isOpen[object.key];
                            });
                          },
                          borderRadius: Constants.radiusMedium,
                          child: BorderedContainer(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                object.value.question,
                                style: const TextStyle(
                                  fontSize: Constants.fontSizeLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          secondChild: const SizedBox(width: double.infinity, height: 10),
                          crossFadeState: _isOpen[object.key] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                          firstChild: Column(
                            children: object.value.answers.map((answer) {
                              return AnswerButton(
                                currentAnswer: answer,
                                isLearning: true,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
      ),
    );
  }
}
