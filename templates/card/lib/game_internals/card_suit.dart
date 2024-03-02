import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardSuit {
  ///代表卡片ID
  final TrashType trashType;

  const CardSuit(this.trashType);

  int get internalRepresentation {
    return trashType.internalRepresentation;
  }

  String backImagePath(int value) {
    return trashType.getItemsPathList()[value];
  }

  String get frontImagePath {
    return 'assets/images/card_suit/earth_nature_futaba.png';
  }
}

/// 垃圾分類
enum TrashType {
  ///一般垃圾
  trash(10, 29),

  ///可回收垃圾
  recyclableTrash(11, 44),

  ///養豬廚餘
  kitchenWasteAsPigFood(21, 26),

  ///堆肥廚餘
  kitchenWasteAsCompost(22, 25),

  ///紙容器
  paperContainers(31, 10),

  ///紙類
  paper(32, 5),

  ///紙類垃圾
  trashPaper(33, 3),

  ///塑膠容器
  plasticBottles(41, 16),

  ///乾淨發泡塑膠
  styrofoam(42, 2),

  ///乾淨塑膠袋
  cleanPlasticBags(43, 2),

  ///其他塑膠袋
  otherPlastics(44, 0),

  ///玻璃容器
  glassContainers(50, 13),

  ///電子電器
  electronicAppliances(61, 13),

  ///資訊物品
  itEquipment(62, 13),

  ///乾電池
  dryCellBatteries(63, 6),

  ///光碟片
  vcdOrDvd(64, 3),

  ///金屬容器
  metalContainers(70, 7),

  ///照明光源
  lightingSources(8, 0),

  ///舊衣
  secondHandClothes(9, 0),

  ///廢食舊油
  wasteCookingOil(10, 0),
  ;

  final int internalRepresentation;
  final int itemsCount;

  const TrashType(this.internalRepresentation, this.itemsCount);
}

extension ExTrashType on TrashType {
  static final _log = Logger('ExTrashType');

  String typeName(BuildContext context) {
    switch (this) {
      case TrashType.trash: //一般垃圾
        return AppLocalizations.of(context)!.trash;
        return 'Non-recyclable\nTrash';
      case TrashType.recyclableTrash: //可回收垃圾
        return AppLocalizations.of(context)!.recyclableTrash;
        return 'Recyclable\nTrash';
      case TrashType.kitchenWasteAsPigFood: //養豬廚餘
        return AppLocalizations.of(context)!.kitchenWasteAsPigFood;
        return 'Kitchen Waste\nAs Pig Food';
      case TrashType.kitchenWasteAsCompost: //堆肥廚餘
        return AppLocalizations.of(context)!.kitchenWasteAsCompost;
        return 'Kitchen Waste\nAs Compost';
      case TrashType.paperContainers: //紙容器
        return AppLocalizations.of(context)!.paperContainers;
        return 'Paper\nContainers';
      case TrashType.paper: //紙類
        return AppLocalizations.of(context)!.paper;
        return 'Paper\n';
      case TrashType.trashPaper: //紙類垃圾
        return AppLocalizations.of(context)!.trashPaper;
        return 'Trash\n';
      case TrashType.plasticBottles:
        return AppLocalizations.of(context)!.plasticBottles;
        return 'Plastic\nBottles';
      case TrashType.styrofoam:
        return AppLocalizations.of(context)!.styrofoam;
        return 'Styrofoam\n';
      case TrashType.cleanPlasticBags:
        return AppLocalizations.of(context)!.cleanPlasticBags;
        return 'Clean\nPlastic Bags';
      case TrashType.otherPlastics: //其他塑膠袋
        return AppLocalizations.of(context)!.otherPlastics;
        return 'Other\nPlastics';
      case TrashType.glassContainers: //玻璃容器
        return AppLocalizations.of(context)!.glassContainers;
        return 'Glass\nContainers';
      case TrashType.metalContainers: //金屬容器
        return AppLocalizations.of(context)!.metalContainers;
        return 'Metal\nContainers';
      case TrashType.electronicAppliances: //電子電器
        return AppLocalizations.of(context)!.electronicAppliances;
        return 'Electronic\nAppliances';
      case TrashType.itEquipment: //資訊物品
        return AppLocalizations.of(context)!.itEquipment;
        return 'IT\nEquipment';
      case TrashType.dryCellBatteries: //乾電池
        return AppLocalizations.of(context)!.dryCellBatteries;
        return 'Dry Cell\nBatteries';
      case TrashType.vcdOrDvd: //光碟片
        return AppLocalizations.of(context)!.vcdOrDvd;
        return 'VCD\nor\nDVD';
      case TrashType.lightingSources: //照明光源
        return AppLocalizations.of(context)!.lightingSources;
        return 'Lighting\nSources';
      case TrashType.secondHandClothes: //舊衣
        return AppLocalizations.of(context)!.secondHandClothes;
        return 'Second Hand\nClothes';
      case TrashType.wasteCookingOil: //廢食舊油
        return AppLocalizations.of(context)!.wasteCookingOil;
        return 'Waste\nCooking Oil';
      default:
        return '';
    }
  }

  String get _trashTypeImagePath {
    //前綴文字
    const path02 = 'assets/images/items/trashClassification02/images-';

    switch (this) {
      case TrashType.trash: //一般垃圾
      case TrashType.trashPaper: //紙類垃圾
        return '${path02}10.jpg';
      case TrashType.recyclableTrash: //可回收垃圾
        return '${path02}11.jpg';
      case TrashType.kitchenWasteAsPigFood: //養豬廚餘
        return '${path02}21.jpg';
      case TrashType.kitchenWasteAsCompost: //堆肥廚餘
        return '${path02}22.jpg';
      case TrashType.paperContainers: //紙容器
        return '${path02}31.jpg';
      case TrashType.paper: //紙類
        return '${path02}32.jpg';
      case TrashType.plasticBottles: //塑膠容器
        return '${path02}41.jpg';
      case TrashType.styrofoam: //乾淨發泡塑膠
        return '${path02}42.jpg';
      case TrashType.cleanPlasticBags: //乾淨塑膠袋
        return '${path02}43.jpg';
      case TrashType.glassContainers: //玻璃容器
        return '${path02}50.jpg';
      case TrashType.electronicAppliances: //電子電器
        return '${path02}61.jpg';
      case TrashType.itEquipment: //資訊物品
        return '${path02}62.jpg';
      case TrashType.dryCellBatteries: //乾電池
      case TrashType.vcdOrDvd: //光碟片
      case TrashType.metalContainers: //金屬容器
        return '${path02}63.jpg';
      case TrashType.otherPlastics: //其他塑膠袋
      case TrashType.lightingSources: //照明光源
      case TrashType.secondHandClothes: //舊衣
      case TrashType.wasteCookingOil: //廢食舊油
      default:
        return '${path02}10.jpg';
    }
  }

  String get _trashTypeFolderPath {
    //前綴文字
    const path = 'assets/images/items/trashClassification';

    switch (this) {
      case TrashType.trash: //一般垃圾
        return '${path}_0010/';
      case TrashType.recyclableTrash: //可回收垃圾
        return '${path}_0011/';
      case TrashType.kitchenWasteAsPigFood: //養豬廚餘
        return '${path}_0021/';
      case TrashType.kitchenWasteAsCompost: //堆肥廚餘
        return '${path}_0022/';
      case TrashType.paperContainers: //紙容器
        return '${path}_0031/';
      case TrashType.paper: //紙類
        return '${path}_0032/';
      case TrashType.trashPaper: //紙類垃圾
        return '${path}_0033/';
      case TrashType.plasticBottles: //塑膠容器
        return '${path}_0041/';
      case TrashType.styrofoam: //乾淨發泡塑膠
        return '${path}_0042/';
      case TrashType.cleanPlasticBags: //乾淨塑膠袋
        return '${path}_0043/';
      // case TrashType.otherPlastics: //其他塑膠袋
      //   return '${path}_0044/';
      case TrashType.glassContainers: //玻璃容器
        return '${path}_0050/';
      case TrashType.electronicAppliances: //電子電器
        return '${path}_0061/';
      case TrashType.itEquipment: //資訊物品
        return '${path}_0062/';
      case TrashType.dryCellBatteries: //乾電池
        return '${path}_0063/';
      case TrashType.vcdOrDvd: //光碟片
        return '${path}_0064/';
      case TrashType.metalContainers: //金屬容器
        return '${path}_0070/';
      // case TrashType.lightingSources: //照明光源
      //   return '${path}_0080/';
      // case TrashType.secondHandClothes: //舊衣
      //   return '${path}_0090/';
      // case TrashType.wasteCookingOil: //廢食舊油
      //   return '${path}_0100/';
      default:
        return '';
    }
  }

  Image get trashTypeImage {
    return Image.asset(_trashTypeImagePath);
  }

  List<String> getItemsPathList() {
    // 创建一个列表来存储 JPG 文件的路径
    List<String> jpgPaths = [];

    for (int i = 0; i < itemsCount; i++) {
      if (_trashTypeFolderPath.isNotEmpty) {
        jpgPaths.add('${_trashTypeFolderPath}images-$i.jpg');
      }
    }

    return jpgPaths;
  }
}
