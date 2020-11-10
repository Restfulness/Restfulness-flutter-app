import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';

import '../constants.dart';
import 'blocs/authentication/auth_provider.dart';
import 'blocs/link/links_provider.dart';
import 'screens/decision_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child:CategoriesProvider(
        child: LinksProvider(
          child: MaterialApp(
            title: 'Restfulness',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: primaryColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
                scaffoldBackgroundColor:  Color(0xFFf0f0f0)
            ),
            onGenerateRoute: routes,
          ),
        ) ,
      )
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
