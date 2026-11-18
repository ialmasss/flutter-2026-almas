import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  final http.Client _client;
  final String host;

  Map<String, String> get _defaultHeaders => const {
    'Accept': 'application/json',
  };

  Uri buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    return Uri.https(host, path, queryParameters);
  }

  Future<dynamic> get(String path, [Map<String, dynamic>? query]) async {
    final uri = buildUri(path, query);
    final response = await _send(() => _client.get(uri, headers: _defaultHeaders));
    _check(response);
    return _decode(response);
  }

  Future<dynamic> post(
      String path, {
        required Map<String, dynamic> body,
        int expectedStatus = 201,
      }) async {
    final uri = buildUri(path);
    final headers = {
      ..._defaultHeaders,
      'Content-Type': 'application/json',
    };
    final response = await _send(
          () => _client.post(uri, headers: headers, body: jsonEncode(body)),
    );
    _check(response, expectedStatus: expectedStatus);
    return _decode(response);
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final response = await call().timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        log(
          '${response.request?.method} ${response.request?.url} -> ${response.statusCode}',
          name: 'api',
        );
      }
      return response;
    } on SocketException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response r, {int? expectedStatus}) {
    if (r.statusCode == 401) {
      throw const UnauthorizedException();
    }
    if (r.statusCode == 404) {
      throw const NotFoundException();
    }
    if (r.statusCode >= 500) {
      throw ServerException(r.statusCode);
    }
    if (expectedStatus != null && r.statusCode != expectedStatus) {
      throw BadResponseException('Expected $expectedStatus, got ${r.statusCode}');
    }
  }

  dynamic _decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException('Invalid JSON: ${e.message}');
    }
  }
}