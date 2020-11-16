import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:restfulness/src/models/search_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/widgets/animated/card_tile_widget.dart';
import 'package:restfulness/src/widgets/animated/icon_animation_widget.dart';

import '../../constants.dart';
import '../widgets/category_widget.dart';

class NewSearchScreen extends StatefulWidget {
  @override
  _NewSearchScreen createState() => _NewSearchScreen();
}

class _NewSearchScreen extends State<NewSearchScreen>
    with SingleTickerProviderStateMixin {
  List<SearchLinkModel> listCardMessage;
  double _headingBarHeight = 4.0;
  double _buttonBarHeight = 0.0;
  double cardHeight = 120;
  List<CardTileWidget> cards;
  List<CardTileWidget> brintToTapCardList;
  double topPosition = 26;
  double iconsTopPositionData;

  Repository _repository = new Repository();

  TextEditingController searchController;
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

  Future<List<SearchLinkModel>> cardList(String word) async {
    List<SearchLinkModel> listCard = await _repository.searchLink(word);

    return listCard;
  }

  List<CardTileWidget> _list;

  @override
  void initState() {
    super.initState();

    _list = [];
    render = false;
    rightPositionData = false;
    firstIconAnimationStartData = false;
    secondIconAnimationStartData = false;
    thirdIconAnimationStartData = false;
    iconsTopPositionData = 0.0;
    searchController = new TextEditingController();
  }

  // Card List
  void getCardList(String word) {
    cardList(word).then(
      (futureResultList) {
        _list = futureResultList.map((card) {
          topPosition = futureResultList.indexOf(card) == 0
              ? topPosition
              : (topPosition + cardHeight);

          return CardTileWidget(
            key: GlobalKey(),
            urlId: card.id,
            url: card.url,
            category: [],
            index: futureResultList.indexOf(card),
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
      },
    );
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
    double _totalHeight =
        (topPosition + _headingBarHeight + _buttonBarHeight + cardHeight + 25);
    return Column(
      children: [
        Align(
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
                    if (searchController.text != '') {
                      setState(() {
                        topPosition = 26;
                        _state = 1;
                      });
                      getCardList(searchController.text);
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
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: _totalHeight < (MediaQuery.of(context).size.height - 190)
                  ? (MediaQuery.of(context).size.height - 190)
                  : _totalHeight,
              child: Stack(
                children: <Widget>[
                  //Person Card List
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
          ),
        ),
      ],
    );
  }

  Container buildCardList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0 ,bottom: 30),
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
                  children: _list.length == 0
                      ? [
                          CategoryWidget(),
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
      onChanged: (word) {
        if (word != '') {
          setState(() {
            topPosition = 26;
            _state = 1;
          });
          getCardList(word);
        } else {
          setState(() {
            topPosition = 26;
            _list = [];
          });
        }
      },
      controller: searchController,
      decoration: InputDecoration(
          hintText: 'Search links',
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
        MdiIcons.magnify,
        color: Colors.white,
      );
    }
  }
}
