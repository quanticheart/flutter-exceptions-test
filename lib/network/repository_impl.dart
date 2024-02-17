
import 'package:dartz/dartz.dart';
import 'package:flutter_exceptions/app/constants.dart';
import 'package:flutter_exceptions/app_prefs.dart';
import 'package:flutter_exceptions/network/api_service.dart';
import 'package:flutter_exceptions/network/error_handler.dart';
import 'package:flutter_exceptions/network/failure.dart';
import 'package:flutter_exceptions/network/netword_info.dart';
import 'package:flutter_exceptions/response/article_response_dto.dart';
import 'package:flutter_exceptions/response/base_response_dto.dart';

class RepositoryImpl  {
  final NetworkInfo _networkInfo;
  final ApiService _apiService;
  final AppPreferences _appPref;

  RepositoryImpl(this._networkInfo, this._apiService, this._appPref);

  @override
  Future<Either<Failure, List<ArticleResponseDto>>> getArticles() async {
    if (await _networkInfo.isConnected) {
      print(_appPref.getLocal().countryCode);
      try {
        final params = {
          "apiKey": Constants.key,
          "country": _appPref.getLocal().countryCode,
        };
        final response = await _apiService.get(endPoint: "top-headlines", params: params);
        // success
        // return either right
        // return data
        final data = BaseResponseDto.fromJson(response.data);
        return Right(data.articles!);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
