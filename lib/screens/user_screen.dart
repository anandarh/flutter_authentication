
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/blocs/user/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  JsonEncoder encoder = new JsonEncoder.withIndent("     ");
  AuthenticationBloc authenticationBloc;
  UserBloc userBloc;


  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => userBloc = UserBloc(authBloc: authenticationBloc)..add(LoadUser()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('User Page'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoaded) {
              return Center(
                  child: Text(encoder.convert(state.userData)));
            } else if (state is UserFailure) {
              return Center(
                  child: Text(state.error));
            } else {
             return Center(
               child: SizedBox(
                 child: CircularProgressIndicator(),
                 width: 60,
                 height: 60,
               ),
             );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    userBloc.close();
    super.dispose();
  }
}
