import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';
import 'package:open_weather_app/src/common/widget/action_button.dart';
import 'package:open_weather_app/src/feature/authentication/cubit/signup/signup_cubit.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
      child: Scaffold(
        body: BlocListener<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state.status == SignUpStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == SignUpStatus.error) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(82),
                  child: SizedBox(
                    height: 82,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Регистрация',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Введите данные для регистрации',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: kSecondaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                sliver: SliverToBoxAdapter(child: SignUpForm()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EmailInput(),
        const SizedBox(height: 8),
        _PasswordInput(),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: _SignUpButton(),
        ),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          decoration: const InputDecoration(labelText: 'Email'),
          textInputAction: TextInputAction.next,
          onChanged: (email) {
            context.read<SignUpCubit>().emailChanged(email);
          },
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Пароль',
            suffixIcon: IconButton(
              icon: SvgPicture.asset(
                _obscureText ? 'assets/images/visibility.svg' : 'assets/images/visibility_off.svg',
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
              splashRadius: 20,
            ),
          ),
          obscureText: _obscureText,
          textInputAction: TextInputAction.done,
          onChanged: (password) {
            context.read<SignUpCubit>().passwordChanged(password);
          },
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == SignUpStatus.submitting
            ? const CircularProgressIndicator()
            : ActionButton(
                text: 'Зарегистрироваться',
                onPressed: () => context.read<SignUpCubit>().signUpFormSubmitted(),
              );
      },
    );
  }
}
