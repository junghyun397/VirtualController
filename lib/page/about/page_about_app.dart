import 'package:VirtualFlightThrottle/generated/l10n.dart';
import 'package:VirtualFlightThrottle/page/direction_state.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAboutApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _PageAboutAppState();

}

class _PageAboutAppState extends DynamicDirectionState<PageAboutApp> {

  TextSpan _buildDotTextSpan() => const TextSpan(text: " • ");

  Padding _buildPadding(double paddingSize) => const Padding(padding: EdgeInsets.all(5));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(S.of(context).pageAboutApp_title),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Image(
                width: 150,
                height: 150,
                image: AssetImage("assets/images/app_logo.png"),
              ),
              this._buildPadding(10),
              Text(
                "VFCS Flight Control System",
                style: TextStyle(fontSize: 30),
              ),
              this._buildPadding(4),
              Text.rich(
                TextSpan(
                  children: [
                    _LinkTextSpan(
                      text: "Github Repository",
                      url: "https://github.com/junghyun397/VirtualThrottle",
                    ),
                    this._buildDotTextSpan(),
                    _LinkTextSpan(
                      text: "Project Wiki",
                      url: "https://github.com/junghyun397/VirtualThrottle/wiki",
                    ),
                  ],
                )
              ),
              this._buildPadding(40),
              Text(
                S.of(context).pageAboutApp_developerInfo,
                style: TextStyle(fontSize: 17),
              ),
              this._buildPadding(10),
              Text.rich(
                TextSpan(
                  children: [
                    _LinkTextSpan(
                      text: "Github Profile",
                      url: "https://github.com/junghyun397",
                    ),
                    this._buildDotTextSpan(),
                    _LinkTextSpan(
                      text: "LinkedIn",
                      url: "https://www.linkedin.com/in/choi-jeonghyeon-207272177/",
                    ),
                    this._buildDotTextSpan(),
                    _LinkTextSpan(
                      text: "Discord",
                      url: "https://discordapp.com/users/365253864649392128",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _LinkTextSpan extends TextSpan {

  _LinkTextSpan({@required String text, @required String url}) : super(
    style: TextStyle(color: Colors.blueAccent),
    text: text,
    recognizer: TapGestureRecognizer()..onTap = () => launch(url, forceSafariVC: false),
  );

}