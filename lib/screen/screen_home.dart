import 'package:flutter/material.dart';
import 'package:quiz_client_flutter/model/api_adapter.dart';
import 'package:quiz_client_flutter/model/model.quiz.dart';
import 'package:quiz_client_flutter/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizs = [];
  bool isLoading = false;

  _fetchQuizs() async {
    setState(() {
      isLoading = true;
    });
    final response = await http
        .get(Uri.parse('https://quiz-server-django.herokuapp.com/quiz/3/'));
    if (response.statusCode == 200) {
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('fail to load data');
    }
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          width * 0.048, width * 0.024, width * 0.048, width * 0.024),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      // disable to use back button
      onWillPop: () async => false,
      child: SafeArea(
        // return Safe app area
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'My Quiz App',
            ),
            backgroundColor: Colors.lightBlue,
            leading: Container(), // Remove useless Appbar buttons
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'images/quiz.jpeg',
                  width: width * 0.8,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.024),
              ),
              Text(
                'Flutter Quiz App',
                style: TextStyle(fontSize: width * 0.065),
                textAlign: TextAlign.center,
              ),
              const Text(
                '퀴즈를 풀기 전 안내사항 입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              _buildStep(
                width,
                '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.',
              ),
              _buildStep(
                width,
                '2. 문제를 잘 읽고 정답을 고른 뒤\n다음 문제 버튼을 눌러주세요.',
              ),
              _buildStep(
                width,
                '3. 만점을 향해 도전하세요!',
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.048),
              ),
              Container(
                padding: EdgeInsets.only(bottom: width * 0.036),
                child: Center(
                  child: ButtonTheme(
                    minWidth: width * 0.8,
                    height: height * 0.05,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RaisedButton(
                      child: const Text(
                        '지금 퀴즈 풀기',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                      onPressed: () {
                        _scaffoldKey.currentState?.showSnackBar(
                          SnackBar(
                            content: Row(
                              children: <Widget>[
                                const CircularProgressIndicator(),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.036),
                                ),
                                const Text('로딩 중 ....')
                              ],
                            ),
                          ),
                        );
                        _fetchQuizs().whenComplete(() {
                          return Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                quizs: quizs,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
