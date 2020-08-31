import 'dart:convert';

import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_authentication/repositories/authentication_repository.dart';
import 'package:flutter_authentication/screens/user_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rect_getter/rect_getter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  JsonEncoder encoder = new JsonEncoder.withIndent("     ");
  AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('Authentication'),
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    authenticationBloc.add(LoggedOut());
                  })
            ],
          ),
          body: FutureBuilder(
              future: AuthenticationRepository.decodeToken(TokenType.ACCESS_TOKEN),
              builder: (context, snapshot) {
                Widget child;
                if (snapshot.hasData) {
                  Duration duration = DateTime.fromMillisecondsSinceEpoch(
                          snapshot.data['exp'] * 1000)
                      .difference(DateTime.now());

                  child = Stack(
                    children: [
                      SingleChildScrollView(
                        child: _buildContent(
                            icon: Icons.check_circle_outline,
                            iconColor: Colors.green,
                            data: 'Result: ${encoder.convert(snapshot.data)}'),
                      ),
                      Positioned(
                        top: 5.0,
                        right: 5.0,
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5.0,
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.white,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Countdown(
                                  duration: duration.isNegative
                                      ? Duration(seconds: 0)
                                      : duration,
                                  onFinish: () {
                                    print(duration);
                                  },
                                  builder:
                                      (BuildContext ctx, Duration remaining) {
                                    String inMinutes = remaining.inMinutes
                                        .remainder(60)
                                        .toString()
                                        .padLeft(2, '0');
                                    String inSeconds =
                                        (remaining.inSeconds.remainder(60) % 60)
                                            .toString()
                                            .padLeft(2, '0');
                                    return Text(
                                      remaining.inSeconds != 0
                                          ? '$inMinutes:$inSeconds'
                                          : 'Token Expired',
                                      style: TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  child = _buildContent(
                      icon: Icons.error_outline,
                      iconColor: Colors.red,
                      data: 'Error: ${snapshot.error}');
                } else {
                  child = Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Decoding token...'),
                        )
                      ]);
                }
                return Center(
                  child: child,
                );
              }),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.downToUp, child: UserScreen()));
            },
            child: Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  Widget _buildContent({IconData icon, Color iconColor, String data}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: iconColor,
          size: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(data),
        )
      ],
    );
  }
}
