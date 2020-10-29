import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/helpers/fetch_preview_helper.dart';
import 'package:restfulness/src/models/preview_model.dart';

class LinkPreview extends StatefulWidget {
  const LinkPreview({
    Key key,
    @required this.url,
    this.builder,
    this.titleStyle,
    this.bodyStyle,
  }) : super(key: key);

  final String url;

  /// Customized rendering methods
  final Widget Function(PreviewModel info) builder;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  @override
  _LinkPreviewState createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  String _url;
  PreviewModel _info;

  @override
  void initState() {
    _url = widget.url.trim();
    _info = FetchPreviewHelper().getInfoFromCache(_url);
    if (_info == null) {
      _getInfo();
    }
    super.initState();
  }

  Future<void> _getInfo() async {
    if (_url.startsWith("http")) {
      _info = await FetchPreviewHelper().fetch(_url);
      if (mounted) setState(() {});
    } else {
      print("Links don't start with http or https from : $_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(_info);
    }
    if (_info == null) return const SizedBox();

    return Container();
  }
}
