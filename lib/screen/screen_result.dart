import 'package:flutter/material.dart';
import 'package:quiz_client_flutter/model/model.quiz.dart';
import 'package:quiz_client_flutter/screen/screen_home.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({Key? key, required this.answer, required this.quizs})
      : super(key: key);
  List<int> answer;
  List<Quiz> quizs;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    int score = 0;
    for (int i = 0; i < quizs.length; i++) {
      if (quizs[i].answer == answer[i]) {
        score += 1;
      }
    }

    return WillPopScope(
      // disable to use back button
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('My Quiz App'),
            backgroundColor: Colors.lightBlue,
            leading: Container(),
          ),
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.lightBlue),
                color: Colors.lightBlue,
              ),
              width: width * 0.85,
              height: height * 0.5,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: width * 0.048,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.lightBlue),
                      color: Colors.white,
                    ),
                    width: width * 0.73,
                    height: height * 0.25,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              0, width * 0.04, 0, width * 0.02),
                          child: Text(
                            '수고하셨습니다.',
                            style: TextStyle(
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '당신의 점수는',
                          style: TextStyle(
                            fontSize: width * 0.048,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          score.toString() + '/' + quizs.length.toString(),
                          style: TextStyle(
                            fontSize: width * 0.21,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width * 0.002),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: width * 0.048,
                    ),
                    child: ButtonTheme(
                      minWidth: width * 0.73,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }));
                        },
                        child: const Text('홈으로 돌아가기'),
                        color: Colors.white,
                        textColor: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
