import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../constants.dart';
import '../model/result_controller.dart';
import '../widgets/answer_button.dart';

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
                  ...widget.controller.incorrects.map((object) {
                    return Column(
                      children: [
                        const Divider(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            object.question,
                            style: const TextStyle(
                              fontSize: Constants.fontSizeLarge,
                            ),
                          ),
                        ),
                        ...object.answers.map((answer) {
                          return AnswerButton(
                            currentAnswer: answer,
                            controller: null,
                            isLearning: true,
                            updateQuestion: (value) {},
                          );
                        }).toList(),
                      ],
                    );
                  }).toList()
                ],
              ),
      ),
    );
  }
}
