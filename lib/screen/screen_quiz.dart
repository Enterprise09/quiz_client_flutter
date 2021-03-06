import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:quiz_client_flutter/model/model.quiz.dart';
import 'package:quiz_client_flutter/screen/screen_result.dart';
import 'package:quiz_client_flutter/widget/widget_candidate.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({Key? key, required this.quizs}) : super(key: key);
  List<Quiz> quizs;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<int> _answers = [-1, -1, -1];
  List<bool> _answerState = [false, false, false];
  int _currnetIndex = 0;
  SwiperController _controller = SwiperController();

  List<Widget> _buildCandidates(double width, Quiz quiz) {
    List<Widget> _children = [];
    for (int i = 0; i < 3; i++) {
      _children.add(
        CandWidget(
            tap: () {
              setState(() {
                for (int j = 0; j < 3; j++) {
                  if (j == i) {
                    _answerState[j] = true;
                    _answers[_currnetIndex] = j;
                  } else {
                    _answerState[j] = false;
                  }
                }
              });
            },
            index: i,
            width: width,
            text: quiz.candidates[i],
            answerState: _answerState[i]),
      );
      _children.add(
        Padding(
          padding: EdgeInsets.all(width * 0.024),
        ),
      );
    }
    return _children;
  }

  Widget _buildQuizCard(Quiz quiz, double width, double height) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, width * 0.024, 0, width * 0.024),
            child: Text(
              'Q' + (_currnetIndex + 1).toString() + '.',
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            width: width * 0.8,
            padding: EdgeInsets.only(top: width * 0.012),
            child: AutoSizeText(
              quiz.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: width * 0.048,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Column(
            children: _buildCandidates(width, quiz),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.024),
            child: Center(
              child: ButtonTheme(
                minWidth: width * 0.5,
                height: height * 0.05,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton(
                  child: _currnetIndex == widget.quizs.length - 1
                      ? const Text('????????????')
                      : const Text('????????????'),
                  onPressed: _answers[_currnetIndex] == -1
                      ? null
                      : () {
                          if (_currnetIndex == widget.quizs.length - 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                        answer: _answers,
                                        quizs: widget.quizs)));
                          } else {
                            _answerState = [false, false, false];
                            _currnetIndex += 1;
                            _controller.next();
                          }
                        },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Center(
          child: Container(
            width: width * 0.85,
            height: height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.lightBlue),
            ),
            child: Swiper(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(), // didn't skip quiz
              loop: false,
              itemCount: widget.quizs.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildQuizCard(widget.quizs[index], width, height);
              },
            ),
          ),
        ),
      ),
    );
  }
}
