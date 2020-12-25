import 'package:flutter/material.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/link/links_bloc.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/screens/home_screen.dart';
import 'package:restfulness/src/widgets/animated/card_tile_widget.dart';
import 'package:restfulness/src/widgets/animated/icon_animation_widget.dart';

class LinkListWidget extends StatefulWidget {
  const LinkListWidget({Key key, @required this.screenName , this.categoryId}) : super(key: key);

  final int categoryId;
  final Type screenName;

  @override
  LinkListWidgetState createState() => LinkListWidgetState();
}

class LinkListWidgetState extends State<LinkListWidget>
    with SingleTickerProviderStateMixin {
  ScrollController _controller;

  List<LinkModel> listCardMessage;
  double _headingBarHeight = 4.0;
  double _buttonBarHeight = 0.0;
  double cardHeight = 120;
  List<CardTileWidget> cards;
  List<CardTileWidget> brintToTapCardList;
  double topPosition = 26;
  double iconsTopPositionData;
  double _totalHeight;

  // Icon Animation Bool
  bool rightPositionData,
      firstIconAnimationStartData,
      secondIconAnimationStartData,
      thirdIconAnimationStartData;

  // List render
  bool render;

  // Remove index
  int removeIndexData;
  bool removeAnimation = false;
  Map selectState = {};

  List<CardTileWidget> _list = new List<CardTileWidget>();

  LinksBloc linkBloc;

  int page;
  int pageSize;

  @override
  void initState() {
    super.initState();
    render = false;
    rightPositionData = false;
    firstIconAnimationStartData = false;
    secondIconAnimationStartData = false;
    thirdIconAnimationStartData = false;
    iconsTopPositionData = 0.0;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    this.page = firstPage;
    this.pageSize = firstPageSize;
  }

  // Card List
  void setCardList(List<dynamic> listCard) {
    if (listCard.length > 0) {
      topPosition = 26;

      _list = listCard.map((card) {
        topPosition = listCard.indexOf(card) == 0
            ? topPosition
            : (topPosition + cardHeight);

        return CardTileWidget(
          key: GlobalKey(),
          urlId: card.id,
          url: card.url,
          category: card.categories,
          index: listCard.indexOf(card),
          topPosition: topPosition,
          iconsTopPosition: iconsTopPosition,
          height: cardHeight,
          blankCard: false,
          bringToTop: bringToTop,
          rightPosition: rightPosition,
          firstIconPosition: firstIconPosition,
          secondIconPosition: secondIconPosition,
          thirdIconPosition: thirdIconPosition,
          removeIndex: removeItemList,
          removeAnimation: false,
          selectedState: selectedState,
        );
      }).toList();

      _list.add(
        CardTileWidget(
          index: (_list.length + 1),
          blankCard: true,
          topPosition: 0,
        ),
      );

      _list.add(
        CardTileWidget(
          index: (_list.length + 1),
          blankCard: true,
          topPosition: (topPosition + 120),
        ),
      );

      setState(() {});
    }
  }

  void rightPosition(bool data) {
    setState(() {
      rightPositionData = data;
    });
  }

  void firstIconPosition(bool data) {
    setState(() {
      firstIconAnimationStartData = data;
      secondIconAnimationStartData = false;
      thirdIconAnimationStartData = false;
    });
  }

  void secondIconPosition(bool data) {
    setState(() {
      secondIconAnimationStartData = data;
      thirdIconAnimationStartData = false;
      firstIconAnimationStartData = false;
    });
  }

  void thirdIconPosition(bool data) {
    setState(() {
      thirdIconAnimationStartData = data;
      secondIconAnimationStartData = false;
      firstIconAnimationStartData = false;
    });
  }

  void iconsTopPosition(double data) {
    setState(() {
      iconsTopPositionData = data;
    });
  }

  void bringToTop(CardTileWidget widget) {
    setState(() {
      _list.remove(widget);
      _list.add(widget);
    });
  }

  void selectedState(Map val) {
    setState(() {
      selectState = val;
    });
  }

  void removeItemList(int index) {
    if (index != null) {
      double removeItemTopPosition =
          _list.where((item) => item.index == index).toList()[0].topPosition;
      double newTopPosition = topPosition;
      _list.removeWhere((item) => item.index == index);
      _list = _list.map((card) {
        if (card.topPosition < removeItemTopPosition) {
          newTopPosition = card.topPosition;
          removeAnimation = false;
        } else {
          newTopPosition = (card.topPosition - 120.0);
          removeAnimation = true;
        }

        if ((card.blankCard) && (newTopPosition != 0)) {
          if (newTopPosition < (MediaQuery.of(context).size.height - 190)) {
            return CardTileWidget(
              key: GlobalKey(),
              urlId: card.urlId,
              url: card.url,
              category: card.category,
              index: card.index,
              topPosition: 0,
              iconsTopPosition: card.iconsTopPosition,
              height: cardHeight,
              blankCard: card.blankCard,
              bringToTop: bringToTop,
              rightPosition: rightPosition,
              firstIconPosition: firstIconPosition,
              secondIconPosition: secondIconPosition,
              thirdIconPosition: thirdIconPosition,
              removeIndex: removeItemList,
              removeAnimation: removeAnimation,
              selectedState: selectedState,
            );
          }
        }

        return CardTileWidget(
          key: GlobalKey(),
          urlId: card.urlId,
          url: card.url,
          category: card.category,
          index: card.index,
          topPosition: newTopPosition,
          iconsTopPosition: card.iconsTopPosition,
          height: cardHeight,
          blankCard: card.blankCard,
          bringToTop: bringToTop,
          rightPosition: rightPosition,
          firstIconPosition: firstIconPosition,
          secondIconPosition: secondIconPosition,
          thirdIconPosition: thirdIconPosition,
          removeIndex: removeItemList,
          removeAnimation: removeAnimation,
          selectedState: selectedState,
        );
      }).toList();

      setState(() {
        topPosition = (topPosition - 120.0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    linkBloc = LinksProvider.of(context);

    _totalHeight =
        (topPosition + _headingBarHeight + _buttonBarHeight + cardHeight + 25);
    return SingleChildScrollView(
      controller: _controller,
      physics: AlwaysScrollableScrollPhysics(),
      child: _list == null
          ? SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              height: _totalHeight < (MediaQuery.of(context).size.height - 190)
                  ? (MediaQuery.of(context).size.height - 190)
                  : _totalHeight,
              child: Stack(
                children: <Widget>[
                  // Card List
                  buildCardList(context),
                  // Animation Icons
                  IconAnimation(
                    leftPosition: -27.0,
                    topPosition: (iconsTopPositionData - 100.0),
                    rightAnimationStart: rightPositionData,
                    firstIconAnimationStart: firstIconAnimationStartData,
                    secondIconAnimationStart: secondIconAnimationStartData,
                    thirdIconAnimationStart: thirdIconAnimationStartData,
                  ),
                ],
              ),
            ),
    );
  }

  _scrollListener() {

    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {

      setState(() {
        page += 1;
      });

      if(widget.screenName == HomeScreenState){
        linkBloc.fetchLinks(page, pageSize);
      }else {
        linkBloc.fetchLinksByCategoryId(widget.categoryId,page, pageSize);
      }
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {}
  }

  Container buildCardList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(
          top: 0,
          left: 0.0,
          right: 0.0,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: _list.length == 2
                      ? [
                          CardTileWidget(
                            index: 0,
                            blankCard: true,
                            topPosition: 0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'No Item',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ]
                      : _list,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
