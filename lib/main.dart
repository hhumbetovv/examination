import 'package:examination/cubits/index_cubit.dart';
import 'package:examination/cubits/theme_mode_cubit.dart';
import 'package:examination/pages/login/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'firebase_options.dart';
import 'model/subject.dart';
import 'pages/select_view.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Examination());
}

class Examination extends StatelessWidget {
  const Examination({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SubjectModel> subjects = SubjectModel.subjects;
    final AppTheme appTheme = AppTheme();

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
                builder: (context, child) {
                  return ResponsiveBreakpoints.builder(child: child!, breakpoints: [
                    const Breakpoint(start: 0, end: 450, name: MOBILE),
                    const Breakpoint(start: 451, end: 800, name: TABLET),
                    const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  ]);
                },
                theme: appTheme.light(AppColors.colors[index]),
                darkTheme: appTheme.dark(AppColors.colors[index]),
                themeMode: mode ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: subjects.isNotEmpty ? SelectView(subjects: subjects) : const LoginView(),
              );
            },
          );
        },
      ),
    );
  }
}
