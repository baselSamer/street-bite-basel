import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/models/home/meals_response.dart';
import './api_endpoints.dart';

part './api_services.g.dart';

@RestApi()
abstract class ApiServices {
  factory ApiServices(Dio dio, {String baseUrl}) = _ApiServices;

  @GET(ApiEndpoints.searchMealsByLetter)
  Future<MealsResponse> getMealsByLetter(@Query('f') String letter);

  @GET(ApiEndpoints.mealDetails)
  Future<MealsResponse> getMealDetails(@Query('i') String mealId);
}
