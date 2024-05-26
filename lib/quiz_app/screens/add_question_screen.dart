import 'package:flutter/material.dart';
import 'package:kawshik/quiz_app/models/questions.dart';
import 'package:kawshik/quiz_app/models/question.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();
  final TextEditingController _optionDController = TextEditingController();
  int _correctAnswerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _optionAController,
              decoration: InputDecoration(
                labelText: 'Option A',
              ),
            ),
            TextField(
              controller: _optionBController,
              decoration: InputDecoration(
                labelText: 'Option B',
              ),
            ),
            TextField(
              controller: _optionCController,
              decoration: InputDecoration(
                labelText: 'Option C',
              ),
            ),
            TextField(
              controller: _optionDController,
              decoration: InputDecoration(
                labelText: 'Option D',
              ),
            ),
            SizedBox(height: 12),
            DropdownButtonFormField(
              value: _correctAnswerIndex,
              onChanged: (value) {
                setState(() {
                  _correctAnswerIndex = value as int;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text('Option A'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('Option B'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Option C'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('Option D'),
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    String question = _questionController.text;
    List<String> options = [
      _optionAController.text,
      _optionBController.text,
      _optionCController.text,
      _optionDController.text,
    ];
    Question newQuestion = Question(
      question: question,
      options: options,
      correctAnswerIndex: _correctAnswerIndex,
    );

    // Add the new question to the existing list of questions
    questions.add(newQuestion);

    // Optionally, you can print the list of questions to verify it
    print(questions);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
