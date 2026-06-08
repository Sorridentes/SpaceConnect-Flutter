import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/astronomy_model.dart';

/// Serviço responsável por comunicação com a API NASA APOD.
/// Equivalente ao AstronomyApi.kt + AstronomyRemoteDataSource.kt do projeto Kotlin.
class NasaApiService {
  static const String _baseUrl = 'https://api.nasa.gov';
  static const String _apiKey = 'fUTzNjMcedOvndwDI8hjaSu9piizmy5d2qqtKMJv';

  /// Busca a lista de astronomias por intervalo de datas.
  /// Equivalente ao getAstronomyListByDate() do Kotlin.
  Future<List<AstronomyModel>> getAstronomyListByDate(
    String startDate,
    String endDate,
  ) async {
    final url = Uri.parse(
      '$_baseUrl/planetary/apod?api_key=$_apiKey&start_date=$startDate&end_date=$endDate',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => AstronomyModel.fromApiResponse(json))
          .where((item) => item.mediaType == 'image')
          .toList();
    } else {
      throw Exception('Erro ao carregar dados da NASA: ${response.statusCode}');
    }
  }

  /// Busca uma astronomia específica por data.
  /// Equivalente ao getAstronomyByDate() do Kotlin.
  Future<AstronomyModel> getAstronomyByDate(String date) async {
    final url = Uri.parse(
      '$_baseUrl/planetary/apod?api_key=$_apiKey&date=$date',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return AstronomyModel.fromApiResponse(data);
    } else {
      throw Exception('Erro ao carregar dados da NASA: ${response.statusCode}');
    }
  }
}
