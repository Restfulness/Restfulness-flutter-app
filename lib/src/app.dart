import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/reset_password/reset_password_provider.dart';
import 'package:restfulness/src/blocs/social/social_provider.dart';
import 'package:restfulness/src/screens/reset_password/forgot_password_screen.dart';

import '../constants.dart';
import 'blocs/authentication/auth_provider.dart';
import 'blocs/link/links_provider.dart';
import 'screens/decision_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
        child: ResetPasswordProvider(
      child: LinksProvider(
        child: SocialProvider(
          child: CategoriesProvider(
            child: MaterialApp(
              builder: (context, widget) => ResponsiveWrapper.builder(
                  BouncingScrollWrapper.builder(context, widget),
                  maxWidth: 1200,
                  minWidth: 400,
                  defaultScale: true,
                  breakpoints: [
                    ResponsiveBreakpoint.resize(400, name: MOBILE),
                    ResponsiveBreakpoint.autoScale(800, name: TABLET),
                    ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                    ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                  ],
                  background: Container(color: Color(0xFFF5F5F5))),
              title: 'Restfulness',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: primaryColor,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  scaffoldBackgroundColor: scaffoldBackgroundColor,
                  primaryTextTheme: TextTheme(
                    headline6: TextStyle(color: Colors.white),
                  )),
              onGenerateRoute: routes,
            ),
          ),
        ),
      ),
    ));
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
    } else if (settings.name == "/forgot_password") {
      return MaterialPageRoute(builder: (context) {
        return ForgotPasswordScreen();
      });
    }
  }
}
