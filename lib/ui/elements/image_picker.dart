import 'dart:io';

import 'package:adrus/di/injection_container.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/svg_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:adrus/main.dart';

class MyImagePicker extends StatefulWidget {
  final int size;
  final Function(String) onImagePicked;

  MyImagePicker({Key key, @required this.size, @required this.onImagePicked})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateScreen();
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

class StateScreen extends State<MyImagePicker> {
  SessionManager sessionManager = sl<SessionManager>();
  File imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * SizeConfig.heightMultiplier,
      height: widget.size * SizeConfig.heightMultiplier,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            widget.size * SizeConfig.heightMultiplier / 2),
        child: Stack(
          children: [
            Positioned(
              child: (null != imageFile)
                  ? Image.file(
                      File(imageFile.path),
                      fit: BoxFit.cover,
                      width: widget.size * SizeConfig.heightMultiplier,
                      height: widget.size * SizeConfig.heightMultiplier,
                    )
                  : (null != sessionManager.getUser())
                      ? Image.network(
                          sessionManager.getUser().image,
                          fit: BoxFit.cover,
                          width: widget.size * SizeConfig.heightMultiplier,
                          height: widget.size * SizeConfig.heightMultiplier,
                        )
                      : Image.asset(
                          AppAssets.IC_PROFILE,
                          width: 8 * SizeConfig.heightMultiplier - 3,
                          height: 8 * SizeConfig.heightMultiplier,
                          color: AppColors.GRAY_MED,
                          fit: BoxFit.cover,
                        ),
            ),
            Positioned(
              child: Center(
                child: InkWell(
                  onTap: () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                    setState(() {
                      if (pickedFile != null) {
                        setState(() {
                          imageFile = File(pickedFile.path);
                          widget.onImagePicked(imageFile.path);
                        });
                        print("image: ${imageFile.path}");
                      } else {
                        print('No image selected.');
                      }
                    });
                  },
                  child: Image.asset(
                    AppAssets.IC_CAMERA,
                    width: 3.5 * SizeConfig.heightMultiplier,
                    height: 3.5 * SizeConfig.heightMultiplier,
                    color: AppColors.BLUE_MED,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*
  Widget _image() {
    return Center(
      child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
          ? FutureBuilder<void>(
              future: retrieveLostData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center();
                  case ConnectionState.done:
                    return _previewImage();
                  default:
                    if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}}',
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return Center();
                    }
                }
              },
            )
          : (_previewImage()),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if(null != _imageFile) {
      Future.delayed(Duration.zero, () async {
        widget.onImagePicked(_imageFile.path);
      });
    }

    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(
          _imageFile.path,
          fit: BoxFit.cover,
          width: widget.size * SizeConfig.heightMultiplier,
          height: widget.size * SizeConfig.heightMultiplier,
        );
      } else {

        return
          Image.file(
          File(_imageFile.path),
          fit: BoxFit.cover,
          width: widget.size * SizeConfig.heightMultiplier,
          height: widget.size * SizeConfig.heightMultiplier,
        );
      }
    } else if (_pickImageError != null) {
      return Text(
        'Error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return (null != sessionManager.getUser())? Image.network(sessionManager.getUser().image): Center();
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
      } else {
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return onPick(50* SizeConfig.heightMultiplier,
        50 * SizeConfig.heightMultiplier, 100);
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

   */
}
