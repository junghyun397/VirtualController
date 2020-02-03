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
              Padding(padding: EdgeInsets.all(5)),
              Text(
                "VFT Flight Throttle",
                style: TextStyle(fontSize: 30),
              ),
              Padding(padding: EdgeInsets.all(2)),
              Text.rich(
                TextSpan(
                  children: [
                    _LinkTextSpan(
                      text: "Github Repository",
                      url: "https://github.com/junghyun397/VirtualThrottle",
                    ),
                    TextSpan(text: " • "),
                    _LinkTextSpan(
                      text: "Project Wiki",
                      url: "https://github.com/junghyun397/VirtualThrottle/wiki",
                    ),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.all(20)),
              Text(
                S.of(context).pageAboutApp_developerInfo,
                style: TextStyle(fontSize: 17),
              ),
              Padding(padding: EdgeInsets.all(5)),
              Text.rich(
                TextSpan(
                  children: [
                    _LinkTextSpan(
                      text: "Github Profile",
                      url: "https://github.com/junghyun397",
                    ),
                    TextSpan(text: " • "),
                    _LinkTextSpan(
                      text: "LinkedIn",
                      url: "https://www.linkedin.com/in/choi-jeonghyeon-207272177/",
                    ),
                    TextSpan(text: " • "),
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
    text: text ?? url,
    recognizer: TapGestureRecognizer()..onTap = () {
      launch(url, forceSafariVC: false);
    }
  );

}