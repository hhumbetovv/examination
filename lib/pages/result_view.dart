import 'package:examination/global/index_cubit.dart';
import 'package:examination/global/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

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
  String floatingActionButtonLabel = 'Expand all';

  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(widget.controller.incorrects.length, (index) => false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onFloatingActionButtonPressed() {
    if (_isOpen.any((element) => element == false)) {
      _isOpen = _isOpen.map((e) => true).toList();
      floatingActionButtonLabel = 'Compress all';
    } else {
      _isOpen = _isOpen.map((e) => false).toList();
      floatingActionButtonLabel = 'Expand all';
    }
    setState(() {});
  }

  //? Change Theme Button
  GestureDetector get changeThemeButton {
    return GestureDetector(
      onLongPress: () {
        context.read<ThemeModeCubit>().changeMode();
      },
      child: IconButton(
        onPressed: () {
          context.read<IndexCubit>().changeIndex();
        },
        icon: const Icon(
          Icons.color_lens_outlined,
        ),
      ),
    );
  }

  Text get timer {
    return Text(
      widget.controller.getDuration,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  //! Result Chart
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

  List<Expanded> get questions {
    return widget.controller.incorrects.asMap().entries.map((object) {
      return Expanded(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _isOpen[object.key] = !_isOpen[object.key];
                  if (_isOpen.any((element) => element == false)) {
                    floatingActionButtonLabel = 'Expand all';
                  } else {
                    floatingActionButtonLabel = 'Compress all';
                  }
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isOpen[object.key]
                  ? Column(
                      children: object.value.answers.map((answer) {
                        return AnswerButton(
                          currentAnswer: answer,
                          isLearning: true,
                        );
                      }).toList(),
                    )
                  : const SizedBox(width: double.infinity, height: 10),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [changeThemeButton],
      ),
      floatingActionButton: _isOpen.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: onFloatingActionButtonPressed,
              label: Text(floatingActionButtonLabel),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: widget.controller.getIncorrects == 0
            ? Column(
                children: [
                  timer,
                  Expanded(child: chart(isCenter: true)),
                ],
              )
            : ResponsiveBreakpoints.of(context).isDesktop
                ? Column(
                    children: [
                      timer,
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: chart(),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: questions,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      timer,
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: chart(),
                      ),
                      ...questions,
                    ],
                  ),
      ),
    );
  }
}
