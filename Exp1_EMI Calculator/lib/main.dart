import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EMIApp());
}

class EMIApp extends StatelessWidget {
  const EMIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF2F5FA),
        fontFamily: 'Roboto',
      ),
      home: const EMICalculatorScreen(),
    );
  }
}

class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({super.key});

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  final TextEditingController principalController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  double emi = 0.0;

  void calculateEMI() {
    double principal = double.parse(principalController.text);
    double annualRate = double.parse(rateController.text);
    double tenure = double.parse(tenureController.text);

    double monthlyRate = annualRate / 12 / 100;
    double months = tenure * 12;

    double emiValue = (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    setState(() {
      emi = emiValue;
    });
  }

  void resetFields() {
    principalController.clear();
    rateController.clear();
    tenureController.clear();
    setState(() {
      emi = 0.0;
    });
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2E86FF), Color(0xFF6FB1FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Center(
              child: Text(
                "EMI Calculator",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Card Container
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // Loan Amount
                      TextField(
                        controller: principalController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Loan Amount"),
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 20),

                      // Interest Rate
                      TextField(
                        controller: rateController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Interest Rate (%)"),
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 20),

                      // Tenure
                      TextField(
                        controller: tenureController,
                        keyboardType: TextInputType.number,
                        decoration: inputStyle("Tenure (Years)"),
                        style: const TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 30),

                      // Calculate Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: calculateEMI,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Calculate EMI",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Reset Button
                      SizedBox(
                        height: 55,
                        child: OutlinedButton(
                          onPressed: resetFields,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // EMI Result Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Monthly EMI",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "₹${emi.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
