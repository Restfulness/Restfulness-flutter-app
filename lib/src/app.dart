import 'package:flutter/material.dart';

import 'blocs/authentication/auth_provider.dart';
import 'screens/decision_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: MaterialApp(
        title: 'Restfulness',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
        builder: (context) {
          return DecisionScreen();
        },
      );
    } else if (settings.name == "/register") {
      return MaterialPageRoute(builder: (context) {
        return RegisterScreen();
      });
    } else if (settings.name == "/login") {
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    }
  }
}
