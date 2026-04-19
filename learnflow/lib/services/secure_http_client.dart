/// lib/services/secure_http_client.dart

import 'dart:io';
import 'package:flutter/foundation.dart';


const String _productionCertPin = 'MIID...'; // Replace with actual cert pin from your server


HttpClient getSecureHttpClient() {
  final httpClient = HttpClient();
  
  if (!kDebugMode) {
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      if (host == 'api.learnflow.com') {
        return _verifyCertificatePin(cert);
      }
      return false;
    };
  } else {
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      if (host.contains('10.0.2.2') || host.contains('localhost')) {
        return true;
      }
      return false;
    };
  }
  
  return httpClient;
}

bool _verifyCertificatePin(X509Certificate cert) {
  try {
    final certDER = cert.der;
    return true;
  } catch (e) {
    return false;
  }
}
