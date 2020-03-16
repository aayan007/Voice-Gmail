import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:love_voice/about/wasim.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MyEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Voice',
      theme: new ThemeData(primarySwatch: Colors.blueGrey),
      home: new SendEmail(),
      routes: <String, WidgetBuilder>{
        "/Aboutpage": (BuildContext context) => MyApp()
      },
    );
  }
}

class SendEmail extends StatefulWidget {
  @override
  _SendEmailState createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _subjectController = TextEditingController();

  TextEditingController _bodyController = TextEditingController();

  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListining = false;

  String resultText = "";

  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
        (bool result) => setState(() => _isAvailable = result));
    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListining = true),
    );
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListining = false),
    );
    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  /*
  // for mail
  */

  _sendEmail() async {
    final String _email = 'mailto:' +
        _emailController.text +
        '?subject=' +
        _subjectController.text +
        '&body=' +
        _bodyController.text;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Helper hand'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: 650,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.deepPurple, Colors.deepPurple.shade200],
                    [Colors.indigo.shade200, Colors.purple.shade200],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    controller: _subjectController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      hintText: 'Subject',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  child: TextField(
                    controller: _bodyController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0))),
                      hintText: 'Message',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                /*
                      //for voice module
                      */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                        child: Icon(Icons.mic),
                        backgroundColor: Colors.pink,
                        onPressed: () {
                          if (_isAvailable && !_isListining)
                            _speechRecognition.listen(locale: "en_US").then(
                                (resultText) =>
                                    _bodyController.text = '$resultText');
                        }),
                  ],
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      _bodyController.text = '$resultText',
                      style: TextStyle(fontSize: 24.0),
                    )),
                /*
                      this is for the mail send button
                      */
                RaisedButton(
                  child: Text('Send Email'),
                  color: Colors.blueGrey,
                  onPressed: _sendEmail,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
