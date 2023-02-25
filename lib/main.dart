import 'package:examination/global/index_cubit.dart';
import 'package:examination/global/theme_mode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'model/subjects.dart';
import 'pages/select_view.dart';
import 'utils/theme.dart';

void main() {
  runApp(const Examination());
}

class Examination extends StatelessWidget {
  const Examination({
    Key? key,
  }) : super(key: key);

  Future<void> clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = Subject.subjects;
    final AppTheme appTheme = AppTheme();
    clearCache();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IndexCubit()),
        BlocProvider(create: (context) => ThemeModeCubit()),
      ],
      child: BlocBuilder<IndexCubit, int>(
        builder: (context, index) {
          return BlocBuilder<ThemeModeCubit, bool>(
            builder: (context, mode) {
              context.read<ThemeModeCubit>().getMode();
              context.read<IndexCubit>().getIndex();
              return MaterialApp(
                title: 'Examination',
                theme: appTheme.light(AppColors.colors[index]),
                darkTheme: appTheme.dark(AppColors.colors[index]),
                themeMode: mode ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: SelectView(subjects: subjects),
              );
            },
          );
        },
      ),
    );
  }
}
