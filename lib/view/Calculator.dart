import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _input = "";
  double? _num1;
  double? _num2;
  String? _operator;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        _output = "0";
        _num1 = null;
        _num2 = null;
        _operator = null;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_input.isNotEmpty) {
          _num1 = double.tryParse(_input);
          _operator = buttonText;
          _input = "";
        }
      } else if (buttonText == "=") {
        if (_input.isNotEmpty && _operator != null && _num1 != null) {
          _num2 = double.tryParse(_input);
          if (_num2 != null) {
            double result = 0;
            switch (_operator) {
              case "+":
                result = _num1! + _num2!;
                break;
              case "-":
                result = _num1! - _num2!;
                break;
              case "×":
                result = _num1! * _num2!;
                break;
              case "÷":
                if (_num2 == 0) {
                  _output = "Error (Div by 0)";
                  _input = "";
                  return;
                }
                result = _num1! / _num2!;
                break;
            }
            _output = result.toString();
            _input = result.toString();
            _num1 = null;
            _num2 = null;
            _operator = null;
          }
        }
      } else {

        if (buttonText == "." && _input.contains(".")) {

          return;
        }
        _input += buttonText;
        _output = _input;
      }
    });
  }

  Widget _buildButton(String text, {Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _buttonPressed(text),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(24),
            backgroundColor: color ?? Colors.grey,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: const Text(
          'Simple Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Row(
            children: [
              _buildButton("7"),
              _buildButton("8"),
              _buildButton("9"),
              _buildButton("÷", color: Colors.orange),
            ],
          ),
          Row(
            children: [
              _buildButton("4"),
              _buildButton("5"),
              _buildButton("6"),
              _buildButton("×", color: Colors.orange),
            ],
          ),
          Row(
            children: [
              _buildButton("1"),
              _buildButton("2"),
              _buildButton("3"),
              _buildButton("-", color: Colors.orange),
            ],
          ),
          Row(
            children: [
              _buildButton("0"),
              _buildButton("."),
              _buildButton("C", color: Colors.red),
              _buildButton("+", color: Colors.orange),
            ],
          ),
          Row(
            children: [
              _buildButton("=", color: Colors.green),
            ],
          )
        ],
      ),
    );
  }
}
