import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:restfulness/src/blocs/category/categories_provider.dart';
import 'package:restfulness/src/blocs/link/links_provider.dart';
import 'package:restfulness/src/models/category_model.dart';
import 'package:restfulness/src/resources/repository.dart';
import 'package:restfulness/src/utils/json_utils.dart';
import 'package:restfulness/src/widgets/toast_context.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';
import '../link_preview_widget.dart';

class CardTileWidget extends StatefulWidget {
  final String url;
  final int urlId;
  final List<CategoryModel> category;

  final bool press;
  final int index;
  final double topPosition, height;
  final bool blankCard, removeAnimation;
  final Function bringToTop,
      rightPosition,
      firstIconPosition,
      secondIconPosition,
      thirdIconPosition,
      iconsTopPosition,
      removeIndex,
      selectedState;
  final Key key;

  CardTileWidget(
      {this.url,
      this.urlId,
      this.category,
      this.key,
      this.press,
      this.index,
      this.removeIndex,
      this.topPosition,
      this.height,
      this.blankCard,
      this.bringToTop,
      this.rightPosition,
      this.firstIconPosition,
      this.secondIconPosition,
      this.thirdIconPosition,
      this.iconsTopPosition,
      this.removeAnimation,
      this.selectedState});

  @override
  _CardTileWidgetState createState() => _CardTileWidgetState();
}

class _CardTileWidgetState extends State<CardTileWidget>
    with TickerProviderStateMixin {
  AnimationController controller,
      controller2,
      controller3,
      opacityController,
      controller4;
  Animation<double> xAnimation,
      yAnimation,
      yTopAnimation,
      yBottomAnimation,
      xAnimationTwo,
      xNewAnimation,
      xMaxAnimation,
      xBackAnimation,
      opacityAnimation,
      slideAnimation;

  double xPositionOne = 0;
  double xPositionTwo = 0;
  double yNewPositionOne = 0;
  bool onePositionEnd = false;
  bool onePositionStart = false;
  bool oneAnimationStart = false;
  bool oneAnimationContinue = false;
  bool animationXForce = false;
  bool animationTop = false;
  bool animationZero = true;
  double yPosition;
  int yAnimationAxis;
  bool big100 = false;
  bool backX = false;
  bool pos, opacityVisible, remove, openUrl, share;
  int selectedState = 0;

  @override
  void initState() {
    super.initState();
    opacityVisible = true;
    remove = false;
    openUrl = false;
    share = false;
    yPosition = widget.topPosition;
    yAnimationAxis = 0;

    controller =
        AnimationController(duration: Duration(milliseconds: 850), vsync: this);
    opacityController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    controller2 =
        AnimationController(duration: Duration(milliseconds: 170), vsync: this);
    controller3 =
        AnimationController(duration: Duration(milliseconds: 170), vsync: this);
    controller4 =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    opacityAnimation =
        Tween<double>(begin: 1, end: 0).animate(opacityController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                widget.removeIndex(widget.index);
              });
            }
          });

    xMaxAnimation = Tween<double>(begin: 100, end: 116).animate(controller2)
      ..addListener(() {
        setState(() {});
      });

    xBackAnimation = Tween<double>(begin: 100, end: 135).animate(controller3)
      ..addListener(() {
        setState(() {
          if (xBackAnimation.value > 100) {
            widget.secondIconPosition(true);
          } else {
            widget.secondIconPosition(false);
          }
        });
      });

    yAnimation = Tween<double>(
            begin: widget.topPosition, end: (widget.topPosition - 16.0))
        .animate(controller2)
          ..addListener(() {
            setState(() {
              if (animationTop) {
                if (widget.topPosition > yAnimation.value) {
                  widget.thirdIconPosition(true);
                } else {
                  widget.thirdIconPosition(false);
                }
              }
            });
          });
    yBottomAnimation = Tween<double>(
            begin: widget.topPosition, end: (widget.topPosition + 16.0))
        .animate(controller2)
          ..addListener(() {
            setState(() {
              if (!animationTop) {
                if (widget.topPosition < yBottomAnimation.value) {
                  widget.firstIconPosition(true);
                } else {
                  widget.firstIconPosition(false);
                }
              }
            });
          });
  }

  @override
  void dispose() {
    controller.dispose();
    controller2.dispose();
    controller3.dispose();
    opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blankCard) {
      return Positioned(
        top: yPosition,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 25,
          color: Colors.transparent,
        ),
      );
    }

    if (big100 && xPositionOne < 100) {
      pos = true;
    } else {
      pos = false;
    }

    xAnimation = Tween<double>(begin: pos ? 100 : xPositionOne, end: 0)
        .animate(CurvedAnimation(curve: Curves.ease, parent: controller))
          ..addListener(() {
            setState(() {
              // Icon Animation Pass
              if (xAnimation.value > 95) {
                widget.rightPosition(true);
              } else if (onePositionEnd) {
                widget.rightPosition(false);
              }
              if (xAnimation.value < 10) {
                oneAnimationContinue = false;
              }
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                xPositionOne = 0;
                big100 = false;
                yPosition = widget.topPosition;
              });
            }
          });

    double newPosition = xPositionOne >= 100
        ? (animationZero
            ? widget.topPosition
            : backX
                ? widget.topPosition
                : (animationTop ? yAnimation.value : yBottomAnimation.value))
        : backX
            ? widget.topPosition
            : (animationTop ? yAnimation.value : yBottomAnimation.value);

    if (widget.removeAnimation) controller4.forward();

    slideAnimation =
        Tween<double>(begin: (newPosition + 120.0), end: newPosition)
            .animate(controller4)
              ..addListener(() {
                setState(() {});
              });

    return Positioned(
      top: widget.removeAnimation ? slideAnimation.value : newPosition,
      left:
          (onePositionEnd ? xAnimation.value : (big100 ? 100 : xPositionOne)) <=
                  100
              ? (onePositionEnd
                  ? xAnimation.value
                  : big100
                      ? (backX ? xBackAnimation.value : xMaxAnimation.value)
                      : xPositionOne)
              : (backX ? xBackAnimation.value : xMaxAnimation.value),
      child: Opacity(
        opacity: opacityAnimation.value,
        child: GestureDetector(
          onPanStart: (details) {
            widget.bringToTop(widget);
            widget.iconsTopPosition((widget.topPosition + 100 + 14));
          },
          onPanUpdate: (position) {
            controller.reset();
            setState(() {
              oneAnimationContinue = true;
              oneAnimationStart = true;
              onePositionEnd = false;

              if (position.delta.dx < 0) {
                xPositionOne = 0.0;
              } else {
                xPositionOne += position.delta.dx;
              }

              if (xPositionOne >= 100) {
                big100 = true;
              }
              yPosition += position.delta.dy;
            });

            RenderBox box = context.findRenderObject();
            Offset local = box.globalToLocal(position.globalPosition);

            // Animation BackXTrue
            if ((local.dx > 220.0) &&
                (local.dy > 0.0) &&
                (local.dy < 120) &&
                position.delta.dx > 1.3) {
              controller3.forward();
              setState(() {
                selectedState = 2;
                remove = true;
                backX = true;
              });
            }

            // // Animation BackXFalse
            if ((local.dx < 100.0) &&
                position.delta.dx < -2.0 &&
                position.delta.dx > -3.0 &&
                backX) {
              controller3.reverse();
              setState(() {
                backX = true;
                animationTop = false;
                remove = false;
                openUrl = false;
                share = false;
                selectedState = 0;
                animationZero = false;
              });
            }

            // Animation Top
            if (local.dy < 0.0 &&
                position.delta.dy < -1.3 &&
                position.delta.dy > -2.3) {
              controller2.forward();
              setState(() {
                selectedState = 3;
                remove = false;
                openUrl = true;
                share = false;
                animationTop = true;
                animationZero = false;
                backX = false;
              });
            }
            // Animation Center
            if ((local.dy < 120 && local.dy > 0) &&
                (position.delta.dy < -1.3 || position.delta.dy > 1.3) &&
                !backX) {
              controller2.reverse();
              setState(() {
                selectedState = 0;
                remove = false;
                openUrl = false;
                share = false;
                animationZero = false;
                backX = false;
              });
            }
            // Animation Bottom
            if (local.dy > 110 &&
                (position.delta.dy > 1.2 && position.delta.dy < 2.2)) {
              controller2.forward();
              setState(() {
                remove = false;
                openUrl = false;
                share = true;
                selectedState = 1;
                animationTop = false;
                yAnimationAxis = 1;
                animationZero = false;
                backX = false;
              });
            }
            widget.selectedState({
              "list_id": widget.urlId,
              "select_action": selectedState,
            });
          },
          onPanEnd: (details) {
            controller.forward();
            controller2.reset();
            controller3.reset();
            setState(() {
              if (remove) {
                _showDeleteDialog(context);
              }
              if (openUrl) {
                _launchURL();
              }
              if (share) {
                final RenderBox box = context.findRenderObject();
                Share.share(widget.url,
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size);
              }
              backX = false;
              onePositionStart = false;
              yAnimationAxis = 0;
              animationZero = true;
              onePositionEnd = true;
              oneAnimationStart = false;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 0),
                  decoration: oneAnimationContinue
                      ? BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3),
                            bottomLeft: Radius.circular(3),
                          ),
                        )
                      : BoxDecoration(
                          color: Colors.transparent,
                        ),
                  child: LinkPreviewWidget(
                      id: widget.urlId,
                      url: widget.url,
                      category: widget.category),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDeleteDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        deleteLink().then((response) {
          if (response) {
            opacityVisible = false;
            opacityController.forward();

            final bloc = LinksProvider.of(context);
            bloc.deleteItemFromLinks(widget.urlId);

            ToastContext(context, "Deleted successfully", true);
            // reset category list
            final categoryBloc = CategoriesProvider.of(context);
            categoryBloc.fetchCategories();
          }
        });
        Navigator.of(context).pop();
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("Are you sure you want to delete this url?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> deleteLink() async {
    try {
      Repository repository = new Repository();
      final response = await repository.deleteLink(widget.urlId);

      return response;
    } catch (e) {
      if (JsonUtils.isValidJSONString(e.toString())) {
        ToastContext(context, json.decode(e.toString())["msg"], false);
      } else {
        ToastContext(context, "Unexpected server error", false);
      }
    }
    return false;
  }

  _launchURL() async {
    if (await canLaunch(widget.url)) {
      await launch(widget.url);
    } else {
      throw 'Could not launch $widget.url';
    }
  }
}
