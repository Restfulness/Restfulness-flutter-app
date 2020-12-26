import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({this.child});

  @override
  Widget build(BuildContext context) {
    final bloc = LinksProvider.of(context);

    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.fetchLinks(firstPage,firstPageSize);
      },
    );
  }
}
