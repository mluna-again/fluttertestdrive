import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:english_words/english_words.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => TestDriveState(),
        child: MaterialApp(
            title: "Testdrive",
            theme: ThemeData(
                useMaterial3: true,
                colorScheme:
                    ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
            home: TestDrivePage()));
  }
}

class TestDriveState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }

    notifyListeners();
  }

  bool isFavorite() {
    return favorites.contains(current);
  }
}

class TestDrivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appstate = context.watch<TestDriveState>();
    var word = appstate.current;

    var favoriteIcon = const Icon(Icons.heart_broken);
    if (!appstate.isFavorite()) {
      favoriteIcon = const Icon(Icons.favorite);
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('A random idea:'),
          BigCard(word: word),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: appstate.toggleFavorite,
                label: const Text("Favorite"),
                icon: favoriteIcon,
              ),
              ElevatedButton(
                onPressed: appstate.getNext,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.word,
  });

  final WordPair word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 100,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          word.asLowerCase,
          style: style,
          semanticsLabel: "${word.first} ${word.second}",
        ),
      ),
    );
  }
}
