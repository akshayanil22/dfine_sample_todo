import 'package:dartz/dartz.dart';
import 'package:dfine_todo/core/failure/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
