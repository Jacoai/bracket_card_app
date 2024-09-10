import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/components/error_messager/error_messager.dart';
import 'package:bracket_card_app/navigation/route.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

import '../../modal_windows/show_animated_dialog.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthorizationPage extends StatelessWidget {
  const AuthorizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        Expanded(
          flex: 1,
          child: ClipPath(
            clipper: LeftSideClipper(),
            child: Container(color: Theme.of(context).primaryColorLight),
          ),
        ),
        Expanded(
          flex: 3,
          child: BlocProvider(
            create: (context) => AuthPageBloc()..add(AuthPageOpened()),
            child: const AuthForm(),
          ),
        ),
      ]),
    );
  }
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        context.read<AuthPageBloc>().add(UsernameUnfocused());
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<AuthPageBloc>().add(PasswordUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthPageBloc, AuthPageState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          context.go(AppRoute.home.path);
        } else if (state.status.isFailure) {
          showAnimatedDialog(
            context,
            ErrorMesseger(
              errorName: SLocale.of(context).failedAuthorizationAttempt,
              errorDescribe: state.errorMessage ?? '',
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Align(
            alignment: const Alignment(0, -3 / 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                UserNameInput(
                  focusNode: _usernameFocusNode,
                ),
                PasswordInput(
                  focusNode: _passwordFocusNode,
                ),
                const AuthButton(),
                InkWell(
                  child: BlocBuilder<AuthPageBloc, AuthPageState>(
                    builder: (context, state) => Text(
                      state.view == AuthView.logIn
                          ? SLocale.of(context).noAccountSignUp
                          : SLocale.of(context).haveAccountSignIn,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    formKey.currentState?.reset();
                    context.read<AuthPageBloc>().add(ChangePageView());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    required this.focusNode,
  });
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 120,
      child: BlocBuilder<AuthPageBloc, AuthPageState>(
        builder: (context, state) {
          return TextFormField(
            initialValue: '',
            focusNode: focusNode,
            obscureText: !(state.isPasswordVisible),
            decoration: InputDecoration(
              icon: const Icon(Icons.security),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<AuthPageBloc>().add(ChangePasswordVisibility());
                },
                icon: const Icon(
                  Icons.remove_red_eye,
                ),
                tooltip: state.isPasswordVisible
                    ? SLocale.of(context).hidePassword
                    : SLocale.of(context).showPassword,
              ),
              helperText: SLocale.of(context).password8char,
              errorText: state.password.displayError,
              errorMaxLines: 4,
              helperMaxLines: 3,
              labelText: SLocale.of(context).password,
            ),
            onChanged: (value) {
              context
                  .read<AuthPageBloc>()
                  .add(PasswordChanged(password: value));
            },
            textInputAction: TextInputAction.done,
          );
        },
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((AuthPageBloc bloc) => bloc.state.isValid);
    return Column(
      children: [
        TextButton(
          style: baseButtonStyle.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Theme.of(context).primaryColor.withOpacity(0.5);
                } else if (states.contains(MaterialState.disabled)) {
                  return Theme.of(context)
                      .extension<ThemeColors>()!
                      .componentDisabledColor;
                } else if (states.contains(MaterialState.hovered)) {
                  return Theme.of(context).primaryColor.withOpacity(0.5);
                } else {
                  return Theme.of(context).primaryColor;
                }
              },
            ),
          ),
          onPressed: isValid
              ? () => context.read<AuthPageBloc>().add(TryAuthorization())
              : null,
          child: BlocBuilder<AuthPageBloc, AuthPageState>(
            builder: (context, state) => Text(
              state.view == AuthView.logIn
                  ? SLocale.of(context).signIn
                  : SLocale.of(context).signUp,
            ),
          ),
        ),
      ],
    );
  }
}

class UserNameInput extends StatelessWidget {
  const UserNameInput({
    super.key,
    required this.focusNode,
  });
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 120,
      child: BlocBuilder<AuthPageBloc, AuthPageState>(
        builder: (context, state) {
          return TextFormField(
            initialValue: '',
            focusNode: focusNode,
            autofocus: true,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
              labelText: SLocale.of(context).userName,
              helperText: state.username.value.isEmpty
                  ? SLocale.of(context).enterUniqueNickname
                  : null,
              errorText: state.username.displayError,
              errorMaxLines: 3,
            ),
            keyboardType: TextInputType.name,
            onChanged: (value) {
              context
                  .read<AuthPageBloc>()
                  .add(UsernameChanged(username: value));
            },
            textInputAction: TextInputAction.next,
          );
        },
      ),
    );
  }
}

class LeftSideClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0.0, size.height)
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..cubicTo(size.width / 4, size.height * 2 / 3, size.width,
          size.height / 2, size.width / 2, size.height / 2)
      ..quadraticBezierTo(size.width, size.height * 1 / 3, size.width, 0)
      ..lineTo(0, 0.0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
