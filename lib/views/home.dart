
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperapp/Widgets/Widget.dart';
import 'package:wallpaperapp/data/data.dart';
import 'package:wallpaperapp/model/Wallpaper_Model.dart';
import 'package:wallpaperapp/model/categories_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/views/categorie.dart';
import 'package:wallpaperapp/views/image_view.dart';
import 'package:wallpaperapp/views/search.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  List<CategoriesModel> categories= new List();

  List<WallpaperModel> wallpapers= new List();

  TextEditingController searchController=new TextEditingController();

  getTrendingWallpapers() async{
    var response = await http.get("https://api.pexels.com/v1/curated?per_page=100"
    ,headers:{
      "Authorization": apiKEY});
    
    //print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData['photos'].forEach((element) {

      //print(element);
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);

    });

    setState(() {

    });

  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();

    // TODO: implement initState
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
        body:SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[

          Container(

            decoration: BoxDecoration(color: Color(0xfff5f8fd),
                
                borderRadius: BorderRadius.circular(30)
            ),
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.symmetric(horizontal: 24),
            child:Row(children: <Widget>[
                  Expanded(child:TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Wallpaper',
                        border: InputBorder.none
                    ),
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context)  => Search(
                            searchQuery: searchController.text,
                          )
                      ));
                    },
                      child: Container(child: Icon(Icons.search))),
                  ],),
            ),

                SizedBox(height: 16,),
                Container(
                  height: 80,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      return CategorieTile(
                        title: categories[index].categoriesName,
                        imgUrl: categories[index].imgUrl,
                      );
                  }),
                ),
                WallpappersList(wallpappers: wallpapers,context: context),
              ],


            ),
          ),
        )
    );

  }
}
class CategorieTile extends StatelessWidget {
  final String imgUrl,title;

  const CategorieTile({@ required Key key, this.imgUrl, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Categorie(
              categorieName: title.toLowerCase(),
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl,height: 50,width: 100,fit: BoxFit.cover,),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 50,width: 100,
              alignment: Alignment.center,
              child: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
            )
          ],

        ),
      ),
    );
  }
}

