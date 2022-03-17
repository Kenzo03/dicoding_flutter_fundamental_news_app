import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/card_article.dart';
import '../widgets/platform_widgets.dart';
import '../data/model/article.dart';
import '../data/api/api_service.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  late Future<ArticlesResult> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().topHeadlines();
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
        ),
        body: _buildList(context));
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('News App'),
          transitionBetweenRoutes: false,
        ),
        child: _buildList(context));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder(
        future: _article,
        builder: (context, AsyncSnapshot<ArticlesResult> snapshot) {
          var state = snapshot.connectionState;
          if (state != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data?.articles.length,
                  itemBuilder: (context, index) {
                    var article = snapshot.data?.articles[index];
                    return CardArticle(article: article!);
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return const Text('');
            }
          }
        });
  }

  // Widget _buildArticleItem(BuildContext context, Article article) {
  //   return Material(
  //     child: ListTile(
  //       contentPadding:
  //           const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       leading: Image.network(
  //         article.urlToImage,
  //         width: 100,
  //       ),
  //       title: Text(article.title),
  //       subtitle: Text(article.author),
  //       onTap: () {
  //         Navigator.pushNamed(context, ArticleDetailPage.routeName,
  //             arguments: article);
  //       },
  //     ),
  //   );
  // }
}
