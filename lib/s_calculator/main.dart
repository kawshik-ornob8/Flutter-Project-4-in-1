import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
      } else if (buttonText == '=') {
        _output = _calculate();
      } else if (buttonText == '√') {
        _output = _calculateSquareRoot();
      } else if (buttonText == 'x²') {
        _output = _calculateSquare();
      } else {
        if (_output == '0') {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  String _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_output);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  String _calculateSquareRoot() {
    try {
      double input = double.parse(_output);
      double result = sqrt(input);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  String _calculateSquare() {
    try {
      double input = double.parse(_output);
      double result = pow(input, 2).toDouble(); // Explicitly cast to double
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  void _onTrigFunction(String buttonText) {
    double input = double.parse(_output);
    double radians = input * (pi / 180);
    double result = 0.0;
    if (buttonText == 'sin') {
      result = sin(radians);
    } else if (buttonText == 'cos') {
      result = cos(radians);
    } else if (buttonText == 'tan') {
      result = tan(radians);
    }
    setState(() {
      _output = result.toStringAsFixed(4);
    });
  }

  Widget _buildButton(String buttonText, double buttonHeight, Color buttonColor,
      Color textColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        onPressed: () {
          if (buttonText == 'sin' ||
              buttonText == 'cos' ||
              buttonText == 'tan') {
            _onTrigFunction(buttonText);
          } else {
            _onPressed(buttonText);
          }
        },
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24.0, color: textColor),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                color: Colors.white,
                width: 0.5,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48.0),
              ),
            ),
          ),
          Divider(),
          Row(
            children: <Widget>[
              Expanded(
                  child: _buildButton('C', 1, Colors.green,
                      Colors.white)), // Change text color to white
              Expanded(child: _buildButton('π', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('e', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('√', 1, Colors.white, Colors.black)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: _buildButton('sin', 1, Colors.white, Colors.black)),
              Expanded(
                  child: _buildButton('cos', 1, Colors.white, Colors.black)),
              Expanded(
                  child: _buildButton('tan', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('/', 1, Colors.white, Colors.black)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _buildButton('7', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('8', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('9', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('*', 1, Colors.white, Colors.black)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _buildButton('4', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('5', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('6', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('-', 1, Colors.white, Colors.black)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _buildButton('1', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('2', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('3', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('+', 1, Colors.white, Colors.black)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: _buildButton('0', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('.', 1, Colors.white, Colors.black)),
              Expanded(child: _buildButton('=', 1, Colors.blue, Colors.white)),
              Expanded(
                  child: _buildButton(
                      'x²', 1, Colors.white, Colors.black)), // Square Button
            ],
          ),
        ],
      ),
    );
  }
}
