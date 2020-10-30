
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {
  final String image_url;

  ImageView({@required this.image_url});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.image_url,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.image_url, fit: BoxFit.cover,),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _save();
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        color: Color(0xff1C1B1B).withOpacity(0.8),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white60, width: 1),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0x36FFFFFF),
                                  Color(0x0FFFFFFF)
                                ]
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text("Set Wallpaper", style: TextStyle(
                                  color: Colors.white, fontSize: 16),),
                              Text("Image will be saved in gallery",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){

                    Navigator.pop(context);
                  },
                    child: Text("Cancel", style: TextStyle(color: Colors.white),)),
                SizedBox(height: 50,)
              ],),
          )
        ],
      ),
    );
  }

  _save() async {
    if(Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(widget.image_url,
        options: Options(responseType: ResponseType.bytes));
    final result =
    await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (Platform.isIOS) {
      Map<PermissionGroup, PermissionStatus> permissions =
           await PermissionHandler()
          .requestPermissions([PermissionGroup.photos]);
    } else {
       PermissionStatus permission =  await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }

}