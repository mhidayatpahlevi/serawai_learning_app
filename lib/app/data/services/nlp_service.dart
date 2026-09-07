import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/nlp_result_model.dart';

class NlpService {
  // =====================================
  // BASE URL NLP
  // =====================================

  String get baseUrl {
    // Jika diberikan lewat --dart-define,
    // gunakan URL tersebut.
    const customUrl = String.fromEnvironment(
      'NLP_BASE_URL',
    );

    if (customUrl.isNotEmpty) {
      return customUrl;
    }

    // Flutter Web
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    // Android Emulator
    if (defaultTargetPlatform ==
        TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    // Windows / macOS / Linux
    return 'http://127.0.0.1:8000';
  }

  // =====================================
  // ANALISIS JAWABAN
  // =====================================

  Future<NlpResultModel> analyzeAnswer({
    required String template,
    required String userAnswer,
    required String referenceAnswer,
    required String targetRhyme,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/analyze',
      );

      debugPrint(
        'Menghubungi NLP API: $uri',
      );

      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type':
                  'application/json',
            },
            body: jsonEncode({
              'template':
                  template,
              'userAnswer':
                  userAnswer,
              'referenceAnswer':
                  referenceAnswer,
              'targetRhyme':
                  targetRhyme,
            }),
          )
          .timeout(
            const Duration(
              seconds: 30,
            ),
          );

      debugPrint(
        'NLP Status Code: '
        '${response.statusCode}',
      );

      debugPrint(
        'NLP Response: '
        '${response.body}',
      );

      if (response.statusCode != 200) {
        throw Exception(
          'NLP API error '
          '${response.statusCode}: '
          '${response.body}',
        );
      }

      final decoded =
          jsonDecode(
        response.body,
      );

      if (decoded
          is! Map<String, dynamic>) {
        throw Exception(
          'Format response NLP tidak valid.',
        );
      }

      return NlpResultModel.fromMap(
        decoded,
      );
    } catch (e) {
      debugPrint(
        'ERROR NLP SERVICE: $e',
      );

      rethrow;
    }
  }
}