import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> 
with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      );

      animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
      .animate(controller);

      controller.forward();

      controller.addListener(() { 
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 3;
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox( 
                    height: 100,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 46.0,
                    fontWeight: FontWeight.w900,
                  ), 
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('Flash Chat'),
                  ],
                  ),
                  ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent, 
              label: 'Log In', 
              onPress: () {
              Navigator.pushNamed(context, LoginScreen.id);
            },
            ),
            RoundedButton(
              color: Colors.blueAccent, 
              label: 'Register', 
              onPress: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
            ),
          ],
        ),
      ),
    );
  }
}

