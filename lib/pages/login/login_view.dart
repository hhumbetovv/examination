import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../cubits/index_cubit.dart';
import '../../cubits/theme_mode_cubit.dart';
import '../../widgets/bordered_container.dart';
import '../../widgets/text_input.dart';
import 'login_modal.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends LoginModal {
  //! Whatsapp Message Button
  IconButton get waMessageButton {
    return IconButton(
      onPressed: () async {
        await WhatsappShare.share(
          text: 'Oh? Hi there',
          phone: '994773081398',
        );
      },
      icon: const Icon(Icons.question_answer_outlined),
    );
  }

  //! Change Theme Button
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        actions: [
          changeThemeButton,
          waMessageButton,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: BorderedContainer(
            constraints: const BoxConstraints(maxWidth: 768),
            child: Wrap(
              runSpacing: 10,
              children: [
                TextInput(
                  label: 'e-mail',
                  controller: emailController,
                ),
                TextInput(
                  label: 'password',
                  controller: passwordController,
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : onLogInPressed,
                  child: isLoading ? const CircularProgressIndicator() : const Text('Log in'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
