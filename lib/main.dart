import 'dart:ui';
import 'package:calcmate/splashscreen.dart';
import 'package:flutter/material.dart';
import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<String> buttonTexts = [
    "C",
    "( )",
    "%",
    "÷",
    "7",
    "8",
    "9",
    "×",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "<_",
    "0",
    ".",
    "="
  ];

  final TextEditingController _controller = TextEditingController();
  String _result = "";

  void _onButtonPressed(String value) {
    setState(() {
      String currentText = _controller.text;

      if (value == "C") {
        _controller.clear();
        _result = "";
      } else if (value == "<_") {
        if (currentText.isNotEmpty) {
          _controller.text = currentText.substring(0, currentText.length - 1);
        }
      } else if (value == "=") {
        _evaluateExpression();
      } else if (value == "( )") {
        int openBrackets = currentText.split('(').length - 1;
        int closeBrackets = currentText.split(')').length - 1;

        if (currentText.isEmpty || RegExp(r'[+\-×÷]$').hasMatch(currentText)) {
          _controller.text += "(";
        } else if (RegExp(r'\d$').hasMatch(currentText)) {
          if (openBrackets > closeBrackets) {
            _controller.text += ")";
          }
        } else if (openBrackets > closeBrackets) {
          _controller.text += ")";
        } else {
          _controller.text += "(";
        }
      } else if (value == "+/-") {
        if (currentText.isNotEmpty) {
          int lastOperatorIndex = currentText.lastIndexOf(RegExp(r'[+\-×÷]'));
          if (lastOperatorIndex == -1) {
            if (currentText.startsWith("-")) {
              _controller.text = currentText.substring(1);
            } else {
              _controller.text = "-$currentText";
            }
          } else {
            String beforeLastNumber =
            currentText.substring(0, lastOperatorIndex + 1);
            String lastNumber = currentText.substring(lastOperatorIndex + 1);
            if (lastNumber.startsWith("-")) {
              lastNumber = lastNumber.substring(1);
            } else {
              lastNumber = "-$lastNumber";
            }
            _controller.text = beforeLastNumber + lastNumber;
          }
        }
      } else if (value == "%") {
        _handlePercentage();
      } else {
        if (value == "(" && RegExp(r'\d$').hasMatch(currentText)) {
          _controller.text += "*(";
        } else {
          _controller.text += value;
        }
      }
    });
  }

  void _handlePercentage() {
    String expression = _controller.text;

    if (expression.isNotEmpty) {
      try {
        int lastOperatorIndex = expression.lastIndexOf(RegExp(r'[+\-×÷]'));
        String lastNumber = expression.substring(lastOperatorIndex + 1);

        if (lastNumber.isNotEmpty) {
          double percentage = double.parse(lastNumber) / 100;
          _controller.text = expression.substring(0, lastOperatorIndex + 1) +
              percentage.toString();
        }
      } catch (e) {
        _result = "Invalid Input";
      }
    }
  }

  void _evaluateExpression() {
    String expression = _controller.text;

    expression = expression.replaceAll("\u00d7", "*").replaceAll("\u00f7", "/");

    int openBrackets = expression.split('(').length - 1;
    int closeBrackets = expression.split(')').length - 1;

    while (openBrackets > closeBrackets) {
      expression += ')';
      closeBrackets++;
    }

    try {
      _result = _calculate(expression);

      if (_result.contains(".")) {
        double resultDouble = double.parse(_result);

        if (resultDouble == resultDouble.toInt()) {
          _result = resultDouble.toInt().toString();
        } else {
          _result = resultDouble.toStringAsFixed(4);
        }
      }
    } catch (e) {
      if (e.toString().contains("Division by zero")) {
        _result = "Can't divide by zero";
      } else {
        _result = "Invalid Input";
      }
    }
  }

  String preprocessExpression(String expression) {
    expression = expression.replaceAllMapped(
        RegExp(r'(\d)(\()'), (match) => '${match[1]}*${match[2]}');
    expression = expression.replaceAllMapped(
        RegExp(r'(\))(\()'), (match) => '${match[1]}*${match[2]}');
    return expression;
  }

  String _calculate(String expression) {
    while (expression.contains("(")) {
      int start = expression.lastIndexOf("(");
      int end = expression.indexOf(")", start);
      String subExpression = expression.substring(start + 1, end);
      String result = _calculateSimple(subExpression);
      expression = expression.replaceRange(start, end + 1, result);
    }

    return _calculateSimple(expression);
  }

  String _calculateSimple(String expression) {
    List<String> tokens = _tokenize(expression);

    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == "*" || tokens[i] == "/") {
        double num1 = double.parse(tokens[i - 1]);
        double num2 = double.parse(tokens[i + 1]);
        double result = 0.0;

        if (tokens[i] == "*") {
          result = num1 * num2;
        } else if (tokens[i] == "/") {
          if (num2 == 0) {
            throw Exception("Division by zero");
          }
          result = num1 / num2;
        }

        tokens.replaceRange(i - 1, i + 2, [result.toString()]);
        i--;
      }
    }

    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double num = double.parse(tokens[i + 1]);

      if (operator == "+") {
        result += num;
      } else if (operator == "-") {
        result -= num;
      }
    }

    return result.toString();
  }

  List<String> _tokenize(String expression) {
    List<String> tokens = [];
    String currentNum = "";
    bool lastTokenWasOperator = true;

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (RegExp(r'\d').hasMatch(char) || char == ".") {
        currentNum += char;
        lastTokenWasOperator = false;
      } else {
        if (currentNum.isNotEmpty) {
          tokens.add(currentNum);
          currentNum = "";
        }

        if (char == "-" && lastTokenWasOperator) {
          currentNum += char;
        } else {
          tokens.add(char);
          lastTokenWasOperator = true;
        }
      }
    }

    if (currentNum.isNotEmpty) {
      tokens.add(currentNum);
    }

    return tokens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  const Color(0xFFDDE6F5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 16.0),
                  alignment: Alignment.centerRight,
                  child: TextField(
                    controller: _controller,
                    readOnly: true,
                    style: const TextStyle(fontSize: 32),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 18.0),
                alignment: Alignment.centerRight,
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 34, color: Colors.blueGrey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: const Divider(
                  thickness: 0.8,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1,
                  ),
                  itemCount: buttonTexts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    String buttonText = buttonTexts[index];
                    Color buttonColor;
                    Color textColor = const Color(0xFF2B2B2B);

                    if (["C", "( )", "%", "÷", "×", "-", "+", "+/-"]
                        .contains(buttonText)) {
                      buttonColor = const Color(0xFF7bd4f6);
                      textColor = Colors.white;
                    } else if (["<_"].contains(buttonText)) {
                      buttonColor = const Color(0xFFBFE0000);
                      textColor = Colors.white;
                    } else if (["="].contains(buttonText)) {
                      buttonColor = const Color(0xFF1751FD);
                      textColor = Colors.white;
                    } else {
                      buttonColor = Colors.white;
                    }

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Button1(
                        bgcolor: buttonColor,
                        fgcolor: textColor,
                        buttontxt: buttonText == '<_' || buttonText == '()'
                            ? ''
                            : buttonText,
                        child: buttonText == '<_'
                            ? Image.asset(
                          'assets/clear.png',
                          width: 84,
                          height: 84,
                        )
                            : (buttonText == '( )'
                            ? Image.asset(
                          'assets/1.png',
                          width: 94,
                          height: 94,
                        )
                            : null),
                        onPressed: () => _onButtonPressed(buttonText),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
