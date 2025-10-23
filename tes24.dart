import 'package:flutter/material.dart';

void main() {
  runApp(ChickenApp());
}

class ChickenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Приложение про курицу',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/info': (context) => InfoScreen(),
        '/gallery': (context) => GalleryScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главная')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/White_leghorn_chicken.jpg/320px-White_leghorn_chicken.jpg),
            SizedBox(height: 20),
            Text(Добро пожаловать в приложение про курицу!, style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/info'),
              child: Text(Подробнее),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final String description = Курица — домашняя птица, часто выращиваемая для яиц и мяса. Они всеядны и имеют острый слух и зрение. Курицы социальные животные и могут запоминать других птиц.;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Информация')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(description, style: TextStyle(fontSize: 18)),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/gallery'),
              child: Text(Галерея),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryScreen extends StatelessWidget {
  final List<String> photos = [
    https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Brahma_chicken_1.jpg/320px-Brahma_chicken_1.jpg,
    https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Cockeral_Brigantio.jpg/320px-Cockeral_Brigantio.jpg,
    https://upload.wikimedia.org/wikipedia/commons/thumb/3/32/White_chicken.jpg/320px-White_chicken.jpg,
    https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Chicken_in_pond.jpg/320px-Chicken_in_pond.jpg,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Галерея')),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return Image.network(photos[index], fit: BoxFit.cover);
        },
      ),
    );
  }
}