import 'package:multi_image_crop/multi_image_crop.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageCropController {
  Future<List<String>> cropTest(List<AssetEntity> selectImage) async {
    // example result controller 
    List<String> cropImageResult = <String>[];
    List<AssetEntity> returnImage = ImageAssetCrop.cropImage(selectImage);
    for (AssetEntity id in returnImage) {
      cropImageResult.add(id.id);
    }
    return cropImageResult;
  }
}
