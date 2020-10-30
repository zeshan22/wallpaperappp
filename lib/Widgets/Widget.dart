import 'package:flutter/material.dart';
import 'package:wallpaperapp/model/Wallpaper_Model.dart';
import 'package:wallpaperapp/views/image_view.dart';

Widget BrandName(){
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
      children: <TextSpan>[
        TextSpan(text: 'Wallpaper',style: TextStyle(color: Colors.black26)),
        TextSpan(text: 'Hub',style: TextStyle(color: Colors.blue)),
      ]
    )
  );
}

Widget WallpappersList({List<WallpaperModel> wallpappers,context}){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.6,
    mainAxisSpacing: 6.0,
    crossAxisSpacing: 6.0,
    children:wallpappers.map((e){
      return GridTile(
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)  => ImageView(
                    image_url: e.src.portrait,
                  )
              ));
            },
            child: Hero(
              tag: e.src.portrait,
              child: Container(

               child: ClipRRect(
                   borderRadius: BorderRadius.circular(8),
                   child: Image.network(e.src.portrait,fit: BoxFit.cover,)),
              ),
            ),
          ),

      );
    }
    ).toList(),
    ),
  );
}