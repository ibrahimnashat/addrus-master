import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MDragWidget extends StatefulWidget {
  final Widget child;
  final bool removeShadow;
  final double startPostionX;
  final double startPostionY;
  final bool isCircle;
  final bool isTimer;
  final double max;

  MDragWidget(
      {@required this.child,
      this.isTimer = true,
      this.max,
      this.removeShadow = false,
      this.isCircle = false,
      this.startPostionX = 0,
      this.startPostionY = 0});
  @override
  _MDragWidgetState createState() => _MDragWidgetState();
}

class _MDragWidgetState extends State<MDragWidget> {
  double _positionX = 0;
  double _positionY = 0;

  @override
  void initState() {
    _positionX = widget.startPostionX;
    _positionY = widget.startPostionY;
    super.initState();
  }

  bool _taped = false;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
        bottom: _positionY,
        end: 0,
        start: 0,
        child: GestureDetector(
            onVerticalDragStart: (_) {
              setState(() {
                _taped = true;
              });
            },
            onVerticalDragEnd: (_) {
              setState(() {
                _taped = false;
              });
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              _positionY = MediaQuery.of(context).size.height -
                  details.globalPosition.dy -
                  20;
              _positionX = MediaQuery.of(context).size.width -
                  details.globalPosition.dx -
                  20;
              if (widget.max != null) {
                _positionY = MediaQuery.of(context).size.height -
                    details.globalPosition.dy -
                    20;
                if (widget.max <= _positionY) {
                  _positionY = widget.max;
                }
              }
              if (_positionX <= 0) _positionX = widget.startPostionX;
              if (_positionY <= 0) _positionY = widget.startPostionY;

              setState(() {});
            },
            child: Container(
              decoration: _taped && !widget.removeShadow
                  ? BoxDecoration(
                      color: Colors.white10,
                      shape: widget.isCircle
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      boxShadow: [
                          BoxShadow(
                              color: widget.isCircle
                                  ? Colors.red.withOpacity(0.5)
                                  : Colors.red.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 5)
                        ])
                  : null,
              child: widget.child,
            )));
  }
}

extension AddToWidget on Widget {
  Widget isDrag(Widget drag, {bool backgroundShow = false, Widget drag2}) {
    return Stack(
      children: [
        this,
        if (backgroundShow)
          Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black38,
              )),
        if (drag2 != null)
          MDragWidget(
            child: drag2,
            isCircle: false,
          ),
        MDragWidget(
          child: drag,
          isCircle: false,
        ),
      ],
    );
  }
}
