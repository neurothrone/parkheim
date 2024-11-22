import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/validators/validators.dart';
import '../../../core/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';

class AuthForm extends StatefulWidget with EmailValidator, PasswordValidator {
  AuthForm({
    super.key,
    required this.onFormSubmitted,
    required this.buttonText,
  });

  final Function(String email, String password) onFormSubmitted;
  final String buttonText;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailNode;
  late final FocusNode _passwordNode;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailNode = FocusNode();
    _passwordNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailNode.dispose();
    _passwordNode.dispose();

    super.dispose();
  }

  void _onFormSubmitted(String email, String password) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onFormSubmitted(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CenteredProgressIndicator();
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(
                  _passwordNode,
                ),
                controller: _emailController,
                validator: widget.validateEmail,
                labelText: "Email",
                focusNode: _emailNode,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                onFieldSubmitted: (_) => _onFormSubmitted(
                  _emailController.text,
                  _passwordController.text,
                ),
                controller: _passwordController,
                validator: widget.validatePassword,
                labelText: "Password",
                obscureText: true,
                focusNode: _passwordNode,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              CustomFilledButton(
                onPressed: () => _onFormSubmitted(
                  _emailController.text,
                  _passwordController.text,
                ),
                text: widget.buttonText,
              ),
            ],
          ),
        );
      },
    );
  }
}
