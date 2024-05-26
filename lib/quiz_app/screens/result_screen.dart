import 'package:flutter/material.dart';
import 'package:kawshik/quiz_app/models/questions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kawshik/quiz_app/screens/quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalTimeInSeconds;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalTimeInSeconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = 'I scored $score out of ${questions.length} in the quiz!';

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Total Time: ${totalTimeInSeconds}s',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(questions: questions),
                  ),
                );
              },
              child: Text('Start Again'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _sendEmail(message);
              },
              child: Text('Share Result'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEmail(String message) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'washikfaieaz@gmail.com',
      query: 'subject=Quiz Result&body=$message', // Email subject and body
    );
    String url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
