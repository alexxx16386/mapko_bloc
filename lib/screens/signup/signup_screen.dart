import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/helpers/helpers.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/screens/screens.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import 'cubit/signup_cubit.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) => ErrorDialog(
                  content: state.failure.message, title: '',
                ),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Container(
                              width: 130.0,
                              child: Image.asset('images/logo.png'),
                            ),
                          ),
                          Hero(
                            tag: 'title',
                            child: Text(
                              'Mapko',
                              style: TextStyle(
                                fontSize: 50.0,
                                fontWeight: FontWeight.w900,
                                color: Colors.blueAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        "Регистрация",
                        style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).accentColor),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              children: [
                                _usernameField(context),
                                _emailField(context),
                                SizedBox(
                                  height: 8.0,
                                ),
                                _passwordField(context),
                                _password2Field(state, context),
                                SizedBox(
                                  height: 24.0,
                                ),
                                ElevatedButton(
                                  onPressed: () => _submitForm(context,
                                      state.status == SignupStatus.submitting),
                                  child: Text('Зарегистрироваться'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  TextFormField _passwordField(BuildContext context) {
    return TextFormField(
      onChanged: (value) => context.read<SignupCubit>().passwordChanged(value),
      validator: (String? value) => Validators().passwordValidator(value),
      obscureText: _isHidden ? true : false,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Пароль',
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  TextFormField _emailField(BuildContext context) {
    return TextFormField(
      onChanged: (value) => context.read<SignupCubit>().emailChanged(value),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) => Validators().emailValidator(value),
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        labelText: 'Email',
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  TextFormField _password2Field(SignupState state, BuildContext context) {
    return TextFormField(
      validator: (String? value1) => Validators().password2Validator(
        value1,
        state.password,
      ),
      obscureText: _isHidden ? true : false,
      decoration: InputDecoration(
        icon: Icon(Icons.lock),
        labelText: 'Повторите пароль',
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  TextFormField _usernameField(BuildContext context) {
    return TextFormField(
      onChanged: (value) => context.read<SignupCubit>().usernameChanged(value),
      validator: (String? value) => Validators().usernameValidator(value),
      decoration: InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Имя пользователя',
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
      Navigator.of(context).pushNamedAndRemoveUntil(
        NavScreen.routeName,
        (route) => false,
      );
    }
  }
}
