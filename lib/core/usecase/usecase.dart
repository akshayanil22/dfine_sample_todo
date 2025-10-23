import 'package:dartz/dartz.dart';
import 'package:dfine_todo/core/failure/failure.dart';

abstract class Usecase<Type, Params> {
  const Usecase();
  Future<Either<Failure, Type>> call(Params params);
}
