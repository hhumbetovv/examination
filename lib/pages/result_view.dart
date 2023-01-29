import 'package:examination/components/answer_button.dart';
import 'package:examination/constants.dart';
import 'package:examination/model/result_controller.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

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
        centerText: '${widget.controller.getResult}%',
        baseChartColor: Constants.primaryColor,
        colorList: const [Colors.green, Colors.red, Constants.accentColor],
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
        chartLegendSpacing: 40,
        chartType: isCenter ? ChartType.disc : ChartType.ring,
        chartValuesOptions: ChartValuesOptions(
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
      appBar: AppBar(
        title: const Text(
          'Result',
          style: TextStyle(
            fontSize: Constants.fontSizeSmall,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
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
                        const Divider(
                          color: Constants.accentColor,
                          thickness: 1,
                        ),
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
