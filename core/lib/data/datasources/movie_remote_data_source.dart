import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';
import '../../utils/exception.dart';
import 'package:http/http.dart' as http;

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies(bool isTest);
  Future<List<MovieModel>> getPopularMovies(bool isTest);
  Future<List<MovieModel>> getTopRatedMovies(bool isTest);
  Future<MovieDetailResponse> getMovieDetail(int id, bool isTest);
  Future<List<MovieModel>> getMovieRecommendations(int id, bool isTest);
  Future<List<MovieModel>> searchMovies(String query, bool isTest);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());

    return securityContext;
  }

  @override
  Future<List<MovieModel>> getNowPlayingMovies(bool isTest) async {
    if (isTest) {
      final response =
          await client.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response =
          await ioClient.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id, bool isTest) async {
    if (isTest) {
      final response = await client.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response = await ioClient.get(Uri.parse('$BASE_URL/movie/$id?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id, bool isTest) async {
    if (isTest) {
      final response =
          await client.get(Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response =
          await ioClient.get(Uri.parse('$BASE_URL/movie/$id/recommendations?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies(bool isTest) async {
    if (isTest) {
      final response = await client.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response = await ioClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies(bool isTest) async {
    if (isTest) {
      final response = await client.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response =
          await ioClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, bool isTest) async {
    if (isTest) {
      final response =
          await client.get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    } else {
      HttpClient client = HttpClient(context: await globalContext);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => false;

      IOClient ioClient = IOClient(client);

      final response =
          await ioClient.get(Uri.parse('$BASE_URL/search/movie?$API_KEY&query=$query'));

      if (response.statusCode == 200) {
        return MovieResponse.fromJson(json.decode(response.body)).movieList;
      } else {
        throw ServerException();
      }
    }
  }
}
