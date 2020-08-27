import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:flutter_authentication/screens/home_screen.dart';
import 'package:flutter_authentication/screens/login_screen.dart';
import 'package:flutter_authentication/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition.toString());
  }
}

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc _authenticationBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => _authenticationBloc =
              AuthenticationBloc(authRepository: AuthenticationRepository())
                ..add(AppStarted()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is AuthenticationAuthenticated) {
                return HomeScreen();
              } else if (state is AuthenticationUnauthenticated) {
                return LoginScreen();
              } else if (state is AuthenticationLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SplashScreen();
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
