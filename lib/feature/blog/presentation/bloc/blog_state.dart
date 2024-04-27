part of 'blog_bloc.dart';

sealed class BlogState extends Equatable {}

final class BlogInitial extends BlogState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BlogLoading extends BlogState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BlogSuccess extends BlogState {
  final List<String>? professionList;
  final File? pickedFile;
  final bool? shouldNavigate;

  BlogSuccess({
    this.professionList,
    this.pickedFile,
    this.shouldNavigate,
  });

  BlogSuccess copyWith(
      {List<String>? professionList, File? pickedFile, bool? shouldNavigate}) {
    return BlogSuccess(
      professionList: professionList ?? this.professionList,
      pickedFile: pickedFile ?? this.pickedFile,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate,
    );
  }

  @override
  List<Object?> get props => [professionList, pickedFile, shouldNavigate];
}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;

  BlogDisplaySuccess(this.blogs);

  @override
  List<Object?> get props => [];
}
