import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:restfulness/src/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppIntroScreen extends StatefulWidget {
  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {

    _saveIntro().then((value){
      if(value){
        _redirectToPage(context, LoginScreen());
      }
    });
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/intro/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Make it visible",
          body:
              "Manage your team's valuable links by centralizing them in a dedicated place, categorize them, and search through them easily.",
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Make it trackable",
          body:
              "Follow exciting links that each team's members are finding and make these activities bold and smooth.",
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Add your server",
          body:
              "On the login page by tapping on the gear icon you can configure your server address and by going to settings you can change it, or you can use the demo server.",
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Swipe to the right",
          body: "Here you have three options including deleting, sharing, or opening the desired link",
          image: Align(
            child: Column(
              children: [
                SizedBox(height:200,),
                Image.asset('assets/intro/animation1.gif', width: 250.0),
              ],
            ),
            alignment: Alignment.center,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Control your links view mode",
          body: "By going to the settings you can turn on or off the preview mode",
          image: Align(
            child: Column(
              children: [
                SizedBox(height: 150,),
                Image.asset('assets/intro/img4.png', width: 250.0),
                SizedBox(height: 25,),
                Image.asset('assets/intro/img5.png', width: 250.0)
              ],
            ),
            alignment: Alignment.center,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }


  Future<void> _redirectToPage(BuildContext context, Widget page) async {
    final MaterialPageRoute<bool> newRoute =
    MaterialPageRoute<bool>(builder: (BuildContext context) => page);

    final bool nav = await Navigator.of(context)
        .pushAndRemoveUntil<bool>(newRoute, ModalRoute.withName('/'));
    if (nav == true) {
      //TODO: init
    }
  }

  Future<bool> _saveIntro() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'intro';
    final isSaved = prefs.setBool(key, true);
    return isSaved;
  }

}
