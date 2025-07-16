import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixed Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentInput = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operation = "";
  bool _isCalculating = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentInput = "";
        _num1 = 0;
        _num2 = 0;
        _operation = "";
        _isCalculating = false;
      } else if (buttonText == "⌫") {
        if (_currentInput.isNotEmpty) {
          _currentInput = _currentInput.substring(0, _currentInput.length - 1);
          _output = _currentInput.isEmpty ? "0" : _currentInput;
        }
      } else if (buttonText == "+/-") {
        if (_currentInput.isNotEmpty) {
          if (_currentInput.startsWith('-')) {
            _currentInput = _currentInput.substring(1);
          } else {
            _currentInput = '-$_currentInput';
          }
          _output = _currentInput;
        }
      } else if (buttonText == ".") {
        if (!_currentInput.contains(".")) {
          _currentInput += ".";
          _output = _currentInput;
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_currentInput.isNotEmpty) {
          _num1 = double.parse(_currentInput);
          _operation = buttonText;
          _isCalculating = true;
          _currentInput = "";
          _output = _num1.toString();
        }
      } else if (buttonText == "=") {
        if (_operation.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = double.parse(_currentInput);
          switch (_operation) {
            case "+":
              _currentInput = (_num1 + _num2).toString();
              break;
            case "-":
              _currentInput = (_num1 - _num2).toString();
              break;
            case "×":
              _currentInput = (_num1 * _num2).toString();
              break;
            case "÷":
              _currentInput = (_num1 / _num2).toString();
              break;
          }
          _operation = "";
          _num1 = 0;
          _isCalculating = false;
          _output = _currentInput;
        }
      } else {
        if (_isCalculating && _currentInput.isEmpty) {
          _currentInput = buttonText;
        } else {
          _currentInput += buttonText;
        }
        _output = _currentInput;
      }

      if (_output.endsWith(".0")) {
        _output = _output.substring(0, _output.length - 2);
      }
    });
  }

  Widget _buildButton(String buttonText, {bool isLarge = false}) {
    final isOperation = ["+", "-", "×", "÷", "="].contains(buttonText);
    final isSpecial = ["C", "⌫", "+/-"].contains(buttonText);

    return Expanded(
      flex: isLarge ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: double.infinity,
          child: Material(
            color: isOperation
                ? Theme.of(context).colorScheme.primary
                : isSpecial
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _buttonPressed(buttonText),
              child: Center(
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isOperation || isSpecial
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Column(
              children: [
                // Display - Constrained to prevent overflow
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.3,
                  ),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _output,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: _output.length > 10 
                                  ? 48 - (_output.length - 10) * 2 
                                  : 48,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_operation.isNotEmpty)
                            Text(
                              "$_num1 $_operation",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground
                                    .withOpacity(0.6),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Buttons - Properly constrained grid
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton("C"),
                              _buildButton("⌫"),
                              _buildButton("+/-"),
                              _buildButton("÷"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton("7"),
                              _buildButton("8"),
                              _buildButton("9"),
                              _buildButton("×"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton("4"),
                              _buildButton("5"),
                              _buildButton("6"),
                              _buildButton("-"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton("1"),
                              _buildButton("2"),
                              _buildButton("3"),
                              _buildButton("+"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              _buildButton("0", isLarge: true),
                              _buildButton("."),
                              _buildButton("="),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}