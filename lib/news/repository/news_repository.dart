import 'package:dio/dio.dart';
import 'package:lingopanda_assessment/common/endpoints.dart';
import 'package:lingopanda_assessment/env.dart';
import 'package:lingopanda_assessment/news/models/article_model.dart';
import 'package:lingopanda_assessment/utils/result.dart';

class NewsRepository {
  NewsRepository();

  Future<Result<List<Article>>> fetchTopHeadlines({
    required String countryCode,
  }) async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(queryParameters: {
        "country": countryCode,
        "apiKey": Env.newsApiKey,
      });
      final url = "${ApiEndpoints.baseUrl}${ApiEndpoints.topHeadlines}";
      final response = await dio.get(url);
      final articles = response.data["articles"] as List;
      return Result.success(
          data: articles.map((e) => Article.fromJson(e)).toList());
    } catch (e) {
      return Result.failure(reason: e.toString());
    }
  }
}
