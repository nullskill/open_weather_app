import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_weather_app/src/common/theme/theme.dart';
import 'package:open_weather_app/src/common/widget/action_button.dart';
import 'package:open_weather_app/src/feature/authentication/cubit/login/login_cubit.dart';
import 'package:open_weather_app/src/feature/authentication/data/authentication_repository.dart';
import 'package:open_weather_app/src/feature/authentication/widget/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
      child: Scaffold(
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
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
                            'Вход',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Введите данные для входа',
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
                sliver: SliverToBoxAdapter(
                  child: LoginForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EmailInput(),
        const SizedBox(height: 32),
        _PasswordInput(),
        const SizedBox(height: 48),
        _LoginButton(),
        const SizedBox(height: 18),
        _SignUpButton(),
      ],
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          decoration: const InputDecoration(labelText: 'Email'),
          textInputAction: TextInputAction.next,
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          obscureText: _obscureText,
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
          textInputAction: TextInputAction.done,
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status == LoginStatus.submitting
            ? const CircularProgressIndicator()
            : ActionButton(
                text: 'Войти',
                onPressed: () => context.read<LoginCubit>().logInWithCredentials(),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ActionButton(
      text: 'Зарегистрироваться',
      inverted: true,
      onPressed: () => Navigator.of(context).push<void>(SignUpScreen.route()),
    );
  }
}
