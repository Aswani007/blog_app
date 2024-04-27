import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/feature/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams parameter) async {
    return await blogRepository.getAllBlogs();
  }
}
