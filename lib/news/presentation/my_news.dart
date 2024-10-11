import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingopanda_assessment/auth/presentation/auth_screen.dart';
import 'package:lingopanda_assessment/common/widgets/custom_button.dart';
import 'package:lingopanda_assessment/news/models/article_model.dart';
import 'package:lingopanda_assessment/news/providers/news_provider.dart';
import 'package:lingopanda_assessment/utils/colors.dart';
import 'package:lingopanda_assessment/utils/datetime_utils.dart';
import 'package:lingopanda_assessment/utils/styles.dart';
import 'package:provider/provider.dart';

class MyNews extends StatefulWidget {
  const MyNews({super.key});

  @override
  State<MyNews> createState() => _MyNewsState();
}

class _MyNewsState extends State<MyNews> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>()
        ..setupRemoteConfig()
        ..fetchNewsArticles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final newsProvider = Provider.of<NewsProvider>(context, listen: true);
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {},
                child: CustomButton(
                    width: width,
                    height: height,
                    text: "Logout",
                    ontap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AuthScreen();
                            },
                          ),
                        );
                      }
                    }),
              )
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.blue,
        title: Text(
          'MyNews',
          style: Styles.inputTextStyle2.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Image.asset("assets/icons/location.png"),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  newsProvider.countryCode.toUpperCase(),
                  style: Styles.inputTextStyle2.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 22, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Top Headlines",
                style: Styles.inputTextStyle2,
              ),
              const SizedBox(
                height: 15,
              ),
              newsProvider.loading
                  ? const CircularProgressIndicator()
                  : newsProvider.articles.isEmpty
                      ? const Center(
                          child: Text("Oops!, no articles found",
                              style: Styles.inputTextStyle),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 16.w,
                            );
                          },
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: newsProvider.articles.length,
                          itemBuilder: (context, index) {
                            final article = newsProvider.articles[index];
                            return NewsContainer(article: article);
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsContainer extends StatelessWidget {
  const NewsContainer({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 146.h,
      width: 356.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ArticleDetails(article: article),
          ArticleImage(article: article)
        ],
      ),
    );
  }
}

class ArticleDetails extends StatelessWidget {
  const ArticleDetails({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.source?["name"],
          style: Styles.inputTextStyle2,
        ),
        SizedBox(
          width: 356.w / 2.2,
          child: Text(
            article.description ?? "",
            style: Styles.inputTextStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          DateTimeUtils.timeAgo(DateTime.parse(article.publishedAt ?? "")),
          style: Styles.inputTextStyle
              .copyWith(color: AppColor.grey, fontSize: 10),
        ),
      ],
    );
  }
}

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        article.urlToImage ?? "",
        width: 132.w,
        height: 119.h,
        fit: BoxFit.fill,
        errorBuilder: (context, _, __) {
          return Image.asset(
            "assets/images/flutter_logo.png",
            width: 132.w,
            height: 119.h,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
