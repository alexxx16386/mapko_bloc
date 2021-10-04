import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapko_bloc/helpers/helpers.dart';
import 'package:mapko_bloc/repositories/repositories.dart';
import 'package:mapko_bloc/widgets/widgets.dart';

import '../screens.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
      ),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        child: BlocConsumer<LoginCubit, LoginState>(listener: (context, state) {
          if (state.status == LoginStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(
                content: state.failure.message,
                title: '',
              ),
            );
          }
        }, builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Hero(
                          tag: 'logo',
                          child: Container(
                            width: 300.0,
                            child: Image.asset('images/logo.png'),
                          ),
                        ),
                        Text(
                          'Mapko',
                          style: TextStyle(
                            fontSize: 60.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.blueAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 48.0,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Column(
                                children: [
                                  TextFormField(
                                    onChanged: (value) => context
                                        .read<LoginCubit>()
                                        .emailChanged(value),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (String? value) =>
                                        Validators().emailValidator(value),
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.email),
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormField(
                                    onChanged: (value) => context
                                        .read<LoginCubit>()
                                        .passwordChanged(value),
                                    validator: (String? value) =>
                                        Validators().passwordValidator(value),
                                    obscureText: _isHidden ? true : false,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.lock),
                                      labelText: 'Пароль',
                                      labelStyle: TextStyle(
                                        color: Theme.of(context).accentColor,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: _toggleVisibility,
                                        icon: _isHidden
                                            ? Icon(Icons.visibility)
                                            : Icon(Icons.visibility_off),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _submitForm(
                                      context,
                                      state.status == LoginStatus.submitting,
                                    ),
                                    child: Text('Войти'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ещё нет аккаунта?",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              "Создать",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignupScreen.routeName),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().logInWithCredentials();
      Navigator.of(context).pushNamedAndRemoveUntil(
        NavScreen.routeName,
        (route) => false,
      );
    }
  }
}
