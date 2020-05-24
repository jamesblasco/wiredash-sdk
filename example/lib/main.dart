import 'package:flutter/material.dart';
import 'package:wiredash/wiredash.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  /// Wiredash uses a navigation key to show and hide our overaly. This key must be passed to 
  /// the `MaterialApp` and `Wiredash` widgets. 
  /// Note you are not required to use `MaterialApp`, Wiredash will work perfectly fine with 
  /// `CupertinoApp` and `WidgetsApp`.
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    /// Here we wrap our app at the top level using a `Wiredash` widget. This requires us to pass 
    /// the `projectId` and `secret` obtained from the "configuration" section of your console. 
    /// Notice we are also passing our `_navigatorKey` to both widgets. 
    /// Wiredash also allows you to setup custom themes and translations using `WiredashThemeData` and 
    /// `WiredashTranslationData`. Both of these are optional but should your heart desire an extra layer 
    /// of customizability, you can make wiredash your own. 
    return Wiredash(
      projectId: "YOUR-PROJECT-ID",
      secret: "YOUR-SECRET",
      navigatorKey: _navigatorKey,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Adventure 🌎',
        home: DemoHomePage(),
      ),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FC),
      appBar: AppBar(
        title: const Text('Adventure 🌎'),
        backgroundColor: Color(0XFF02579B),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline),
            /// In a single line of code, we can show the Wiredash menu. Because we wrapped our app 
            /// with the `Wiredash` widget at the very top level, we can access this method from anywhere in our code.
            onPressed: () => Wiredash.of(context).show(),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: CitiesModel.cities.length,
          itemBuilder: (context, index) {
            return CountryCard(item: CitiesModel.cities[index]);
          },
        ),
      ),
    );
  }
}

class CitiesModel {
  const CitiesModel({
    @required this.title,
    @required this.description,
    @required this.image,
  });

  final String title;
  final String description;
  final String image;
  static const cities = <CitiesModel>[
    CitiesModel(
      title: 'Germany',
      description:
          "Frankfurt, a central German city on the river Main, is a major financial hub that's home to the European Central Bank. It's the birthplace of famed writer Johann Wolfgang von Goethe, whose former home is now the Goethe House Museum.",
      image:
          "https://pixabay.com/get/57e8d5474e5aad14f6d1867dda35367b1c3fdde05359754a_1920.jpg",
    ),
    CitiesModel(
      title: 'Ne York',
      description:
          "At its core is Manhattan, a densely populated borough that’s among the world’s major commercial, financial and cultural centers. Its iconic sites include skyscrapers such as the Empire State Building and sprawling Central Park.",
      image:
          "https://pixabay.com/get/57e1d0434a53ae14f6d1867dda35367b1c3fdde053587948_1920.jpg",
    ),
    CitiesModel(
      title: 'Trinidad and Tobago',
      description:
          "Trinidad and Tobago is a dual-island Caribbean nation near Venezuela,  with distinctive Creole traditions and cuisines. Trinidad’s capital,  Port of Spain, hosts a boisterous carnival featuring calypso and soca music.",
      image:
          "https://pixabay.com/get/54e4d4404952a914f6d1867dda35367b1c3fdde05250754b_1920.jpg",
    ),
  ];
}

class CountryCard extends StatelessWidget {
  const CountryCard({Key key, @required this.item}) : super(key: key);
  final CitiesModel item;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            item.image,
            width: double.maxFinite,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.description,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 16.0,
                  ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
