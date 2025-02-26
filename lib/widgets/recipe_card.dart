import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required String title,
    required int like,
    required String difficulty,
    required String imageUrl,
  }) : _title = title,
       _like = like,
       _difficulty = difficulty,
       _imageUrl = imageUrl;

  final String _title;
  final int _like;
  final String _difficulty;
  final String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onPrimary,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          width: 170,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    _imageUrl,
                    width: double.infinity,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(_title, style: Theme.of(context).textTheme.bodyMedium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.favorite_rounded, size: 15),
                            Text(
                              _like.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.local_dining_rounded, size: 15),
                            Text(
                              _difficulty,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
