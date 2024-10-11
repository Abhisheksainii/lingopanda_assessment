import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: ".env")
final class Env {
  @EnviedField(varName: 'NEWS_API_KEY')
  static const String newsApiKey = _Env.newsApiKey;
}
