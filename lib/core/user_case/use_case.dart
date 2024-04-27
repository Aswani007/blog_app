//creating use case in core because it can be used at other places also
import 'package:blog_app/core/error/faliures.dart';
import 'package:fpdart/fpdart.dart';

//asking from the function that the interface will be of what type
//we cannot define a fix no.of parameter here,so ask for parameter from the use case and pass it

abstract interface class UseCase<SuccessType, Parameter> {
  Future<Either<Failure, SuccessType>> call(Parameter parameter);
}

class NoParams {}
