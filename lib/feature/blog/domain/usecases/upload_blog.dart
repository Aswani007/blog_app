import 'dart:io';

import 'package:blog_app/core/error/faliures.dart';
import 'package:blog_app/core/user_case/use_case.dart';
import 'package:blog_app/feature/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/blog.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams parameter) async {
    return await blogRepository.uploadBlog(
      image: parameter.image,
      title: parameter.title,
      content: parameter.content,
      posterId: parameter.posterId,
      topics: parameter.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams(
      {required this.posterId,
      required this.title,
      required this.content,
      required this.image,
      required this.topics});
}
