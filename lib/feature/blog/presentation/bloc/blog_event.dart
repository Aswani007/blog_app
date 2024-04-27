part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent extends Equatable {}

final class AddItemToListEvent extends BlogEvent {
  final String itemName;

  AddItemToListEvent({required this.itemName});

  @override
  // TODO: implement props
  List<Object?> get props => [itemName];
}

final class PickImageFromGalleryEvent extends BlogEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BlogUploadE extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  // final File image;
  // final List<String> topics;

  BlogUploadE({
    required this.posterId,
    required this.title,
    required this.content,
    // required this.image,
    // required this.topics,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class BlogFetchAllBlogE extends BlogEvent {
  @override
  List<Object?> get props => [];
}
