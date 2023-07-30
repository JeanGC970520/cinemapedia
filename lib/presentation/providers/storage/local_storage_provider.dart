
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/infrastructure/datasources/isar_datasource.dart';
import 'package:cinemapedia/infrastructure/respositories/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider(
  (ref) => LocalStorageRepositoryImpl( IsarDatasource() )
); 