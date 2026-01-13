import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediconnect/common/auth/data/datasources/firebase_storage_layer.dart';
import 'package:mediconnect/common/auth/data/datasources/http_storage_layer.dart';
import 'package:mediconnect/common/auth/data/datasources/storage_layer.dart';
import 'package:mediconnect/core/config/app_config.dart';
import 'package:mediconnect/core/network/dio_client.dart';

enum StorageType {
  firebase,
  http,
}

class StorageLayerFactory {
  static StorageLayer createFirebaseStorageLayer(FirebaseAuth firebaseAuth) {
    return FirebaseStorageLayer(firebaseAuth: firebaseAuth);
  }

  static StorageLayer createHttpStorageLayer(DioClient dioClient) {
    dioClient.setBaseUrl(AppConfig.baseUrl);
    return HttpStorageLayer(dioClient: dioClient);
  }

  /// Returns Firebase storage layer for authentication operations
  static StorageLayer getFirebaseForAuth(FirebaseAuth firebaseAuth) {
    return createFirebaseStorageLayer(firebaseAuth);
  }

  /// Returns HTTP storage layer for other CRUD operations
  static StorageLayer getHttpForCrud(DioClient dioClient) {
    return createHttpStorageLayer(dioClient);
  }

  /// Factory method that returns appropriate storage layer based on operation type
  static StorageLayer createForOperation(OperationType operationType, {
    FirebaseAuth? firebaseAuth,
    DioClient? dioClient,
  }) {
    switch (operationType) {
      case OperationType.authentication:
        if (firebaseAuth == null) {
          throw ArgumentError('FirebaseAuth instance required for authentication operations');
        }
        return getFirebaseForAuth(firebaseAuth);

      case OperationType.crud:
        if (dioClient == null) {
          throw ArgumentError('DioClient instance required for CRUD operations');
        }
        return getHttpForCrud(dioClient);
    }
  }
}

enum OperationType {
  authentication,
  crud,
}
