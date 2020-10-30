import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/Widgets/Widget.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/data/data.dart';
import 'package:wallpaperapp/model/Wallpaper_Model.dart';


class Search extends StatefulWidget {
  final String searchQuery;

  Search({this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = new TextEditingController();

  List<WallpaperModel> wallpapers= new List();


  getSearchWallpapers(String query) async{
    var response = await http.get("https://api.pexels.com/v1/search?query=$query&per_page=100"
        ,headers:{
          "Authorization": apiKEY});

    //print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData['photos'].forEach((element) {

      print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);

    });

    setState(() {

    });

  }
  @override
  void initState() {
    // TODO: implement initState
    getSearchWallpapers(widget.searchQuery);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: BrandName()),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            hintText: 'Search Wallpaper',
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          getSearchWallpapers(searchController.text);
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              WallpappersList(wallpappers: wallpapers,context: context),
            ],
          ),
        ),
      ),
    );
  }
}
