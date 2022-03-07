import 'package:codelab2_news_app/detail_page.dart';
import 'package:flutter/material.dart';

//Model
import './model/article.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'News App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        initialRoute: NewsListPage.routeName,
        routes: {
          NewsListPage.routeName: (context) => const NewsListPage(),
          ArticleDetailPage.routeName: (context) => ArticleDetailPage(
                article: ModalRoute.of(context)?.settings.arguments as Article,
              )
        });
  }
}

class NewsListPage extends StatelessWidget {
  static const routeName = '/article_list';

  const NewsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("News App"),
        ),
        body: FutureBuilder<String>(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/articles.json'),
            builder: (context, snapshot) {
              final List<Article> articles = parseArticles(snapshot.data);
              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return _buildArticleItem(context, articles[index]);
                },
              );
            }));
  }
}

Widget _buildArticleItem(BuildContext context, Article article) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: Image.network(article.urlToImage, width: 100),
    title: Text(article.title),
    subtitle: Text(article.author),
    onTap: () {
      Navigator.pushNamed(context, ArticleDetailPage.routeName,
          arguments: article);
    },
  );
}
