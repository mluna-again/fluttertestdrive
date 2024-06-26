import "package:flutter/material.dart";
import "package:flutter/services.dart";
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
            home: HomePage()));
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

  void removeFavorite(WordPair w) {
    favorites.remove(w);
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
          TextFormField(decoration: const InputDecoration(hintText: "Hi"),),
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

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = context.watch<TestDriveState>();
    var children = <Widget>[];

    for (var liked in state.favorites) {
      children.add(ListTile(
        leading: const Icon(Icons.favorite),
        title: Text(liked.asLowerCase),
        onTap: () {
          state.removeFavorite(liked);
        },
      ));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: ListView(
          children: children,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    Widget screen;
    switch (index) {
      case 0:
        screen = TestDrivePage();
        break;

      case 1:
        screen = FavoritesPage();
        break;

      default:
        throw UnimplementedError("No widget for $index index");
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: constraints.maxWidth >= 1000,
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text("Home")),
                NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text("Saved")),
              ],
              selectedIndex: index,
              onDestinationSelected: (value) {
                setState(() {
                  index = value;
                });
              },
            ),
          ),
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: screen,
          ))
        ],
      ));
    });
  }
}
