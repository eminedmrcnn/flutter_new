import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/news_service.dart';
import 'models/article.dart';
import 'signin_page.dart';
import 'package:flutter/material.dart';

/*void main() {
  runApp(MyApp());
} */

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haberler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Haberler'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 FirebaseAuth _auth = FirebaseAuth.instance;
  /*List<Articles> articles = [];

  @override
  void initState() {
    NewsService.getNews().then((value) {
      setState(() {
        articles = value;
      });
    });
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ),
        centerTitle: true,
        actions: [
          //! Builder eklemezsek Scaffold.of() hata verecektir!
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.input),
              onPressed: () async {
                // TODO: Çıkış yap
                await _auth.signOut();
                if(await GoogleSignIn().isSignedIn()) {
                  print("Gogole User");
                  await GoogleSignIn().disconnect();
                  await GoogleSignIn().signOut();
                }

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Başarıyla çıkış yapıldı"),
                ));

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: Center()

      /* Center(
          child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Image.network(articles[index]?.urlToImage??"unknown"),
                      ListTile(
                        leading: Icon(Icons.arrow_drop_down_circle),

                        title:  Text(articles[index]?.title??"unknown"),
                        subtitle: Text(articles[index]?.author??"unknown"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(articles[index]?.description??"unknown"),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(
                              onPressed: () async {
                                await launch(articles[index]?.url??"unknown");
                              },
                              child: Text('Habere Git')),
                        ],
                      ),
                    ],
                  ),
                );
              })), */
    );
  }
}