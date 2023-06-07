import 'package:example/cropResult.dart';
import 'package:example/imageCropController.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Image',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(title: 'Multi Image Crop (check Box - multi)'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AssetEntity> images = <AssetEntity>[];
  AssetEntity selectImage = const AssetEntity(
    id: 'noneImage',
    typeInt: 0,
    width: 0,
    height: 0,
  );
  List<AssetEntity> selectImageList = <AssetEntity>[];

  bool multi = false;

  @override
  void initState() {
    getAssetImageAllList();
    super.initState();
  }

  void getAssetImageAllList() async {
    // 권한확인 (권한이 없으면 이미지 표시 안함)

    List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        hasAll: true,
        onlyAll: false,
        type: RequestType.image,
        filterOption: FilterOptionGroup());

    List<AssetEntity> pageImages = await paths[0].getAssetListPaged(
      page: 0,
      size: 100,
    );
    if (pageImages.isNotEmpty) {
      PhotoCachingManager().requestCacheAssets(assets: pageImages);
    }
    setState(() {
      images = pageImages;
      selectImage = images[0];
      selectImageList.add(images[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (multi) {
                    multi = false;
                    selectImageList.clear();
                    selectImageList.add(selectImage);
                  } else {
                    multi = true;
                  }
                });
                print(selectImageList.length);
              },
              icon: multi
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.check_circle_outline)),
          const SizedBox(width: 10),
          ElevatedButton(
              onPressed: () async {
                List<String> cropImage =
                    await ImageCropController().cropTest(selectImageList);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CropResult(cropImage)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('next'))
        ],
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: selectImage.id == 'noneImage'
                ? null
                : AssetEntityImage(
                    selectImage,
                    fit: BoxFit.contain,
                  ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemBuilder: (_, index) {
                return imageThumbnail(index);
              },
              itemCount: images.length,
            ),
          )
        ],
      ),
    );
  }

  GestureDetector imageThumbnail(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectImage = images[index];

          if (multi) {
            selectImageList.add(images[index]);
          } else {
            selectImageList.clear();
            selectImageList.add(images[index]);
          }
        });
        print(selectImageList.length);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.grey,
            child: AssetEntityImage(
              images[index],
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(200),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
