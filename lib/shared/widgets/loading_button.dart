import 'package:flutter/material.dart';

enum ProgressButtonState {
  Default,
  Processing,
}

enum ProgressButtonType {
  Raised,
  Flat,
  Outline,
}

// ignore: must_be_immutable
class MLoadingButton extends StatefulWidget {
  final ProgressButtonType type;

  final double width;
  final double height;
  final bool radiusBottomOnly;
  final bool radiusBottomEndOnly;
  final bool radiusBottomStartOnly;

  final double borderRadius;
  final bool animate;
  final Color loaderColor;
  final String title;
  final TextStyle style;
  final Color backgroundColor;
  final Color border;
  final Function onPressed;
  bool isFinished;
  final bool no15Timer;
  final bool notLoading;

  final Widget widget;

  MLoadingButton({
    Key key,
    this.onPressed,
    this.radiusBottomEndOnly = false,
    this.radiusBottomStartOnly = false,
    this.notLoading = false,
    this.widget,
    this.type = ProgressButtonType.Raised,
    this.title,
    this.border,
    this.style,
    this.no15Timer = false,
    this.radiusBottomOnly = false,
    this.isFinished = true,
    this.loaderColor,
    this.backgroundColor,
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius = 20.0,
    this.animate = true,
  }) : super(key: key);

  @override
  _MLoadingButtonState createState() => _MLoadingButtonState();
}

class _MLoadingButtonState extends State<MLoadingButton>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
  Animation _anim;
  AnimationController _animController;
  Duration _duration = const Duration(milliseconds: 250);
  ProgressButtonState _state;
  double _width;
  double _height;
  double _borderRadius;

  @override
  dispose() {
    _animController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _reset();
    super.deactivate();
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  void _reset() {
    _state = ProgressButtonState.Default;
    _width = widget.width;
    _height = widget.height;
    _borderRadius = widget.borderRadius;
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    if (widget.isFinished && _loading) {
      _loading = false;
      try {
        _reverse();
        _toDefault();
      } catch (e) {}
    }
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: SizedBox(
        key: _globalKey,
        height: _height,
        width: _width,
        child: _buildChild(context),
      ),
    );
  }

  // ignore: missing_return
  Widget _buildChild(BuildContext context) {
    var padding = const EdgeInsets.all(0.0);
    var color = widget.backgroundColor;
    var shape = RoundedRectangleBorder(
        borderRadius: widget.radiusBottomEndOnly && !_loading
            ? BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(_borderRadius))
            : widget.radiusBottomStartOnly && !_loading
                ? BorderRadiusDirectional.only(
                    bottomStart: Radius.circular(_borderRadius))
                : widget.radiusBottomOnly && !_loading
                    ? BorderRadius.vertical(
                        bottom: Radius.circular(_borderRadius))
                    : BorderRadius.circular(_borderRadius));

    switch (widget.type) {
      case ProgressButtonType.Raised:
        return RaisedButton(
          elevation: 0,
          padding: padding,
          color: color,
          shape: shape,
          child: _buildChildren(context),
          onPressed: _onButtonPressed,
        );
      case ProgressButtonType.Flat:
        return FlatButton(
          padding: padding,
          color: color,
          shape: shape,
          child: _buildChildren(context),
          onPressed: _onButtonPressed,
        );
      case ProgressButtonType.Outline:
        return OutlineButton(
          padding: padding,
          color: color,
          shape: shape,
          child: _buildChildren(context),
          onPressed: _onButtonPressed,
        );
    }
  }

  Widget _buildChildren(BuildContext context) {
    Widget ret;
    switch (_state) {
      case ProgressButtonState.Default:
        ret = widget.widget ??
            Text(
              widget.title,
              style: TextStyle(fontSize: (14), color: Colors.white)
                  .merge(widget.style),
            );
        break;
      case ProgressButtonState.Processing:
        ret = CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              widget.loaderColor ?? Colors.white),
        );
        break;
    }
    return ret;
  }

  void _onButtonPressed() {
    if (!_loading && !widget.notLoading) {
      widget.isFinished = false;
      _loading = true;
      _forward();
      _toProcessing();
      widget.onPressed();
    }
    if (widget.notLoading) widget.onPressed();
  }

  void _toProcessing() {
    setState(() {
      _state = ProgressButtonState.Processing;
    });
  }

  void _toDefault() {
    if (mounted) {
      _state = ProgressButtonState.Default;
    } else {
      _state = ProgressButtonState.Default;
    }
  }

  void _forward() {
    double initialWidth = _width;
    double initialBorderRadius = widget.borderRadius;
    double targetWidth = _height;
    double targetBorderRadius = _height / 2;
    _animController = AnimationController(duration: _duration, vsync: this);
    _anim = Tween(begin: 0.0, end: 1.0).animate(_animController)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - targetWidth) * _anim.value);
          _borderRadius = initialBorderRadius -
              ((initialBorderRadius - targetBorderRadius) * _anim.value);
        });
      });
    _animController.forward();
  }

  void _reverse() {
    _animController.reverse();
  }
}
