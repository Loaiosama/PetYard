import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    this.labelText = 'HINT',
  });
  final String labelText;
  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              onTap: () {
                setState(() {
                  flag = !flag;
                });
              },
              onFieldSubmitted: (value) {
                setState(() {
                  flag = false;
                });
              },
              decoration: InputDecoration(
                // labelText: 'Password',
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: flag
                      ? const Color.fromRGBO(0, 170, 91, 1)
                      : Colors.black.withOpacity(0.5),
                  fontSize: 18,
                ),
                // fillColor: Colors.white,
                // filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.2),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 170, 91, 1),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
