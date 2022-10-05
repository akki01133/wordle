import 'dart:convert';

import 'package:dio/dio.dart';

import '../helpers/dioException.dart';

class DioClient {
  late final Dio _dio;
  static const String baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en/';
  // receiveTimeout
  static const int receiveTimeout = 15000;
  // connectTimeout
  static const int connectionTimeout = 15000;

  static final _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectionTimeout,
    receiveTimeout: receiveTimeout,
  );

  DioClient(){
    _dio = Dio(_baseOptions);
  }

  Future<Response> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}


class DictionaryApi{
  final DioClient client;
  dioError(e) => DioException.fromDioError(e).toString();

  DictionaryApi(this.client);

  Future<WordMeaning> getMeaning(String word)async{
    if(word.length!=5){
      throw 'not 5 words letter';
    }
    try {
      final response = await client.get(word);
      final wordMeaning = WordMeaning.fromJson(response.data[0]);
      return wordMeaning;
    }on DioError catch(e){
      throw dioError(e);
    }on Error catch(e){
      print(e);
      print(e.stackTrace);
      throw 'error  in api';
    }
  }
}


class WordMeaning {
  late String word;
  late List<Meanings> meanings;

  WordMeaning({required this.word,required this.meanings});

  WordMeaning.fromJson(Map<String, dynamic> json) {
    word = json['word'];
      meanings = <Meanings>[];
      json['meanings'].forEach((v) {
        meanings.add(Meanings.fromJson(v));
      });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['word'] = word;
      data['meanings'] = meanings.map((v) => v.toJson()).toList();
    return data;
  }
}

class Meanings {
  late String partOfSpeech;
  late List<Definitions> definitions;

  Meanings({required this.partOfSpeech, required this.definitions});

  Meanings.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];
      definitions = <Definitions>[];
      json['definitions'].forEach((v) {
        definitions.add(Definitions.fromJson(v));
      });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['partOfSpeech'] = partOfSpeech;
    data['definitions'] = definitions.map((v) => v.toJson()).toList();
    return data;
  }

}

class Definitions {
  late String definition;

  Definitions({required this.definition});

  Definitions.fromJson(Map<String, dynamic> json) {
    definition = json['definition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['definition'] = definition;
    return data;
  }
}
