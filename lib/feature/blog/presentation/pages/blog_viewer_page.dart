import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calc_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;

  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));

  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'By ${blog.posterName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${formateDatadMMMYYYY(blog.updateAt)} . ${calcReadingTime(blog.content)} min',
                style: const TextStyle(
                  color: AppPallete.greyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(imageUrl: blog.imageUrl),
              ),
              const SizedBox(height: 20),
              Text(
                blog.content,
                style: const TextStyle(fontSize: 16, height: 2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
