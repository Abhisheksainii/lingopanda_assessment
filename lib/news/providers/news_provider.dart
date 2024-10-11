import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:lingopanda_assessment/auth/models/user_model.dart';
import 'package:lingopanda_assessment/news/models/article_model.dart';
import 'package:lingopanda_assessment/news/repository/news_repository.dart';
import 'package:lingopanda_assessment/utils/log_utils.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository newsRepository;

  NewsProvider({required this.newsRepository});

  List<Article> _articles = [];

  List<Article> get articles => _articles;

  set articles(List<Article> values) {
    _articles = values;
    notifyListeners();
  }

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool values) {
    _loading = values;
    notifyListeners();
  }

  String _countryCode = "in";

  String get countryCode => _countryCode;

  set countryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  Future<void> fetchNewsArticles() async {
    loading = true;
    final result =
        await newsRepository.fetchTopHeadlines(countryCode: countryCode);
    result.when(success: (data) {
      articles = data;
    }, failure: (e) {
      logger.e(e);
    });
    loading = false;
  }

  void setupRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    countryCode = remoteConfig.getString("countryCode");

    // listen for realtime updation
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      countryCode = remoteConfig.getString("countryCode");
      await fetchNewsArticles();
    });
  }
}
