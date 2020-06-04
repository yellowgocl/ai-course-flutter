import 'dart:io';

import 'package:course/component/baseComponent.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/remote/components/image_data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as Widget;

class Image extends Widget.StatefulWidget {
  final Function(ImageInfo imageInfo, bool flag) onLoad;
  final double width, height;
  final Widget.AlignmentGeometry alignment;
  final Widget.BoxFit boxFit;
  final String src;
  final AssetType assetType;
  final Rect centerSlice;
  Image({key, this.onLoad, this.boxFit, this.centerSlice, @required this.src, this.assetType: AssetType.network, this.width, this.height, this.alignment}): super(key: key);
  @override
  State<StatefulWidget> createState() => ImageState();
}

class ImageState extends State<Image> {
  double _oriWidth;
  double _oriHeight;
  double _scale = 1;
  ImageStream _imageStream;
  ImageStreamListener _imageStreamListener;
  double get width{
    return widget.width??_oriWidth;
  }

  double get height{
    return widget?.height??_oriHeight;
  }

  double get calcWidth{
    return width != null ? width.toDouble() * _scale : null;
  }
  double get calcHeight {
    return height != null ? height.toDouble() * _scale : null;
  }

  Widget.Image get content {

    Widget.Image result;
    switch(widget?.assetType) {
      case AssetType.assets:
        assert(widget?.src is String);
        result = Widget.Image.asset(widget?.src, fit: widget?.boxFit
          , width: calcWidth, height: calcHeight, alignment: widget?.alignment
          , centerSlice: widget.centerSlice,);
        break;
      case AssetType.file:
        File f = File(widget?.src);
        result = Widget.Image.file(f, fit: widget?.boxFit
          , width: calcWidth, height: calcHeight, alignment: widget?.alignment
          , centerSlice: widget.centerSlice,);
        break;
      case AssetType.network:
        assert(widget?.src is String);
        result = Widget.Image.network(widget?.src, fit: widget?.boxFit
          , width: calcWidth, height: calcHeight, alignment: widget?.alignment
          , centerSlice: widget.centerSlice,);
        break;
      case AssetType.memory:
        throw new ArgumentError("未实现AssetType.memory.");
        break;
      default:
        throw new ArgumentError("不合法的AssetType, value = ${widget.assetType}.");
        break;
    }
    if (result!=null) {
      _imageStream = result.image.resolve(ImageConfiguration());
      _imageStream.addListener(_imageStreamListener);
    }
    return result;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageStream?.removeListener(_imageStreamListener);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageStreamListener = Widget.ImageStreamListener(_onLoad);
  }
  void _onLoad(Widget.ImageInfo imageInfo, bool flag) {
    _oriWidth = imageInfo.image.width?.toDouble();
    _oriHeight = imageInfo.image.height?.toDouble();
    _scale = imageInfo.scale;
    if (widget.onLoad != null) {
      widget.onLoad(imageInfo, flag);
    }
    setState(() {});
  }

  @override
  Widget.Widget build(BuildContext context) {
    // TODO: implement build
    return content;
  }
}

class ImageWrapper extends StatefulBaseComponent<ImageData> {
  final Function(ImageInfo imageInfo, bool flag) onLoad;
  ImageWrapper({Key key, ImageData data, this.onLoad}): super(key: key, data: data);

  @override
  State<StatefulWidget> createState() => ImageWrapperState();
}

class ImageWrapperState extends StatefulBaseComponentState<ImageWrapper> {
  ImageOptionData get option{
    return getOption();
  }
  @override
  Widget.Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: option?.padding,
        child:Image(
      src: option?.src, 
      assetType: option?.assetType,
      alignment: option?.alignment, 
      boxFit: option?.boxFit,
      onLoad: widget.onLoad,
      width: option?.size?.width,
      height: option?.size?.height,)
    );
  }
}