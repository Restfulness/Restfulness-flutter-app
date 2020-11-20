import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/constants.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/link_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/widgets/animated/card_tile_widget.dart';
import 'package:restfulness/src/widgets/animated/icon_animation_widget.dart';

class LinkListWidget extends StatefulWidget {
  const LinkListWidget({Key key}) : super(key: key);

  @override
  LinkListWidgetState createState() => LinkListWidgetState();
}

class LinkListWidgetState extends State<LinkListWidget>
    with SingleTickerProviderStateMixin {
  List<LinkModel> listCardMessage;
  double _headingBarHeight = 4.0;
  double _buttonBarHeight = 0.0;
  double cardHeight = 120;
  List<CardTileWidget> cards;
  List<CardTileWidget> brintToTapCardList;
  double topPosition = 26;
  double iconsTopPositionData;
  double _totalHeight;

  TextEditingController addLinkController;
  int _state = 0;

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

  @override
  void initState() {
    super.initState();
    render = false;
    rightPositionData = false;
    firstIconAnimationStartData = false;
    secondIconAnimationStartData = false;
    thirdIconAnimationStartData = false;
    iconsTopPositionData = 0.0;
    addLinkController = new TextEditingController();
  }

  // Card List
  void serCardList(List<LinkModel> listCard) {

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
    _totalHeight =
        (topPosition + _headingBarHeight + _buttonBarHeight + cardHeight + 25);
    return Column(
      children: [
        buildAddBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: _list == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    height: _totalHeight <
                            (MediaQuery.of(context).size.height - 190)
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
                          secondIconAnimationStart:
                              secondIconAnimationStartData,
                          thirdIconAnimationStart: thirdIconAnimationStartData,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildAddBar() {
    final bloc = LinksProvider.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(11, 15, 0, 15),
              child: Material(
                elevation: 6.0,
                borderRadius: BorderRadius.circular(30),
                child: _buildAddField(context),
              ),
              height: 50,
              width: double.infinity,
            ),
            flex: 4,
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (addLinkController.text != '') {
                  setState(() {
                    _state = 1;
                  });
                  // temp tag list FIXME: after have separated api for adding tags
                  List<String> tags = new List<String>();
                  tags.add("not tagged");

                  Repository repository = new Repository();
                  await repository.initializationLink;
                  try {
                    final id = await repository.insertLink(
                        tags, addLinkController.text);
                    if (id != null) {
                      // TODO show successes message
                      bloc.resetLinks();
                      bloc.fetchLinks();

                      topPosition = (topPosition + 120);
                      // get new categories if we have new one
                      final categoriesBloc = CategoriesProvider.of(context);
                      categoriesBloc.fetchCategories();
                    }
                  } catch (e) {
                    // TODO show failed message
                    // if (JsonUtils.isValidJSONString(e.toString())) {
                    //   showSnackBar(
                    //       context, json.decode(e.toString())["msg"], false);
                    // } else {
                    //   showSnackBar(context, "Unexpected server error ", false);
                    // }
                  }
                }
              },
              elevation: 8.0,
              color: primaryColor,
              child: _buildButtonIcon(),
              padding: EdgeInsets.all(14.0),
              shape: CircleBorder(),
            ),
            flex: 1,
          ),
        ],
      ),
    );
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

  Widget _buildAddField(BuildContext context) {
    return TextField(
      controller: addLinkController,
      decoration: InputDecoration(
          hintText: 'Add link',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
    );
  }

  Widget _buildButtonIcon() {
    if (_state == 1) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        //FIXME: shouldn't use delay!
        setState(() {
          _state = 0;
        });
      });
      return SizedBox(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
        height: 25.0,
        width: 25.0,
      );
    } else {
      return Icon(
        MdiIcons.plus,
        color: Colors.white,
      );
    }
  }
}
