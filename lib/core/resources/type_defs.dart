import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../data/error/failure.dart';
import '../data/models/base_response.dart';

typedef FromJson<T> = T Function(dynamic body);

typedef ParamsMap = Map<String, String?>?;

typedef BodyMap = Map<String, dynamic>;

typedef FormDataMap = FormData?;

typedef Result<T> = Future<Either<Failure, BaseResponse<T>>>;
