import 'package:flutter/material.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/blocs/login/login_bloc.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:flutter_authentication/utilities/FieldFocusChange.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => _loginBloc = LoginBloc(authRepository: AuthenticationRepository(), authBloc: _authenticationBloc),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {

              if (state is LoginFailure) {
                _onWidgetDidBuild(() {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${state.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              }

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [

                    /// SignIn logo section
                    Container(
                      width: screenSize.width,
                      height: 200.0,
                      margin: EdgeInsets.only(bottom: 50.0, top: 20.0),
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Image.asset('assets/images/login_text_bg.png', width: 250.0,),
                          Positioned(
                              left: 60.0,
                              top: 50.0,
                              child: Text('Sign in', style: TextStyle(fontSize: 38.0, color: Colors.white, fontWeight: FontWeight.bold),))
                        ],
                      ),
                    ),

                    /// Username EditText section
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black54),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.lightBlue[100],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Email cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      onFieldSubmitted: (val) {
                        FieldFocusChange(context, _emailFocus, _passwordFocus);
                      },
                    ),

                    SizedBox(height: 15.0),

                    /// Password EditText section
                    TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      focusNode: _passwordFocus,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black54),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.lightBlue[100],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Password cannot be empty";
                        }else{
                          return null;
                        }
                      },
                      obscureText: true,
                    ),

                    /// Forgot password text section
                    Container(
                      width: screenSize.width,
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Forgot your password?', textAlign: TextAlign.center),
                    ),

                    /// Login Button section
                    GestureDetector(
                      child: Container(
                        width: screenSize.width,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.pink[300],
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: Text('Sign in', style: TextStyle(fontSize: 16.0, color: Colors.white),),
                      ),
                      onTap: _onLoginButtonPressed
                    ),

                    /// Create account text section
                    Container(
                      width: screenSize.width,
                      margin: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text('Don\'t have an account?', textAlign: TextAlign.center),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _onLoginButtonPressed() {
    _loginBloc.add(LoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
