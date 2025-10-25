import package:flutter/material.dart

void main() {
  runApp(MyApp())
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Flutter Demo,
      home: HomePage(),
    )
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState()
}

class _HomePageState extends State<HomePage> {
  String _text = 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flutter Demo App),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  _text = val
                })
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: Введите текст,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _text,
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    )
  }
}