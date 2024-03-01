'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "7ca806ba4cbf1ad71b40027336c70bc5",
"index.html": "6d7c3252eabfce19abbb4933d66baa6a",
"/": "6d7c3252eabfce19abbb4933d66baa6a",
"main.dart.js": "f67938a9a9c52b4a0102613c7a1818ef",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "ab1450a74276f35f3d1b9772fa456771",
"assets/AssetManifest.json": "f17ee05d752333b48cc4559829131533",
"assets/NOTICES": "3ddab3e073339a962bc6642f1b773fef",
"assets/FontManifest.json": "806f6b30fc84741899cf1b932dbce0fd",
"assets/AssetManifest.bin.json": "8dfec6f6e70085594a33852eba1aa857",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "9e2e0b3cd037445e17d706ad9ad41e48",
"assets/fonts/MaterialIcons-Regular.otf": "b7ac1ccc6e820b66761462fe3df60f94",
"assets/assets/music/Mr_Smith-Sunday_Solitude.mp3": "5fb1f2fbf4314eb5df35b62706942698",
"assets/assets/music/README.md": "035041cfb2070f794172dedb2aa709b6",
"assets/assets/music/Mr_Smith-Sonorus.mp3": "9353b7bb732002062e2c9107a95f3d2a",
"assets/assets/music/Mr_Smith-Azul.mp3": "9463595498dc48b3d3d6805fb7c19dc7",
"assets/assets/images/background/warumono.png": "cda9dadf12435e8aca3fd46915b505ab",
"assets/assets/images/background/kinshi.png": "b319c55cfe7cb336626d21707cb7940e",
"assets/assets/images/background/kirakira.png": "25ec344f905cf10a9480a641e9c512d4",
"assets/assets/images/background/gomisuteba.png": "86f3cee0189f3da3c3192b6231354ea1",
"assets/assets/images/background/earth_good.png": "262b381f2971724447b6090b8372862e",
"assets/assets/images/background/osen_kawa.png": "3c62490a0aae6aed054f9b6e7b55b467",
"assets/assets/images/background/kawa.png": "5b4710c572690a2673c9afda77a6d6b4",
"assets/assets/images/3x/settings.png": "21ff2cc135a762f74ed1a80aac6502bb",
"assets/assets/images/3x/restart.png": "429270ce832c881b80fbd592e5ff1e0e",
"assets/assets/images/3x/back.png": "88a977a654df5a490037340f90a5a19e",
"assets/assets/images/settings.png": "840fd7e3337c743046bf992ef18a10b8",
"assets/assets/images/restart.png": "d3d2e3f3b2f6cb1e1a69b8b2529096f7",
"assets/assets/images/card_suit/earth_nature_futaba.png": "adca8abcfabaf1f9f65c0d604ee2ff77",
"assets/assets/images/items/trashClassification_0041/images-7.jpg": "d8441da1cf13ebeaf446498d0e42bbf5",
"assets/assets/images/items/trashClassification_0041/images-6.jpg": "763e1155d1fb624ae5c3c829de31b90a",
"assets/assets/images/items/trashClassification_0041/images-4.jpg": "09f9f25987c28b36839950df2309574c",
"assets/assets/images/items/trashClassification_0041/images-5.jpg": "fc2b48e5160c69047283227a66fab389",
"assets/assets/images/items/trashClassification_0041/images-1.jpg": "69550aa6509000efaba8e177a2fcb9d1",
"assets/assets/images/items/trashClassification_0041/images-0.jpg": "a64141ccdf8dd85210c79efc92323b87",
"assets/assets/images/items/trashClassification_0041/images-2.jpg": "13589ed6462dc6f21d42f1f3128fd80f",
"assets/assets/images/items/trashClassification_0041/images-3.jpg": "56da4f027c2193aaef01831ee7f9d5b0",
"assets/assets/images/items/trashClassification_0041/images-13.jpg": "e63a20a4d41f11a35af775a32ba9dbcb",
"assets/assets/images/items/trashClassification_0041/images-12.jpg": "dadca9be76ffe4c97b948bfcd3d7c184",
"assets/assets/images/items/trashClassification_0041/images-10.jpg": "c55c12ed388ad53eadfe0cc2d33d63ef",
"assets/assets/images/items/trashClassification_0041/images-11.jpg": "d00d665a9feef07654670a4893f1d7a9",
"assets/assets/images/items/trashClassification_0041/images-8.jpg": "32c84b925694dade42bdc8a9a23295f0",
"assets/assets/images/items/trashClassification_0041/images-15.jpg": "583ac2bc956201ee2f6e54363f31796c",
"assets/assets/images/items/trashClassification_0041/images-14.jpg": "19031c57886047c21e789c75e71503b1",
"assets/assets/images/items/trashClassification_0041/images-9.jpg": "81c6f8d3ba891775329d21329aef66db",
"assets/assets/images/items/trashClassification_0070/images-6.jpg": "b1c666c89d4d835ca287340806c4f8f5",
"assets/assets/images/items/trashClassification_0070/images-4.jpg": "31041038bcea550a3bef855450f86843",
"assets/assets/images/items/trashClassification_0070/images-5.jpg": "7cf037586331f80650645e4436d3cf67",
"assets/assets/images/items/trashClassification_0070/images-1.jpg": "86f335ebc79f71d207a2ecc38d302e2b",
"assets/assets/images/items/trashClassification_0070/images-0.jpg": "184ae057ac8d7cbd735578df21ac97f9",
"assets/assets/images/items/trashClassification_0070/images-2.jpg": "e2976fc8776ef9d66c4322b5425e6db0",
"assets/assets/images/items/trashClassification_0070/images-3.jpg": "ba5c3c6105a2b7e3d5ed6aef593255b3",
"assets/assets/images/items/trashClassification02/images-50.jpg": "1a1eba63f8f8466490dd2a7950528d7d",
"assets/assets/images/items/trashClassification02/images-43.jpg": "4d566f9d4af94c1b3be6e2ac8d0166de",
"assets/assets/images/items/trashClassification02/images-42.jpg": "eaf77c9b0e8e5d037c159a4269305ffe",
"assets/assets/images/items/trashClassification02/images-41.jpg": "83961d60af56573d813771f742681bda",
"assets/assets/images/items/trashClassification02/images-32.jpg": "68026361d224a469b29bfb52983ad79c",
"assets/assets/images/items/trashClassification02/images-31.jpg": "0614fa85c130c02d522e32e49c0a0afe",
"assets/assets/images/items/trashClassification02/images-21.jpg": "a61e767b50840be06c9b9f84a8b21388",
"assets/assets/images/items/trashClassification02/images-22.jpg": "dd4ed843abdc8d0bcfcfade4fe409255",
"assets/assets/images/items/trashClassification02/images-10.jpg": "1c026d0e91ec67175de70ebb086ea8a4",
"assets/assets/images/items/trashClassification02/images-11.jpg": "6f05b6b92507d520930a1633fcd02710",
"assets/assets/images/items/trashClassification02/images-62.jpg": "c14fee7a90b57dea0223611becc6b776",
"assets/assets/images/items/trashClassification02/images-63.jpg": "04ad8abd09c68506369458b6b7c07cc0",
"assets/assets/images/items/trashClassification02/images-61.jpg": "24ba96b4dfdb66719e5baabc0e771dea",
"assets/assets/images/items/trashClassification_0022/images-7.jpg": "893deda065a24d6d9af6bb2efa1fcd9e",
"assets/assets/images/items/trashClassification_0022/images-6.jpg": "187239b080db86b0f531b89b0fb2a26b",
"assets/assets/images/items/trashClassification_0022/images-4.jpg": "04b7323f1035926334629aa623682724",
"assets/assets/images/items/trashClassification_0022/images-19.jpg": "880fdfda67b1d45d4b2afde7ebeb2467",
"assets/assets/images/items/trashClassification_0022/images-24.jpg": "3986727254e85c0ab7b3696030782ebd",
"assets/assets/images/items/trashClassification_0022/images-18.jpg": "a5a66ca428b2ea93a6f9be1f297152d8",
"assets/assets/images/items/trashClassification_0022/images-5.jpg": "c0e8a84dd2c5c08c9eb388b904c23742",
"assets/assets/images/items/trashClassification_0022/images-1.jpg": "f609fbdff7c689196f9669073be462b8",
"assets/assets/images/items/trashClassification_0022/images-20.jpg": "562bcb3a416a675e4a9cdb50dee40775",
"assets/assets/images/items/trashClassification_0022/images-21.jpg": "b82b6656e97e9ba3d4e067fc9d2d6657",
"assets/assets/images/items/trashClassification_0022/images-0.jpg": "cb13c6e48839a1eeca0d812f04186a97",
"assets/assets/images/items/trashClassification_0022/images-2.jpg": "0ef8a0571bd68354f35337a9b8b712e6",
"assets/assets/images/items/trashClassification_0022/images-23.jpg": "0ceee0cec0cd8b4af8b1c97b0e216fdd",
"assets/assets/images/items/trashClassification_0022/images-22.jpg": "7ed88e3d7916dd7415917be219061930",
"assets/assets/images/items/trashClassification_0022/images-3.jpg": "509a62f12ca6b99eb61bdde43b832559",
"assets/assets/images/items/trashClassification_0022/images-13.jpg": "53f2633a33c535fe5882ff12316ea4ba",
"assets/assets/images/items/trashClassification_0022/images-12.jpg": "3c02ad3b74506fdcd04e3567b41d1759",
"assets/assets/images/items/trashClassification_0022/images-10.jpg": "eb8533a15d789fd5d13f6a16861d4408",
"assets/assets/images/items/trashClassification_0022/images-11.jpg": "4f6edf5d7eebfc3a550553dfa1ec362c",
"assets/assets/images/items/trashClassification_0022/images-8.jpg": "b945bc2a8b9d53b627582b32c524c33f",
"assets/assets/images/items/trashClassification_0022/images-15.jpg": "c1bb31cb1a525ee53ead9d25a06125c0",
"assets/assets/images/items/trashClassification_0022/images-14.jpg": "487bc90f9c98c29b7cbe09ef89bdbdd4",
"assets/assets/images/items/trashClassification_0022/images-9.jpg": "29d3106a8ac86b2164477b5512d196dd",
"assets/assets/images/items/trashClassification_0022/images-16.jpg": "5245a147c244cfca9312f42e2f9e0acf",
"assets/assets/images/items/trashClassification_0022/images-17.jpg": "1c4e0e558f26c3ab6ff541e942a6afa1",
"assets/assets/images/items/trashClassification_0031/images-7.jpg": "edf02efee837f13a9b614f7d38ab38cc",
"assets/assets/images/items/trashClassification_0031/images-6.jpg": "f0ee22d60be1212c6e6dbf85ca79fa9a",
"assets/assets/images/items/trashClassification_0031/images-4.jpg": "0614fa85c130c02d522e32e49c0a0afe",
"assets/assets/images/items/trashClassification_0031/images-5.jpg": "a9ecb026c50ca874cbe5913131c14072",
"assets/assets/images/items/trashClassification_0031/images-1.jpg": "a99c6654526773ebec1af22081ddb6e8",
"assets/assets/images/items/trashClassification_0031/images-0.jpg": "276376ab077adf3738e6930066090357",
"assets/assets/images/items/trashClassification_0031/images-2.jpg": "9dceaf70feac15d0c872254e7d83a07c",
"assets/assets/images/items/trashClassification_0031/images-3.jpg": "d050b388f8f083f889d4e8e4f01d8903",
"assets/assets/images/items/trashClassification_0031/images-8.jpg": "4eceb1d3cf833bd153581a538aaf2553",
"assets/assets/images/items/trashClassification_0031/images-9.jpg": "3154872e9ec8b297edc2cb71568626ee",
"assets/assets/images/items/trashClassification_0062/images-7.jpg": "9c5fe596687ad5a653c8ba8412f8556b",
"assets/assets/images/items/trashClassification_0062/images-6.jpg": "6fb3fd8737318fa6c46306234ec5880b",
"assets/assets/images/items/trashClassification_0062/images-4.jpg": "6de204e0bf86788082ed1252371e1424",
"assets/assets/images/items/trashClassification_0062/images-5.jpg": "8d1cf529fb9ba391f907c35201abdd99",
"assets/assets/images/items/trashClassification_0062/images-1.jpg": "cdcef61afe12082eeb132ca49c933883",
"assets/assets/images/items/trashClassification_0062/images-0.jpg": "c29875dc8c114d2635d928e127cbeddc",
"assets/assets/images/items/trashClassification_0062/images-2.jpg": "b9d4262a1f093735a168203e3a700a7f",
"assets/assets/images/items/trashClassification_0062/images-3.jpg": "ba5f5a42077a4e3d3a315352195cc06e",
"assets/assets/images/items/trashClassification_0062/images-12.jpg": "265455f3ffa00afba9b46de4bd495052",
"assets/assets/images/items/trashClassification_0062/images-10.jpg": "b14481b4de66b85ae82d5bc77c29d1aa",
"assets/assets/images/items/trashClassification_0062/images-11.jpg": "9b244366cd21973e042bdf295009931c",
"assets/assets/images/items/trashClassification_0062/images-8.jpg": "0560b41438f36dc89e98d7b40a183a8d",
"assets/assets/images/items/trashClassification_0062/images-9.jpg": "8da5b388b8e93c9a34d89d14859b719c",
"assets/assets/images/items/trashClassification_0064/images-1.jpg": "24ccde1d21dfd698e922b11062018ff4",
"assets/assets/images/items/trashClassification_0064/images-0.jpg": "9b55abc1f87e03686684f3030f830cfd",
"assets/assets/images/items/trashClassification_0064/images-2.jpg": "81f1bb90264f18d1bf527bbe6f2dc4f5",
"assets/assets/images/items/trashClassification_0063/images-4.jpg": "54d94fa6c7f2e66f6a5326f74accba1b",
"assets/assets/images/items/trashClassification_0063/images-5.jpg": "2c5ed0b77b8344bc30cc443c6362e058",
"assets/assets/images/items/trashClassification_0063/images-1.jpg": "fb1db795d55d1f7700400cd695b4527a",
"assets/assets/images/items/trashClassification_0063/images-0.jpg": "570f0a5b44a40e0a66e492a07ee2e52d",
"assets/assets/images/items/trashClassification_0063/images-2.jpg": "6241cd9643ba55a92a48f5de68652a0e",
"assets/assets/images/items/trashClassification_0063/images-3.jpg": "6e769719ae4b9d05e1a82383b18daba7",
"assets/assets/images/items/trashClassification_0011/images-43.jpg": "fb4cb6e118167f5700172ec31cbc5042",
"assets/assets/images/items/trashClassification_0011/images-42.jpg": "39dfe2608909e1cb076a01427e58e4f9",
"assets/assets/images/items/trashClassification_0011/images-40.jpg": "de63dc798779c87f99e1f8c428ff8781",
"assets/assets/images/items/trashClassification_0011/images-41.jpg": "3b9c947f497bc99988035518d593b892",
"assets/assets/images/items/trashClassification_0011/images-7.jpg": "1678b90ca19cdc5674178625eca333d4",
"assets/assets/images/items/trashClassification_0011/images-32.jpg": "b94f11cd1d1330bc2efc4005e03d9376",
"assets/assets/images/items/trashClassification_0011/images-26.jpg": "20aad4f2eaaf812baa76ee6dc00aad13",
"assets/assets/images/items/trashClassification_0011/images-27.jpg": "73896304092ba80524a3b72895e794ae",
"assets/assets/images/items/trashClassification_0011/images-33.jpg": "062dc36cf8d61bae00c158c66bc47e22",
"assets/assets/images/items/trashClassification_0011/images-6.jpg": "8f56c7a6797cc61b97148ceb3f1fff46",
"assets/assets/images/items/trashClassification_0011/images-4.jpg": "184ae057ac8d7cbd735578df21ac97f9",
"assets/assets/images/items/trashClassification_0011/images-19.jpg": "24ccde1d21dfd698e922b11062018ff4",
"assets/assets/images/items/trashClassification_0011/images-25.jpg": "060e9b1a1cc2af59ca151784ae506765",
"assets/assets/images/items/trashClassification_0011/images-31.jpg": "e416c96c980e0df831e5718472e0227b",
"assets/assets/images/items/trashClassification_0011/images-30.jpg": "56baf3e83818314238dd0d2e941ff7cc",
"assets/assets/images/items/trashClassification_0011/images-24.jpg": "578d1cf5f529137032f5dd205bce27b6",
"assets/assets/images/items/trashClassification_0011/images-18.jpg": "bcdae3e5a6c582bf8ac0d3235bdbe2c8",
"assets/assets/images/items/trashClassification_0011/images-5.jpg": "fcdcfcd1908d6daa9c3de9c2994681e9",
"assets/assets/images/items/trashClassification_0011/images-1.jpg": "ada1cef27da6a224f5e229205d717ebe",
"assets/assets/images/items/trashClassification_0011/images-20.jpg": "654e24a9d904c4dcddca1bf7a9e6c825",
"assets/assets/images/items/trashClassification_0011/images-34.jpg": "0721a993a420805689432bc13657e725",
"assets/assets/images/items/trashClassification_0011/images-35.jpg": "5146da29208614ca60edd50d54e21a6f",
"assets/assets/images/items/trashClassification_0011/images-21.jpg": "3ebe1c82138565f82c038d1fc1803ac7",
"assets/assets/images/items/trashClassification_0011/images-0.jpg": "09842b6347226f4a4dc66fdb58484b13",
"assets/assets/images/items/trashClassification_0011/images-2.jpg": "c75e6e6aacb0b7ecee789dfeeeca75f2",
"assets/assets/images/items/trashClassification_0011/images-37.jpg": "7011c2d98dc76ab45170cd5544737433",
"assets/assets/images/items/trashClassification_0011/images-23.jpg": "5071422279aa70f4b88496bfb969a570",
"assets/assets/images/items/trashClassification_0011/images-22.jpg": "163a809e47cbf9e840e2ee7cf35a5f6d",
"assets/assets/images/items/trashClassification_0011/images-36.jpg": "556c4f6c22700d176b0dab6f1cc6839f",
"assets/assets/images/items/trashClassification_0011/images-3.jpg": "6defd274a5bc57042337f4c34a6f7416",
"assets/assets/images/items/trashClassification_0011/images-13.jpg": "456ec3313539cdc539e6101a477becfb",
"assets/assets/images/items/trashClassification_0011/images-12.jpg": "19be7192756d4f9de7d0fd0afe0fd99a",
"assets/assets/images/items/trashClassification_0011/images-38.jpg": "4be0c3eb22e9eec4edfb7afbf1ef3ca0",
"assets/assets/images/items/trashClassification_0011/images-10.jpg": "0614fa85c130c02d522e32e49c0a0afe",
"assets/assets/images/items/trashClassification_0011/images-11.jpg": "7558ac9e59540896103fe6ee588e0891",
"assets/assets/images/items/trashClassification_0011/images-39.jpg": "f1405665d21f35e2881a64c14d23cec9",
"assets/assets/images/items/trashClassification_0011/images-8.jpg": "51c6655b2bba5ff467e2a7e230f3c343",
"assets/assets/images/items/trashClassification_0011/images-15.jpg": "11f91a55251bd6a62cb3a4981f038db2",
"assets/assets/images/items/trashClassification_0011/images-29.jpg": "684c2cbcdca4e85241e2391cff284ba9",
"assets/assets/images/items/trashClassification_0011/images-28.jpg": "24d4e3f07d0f655bd0446112ee4bd5c4",
"assets/assets/images/items/trashClassification_0011/images-14.jpg": "94efa1ca9bb5eb8b902512f46d31ed96",
"assets/assets/images/items/trashClassification_0011/images-9.jpg": "9dceaf70feac15d0c872254e7d83a07c",
"assets/assets/images/items/trashClassification_0011/images-16.jpg": "8a9ed842f7ba573aca80e48e3c3e5735",
"assets/assets/images/items/trashClassification_0011/images-17.jpg": "0b43a4f9ffe4ecd4406cb22d6b3865c9",
"assets/assets/images/items/recyclable/images-7.jpg": "1678b90ca19cdc5674178625eca333d4",
"assets/assets/images/items/recyclable/images-6.jpg": "8f56c7a6797cc61b97148ceb3f1fff46",
"assets/assets/images/items/recyclable/images-4.jpg": "184ae057ac8d7cbd735578df21ac97f9",
"assets/assets/images/items/recyclable/images-19.jpg": "24ccde1d21dfd698e922b11062018ff4",
"assets/assets/images/items/recyclable/images-5.jpg": "fcdcfcd1908d6daa9c3de9c2994681e9",
"assets/assets/images/items/recyclable/images-1.jpg": "ada1cef27da6a224f5e229205d717ebe",
"assets/assets/images/items/recyclable/images-0.jpg": "09842b6347226f4a4dc66fdb58484b13",
"assets/assets/images/items/recyclable/images-2.jpg": "c75e6e6aacb0b7ecee789dfeeeca75f2",
"assets/assets/images/items/recyclable/images-3.jpg": "6defd274a5bc57042337f4c34a6f7416",
"assets/assets/images/items/recyclable/images-13.jpg": "456ec3313539cdc539e6101a477becfb",
"assets/assets/images/items/recyclable/images-12.jpg": "19be7192756d4f9de7d0fd0afe0fd99a",
"assets/assets/images/items/recyclable/images-10.jpg": "0614fa85c130c02d522e32e49c0a0afe",
"assets/assets/images/items/recyclable/images-11.jpg": "7558ac9e59540896103fe6ee588e0891",
"assets/assets/images/items/recyclable/images-8.jpg": "51c6655b2bba5ff467e2a7e230f3c343",
"assets/assets/images/items/recyclable/images-15.jpg": "11f91a55251bd6a62cb3a4981f038db2",
"assets/assets/images/items/recyclable/images-14.jpg": "94efa1ca9bb5eb8b902512f46d31ed96",
"assets/assets/images/items/recyclable/images-9.jpg": "9dceaf70feac15d0c872254e7d83a07c",
"assets/assets/images/items/recyclable/images-16.jpg": "8a9ed842f7ba573aca80e48e3c3e5735",
"assets/assets/images/items/recyclable/images-17.jpg": "0b43a4f9ffe4ecd4406cb22d6b3865c9",
"assets/assets/images/items/trashClassification_0042/images-1.jpg": "eaf77c9b0e8e5d037c159a4269305ffe",
"assets/assets/images/items/trashClassification_0042/images-0.jpg": "eee2a50470b9397c1c8d5d9589714ffd",
"assets/assets/images/items/trashClassification_0010/images-7.jpg": "7dcf92e4def12355afdfdcdd44632ed4",
"assets/assets/images/items/trashClassification_0010/images-26.jpg": "3d4d00363755f31adeb9b7d39946b283",
"assets/assets/images/items/trashClassification_0010/images-27.jpg": "9969d7380ffa5c4dde645d90188574e4",
"assets/assets/images/items/trashClassification_0010/images-6.jpg": "82f4c6670acb03983285db3879240043",
"assets/assets/images/items/trashClassification_0010/images-4.jpg": "174d8cf4de6250f456bce185834e1ad1",
"assets/assets/images/items/trashClassification_0010/images-19.jpg": "a44db1a9bb6bd3109b6ec9ecf3715287",
"assets/assets/images/items/trashClassification_0010/images-25.jpg": "d157c5b5097ba81b3f63fc63ed854990",
"assets/assets/images/items/trashClassification_0010/images-24.jpg": "97dea5b6c41849584b2c26865a4bfe66",
"assets/assets/images/items/trashClassification_0010/images-18.jpg": "0200058cd51e7ee46a4ad9f1bf56ad96",
"assets/assets/images/items/trashClassification_0010/images-5.jpg": "6a558f05d56d743b1657743d65561e70",
"assets/assets/images/items/trashClassification_0010/images-1.jpg": "774015f6186df5a0cb9cab6182e3c0d7",
"assets/assets/images/items/trashClassification_0010/images-20.jpg": "6620115bb3ac2dd928d39432f637b5f0",
"assets/assets/images/items/trashClassification_0010/images-21.jpg": "9dbddd25d09d788723d5f90dd26f6bbf",
"assets/assets/images/items/trashClassification_0010/images-0.jpg": "ec75d6bc66b6f35e865bc7dfae50acb7",
"assets/assets/images/items/trashClassification_0010/images-2.jpg": "5cc732dc7c6e9de1d5b23313d42c5645",
"assets/assets/images/items/trashClassification_0010/images-23.jpg": "eb38309488c01355cf6beeeec9d00dae",
"assets/assets/images/items/trashClassification_0010/images-22.jpg": "07362f59da387fb9d35949ad395b4542",
"assets/assets/images/items/trashClassification_0010/images-3.jpg": "07b5c15804405148003a9449b4c9b384",
"assets/assets/images/items/trashClassification_0010/images-13.jpg": "efa34acec75fa6adf2a1db717722a743",
"assets/assets/images/items/trashClassification_0010/images-12.jpg": "d48452fabc8f50f886cafa0eb2b16dda",
"assets/assets/images/items/trashClassification_0010/images-10.jpg": "4f6eceee2ef97ef7fe154011fe7354ae",
"assets/assets/images/items/trashClassification_0010/images-11.jpg": "c14cdc5ed06d3070468fcf6791fe5e9c",
"assets/assets/images/items/trashClassification_0010/images-8.jpg": "c0aacbc8b908e4e8eac923ac2bfe043c",
"assets/assets/images/items/trashClassification_0010/images-15.jpg": "7e4161e518c3ae69581a6cc47f27aa48",
"assets/assets/images/items/trashClassification_0010/images-28.jpg": "5ab1a342affbaabd4036bf27939b1a8f",
"assets/assets/images/items/trashClassification_0010/images-14.jpg": "0c6786d1a2e4b1e9755c79b847b62148",
"assets/assets/images/items/trashClassification_0010/images-9.jpg": "8ac60780f72d42728fc00bb48b7bfac5",
"assets/assets/images/items/trashClassification_0010/images-16.jpg": "a3417b9dda344d64f85e1a139baad611",
"assets/assets/images/items/trashClassification_0010/images-17.jpg": "921f0b7279f494ed8c4191c32592447e",
"assets/assets/images/items/trashClassification_0021/images-7.jpg": "1eaf5d390476dbe3308f2622b9bc8d51",
"assets/assets/images/items/trashClassification_0021/images-6.jpg": "563842ebfe309f72784372cc53712749",
"assets/assets/images/items/trashClassification_0021/images-4.jpg": "e87003677bfa0241bc1fbc1cef0263c1",
"assets/assets/images/items/trashClassification_0021/images-19.jpg": "e4278ff330a013fc6b98f2de07990a72",
"assets/assets/images/items/trashClassification_0021/images-25.jpg": "490791be89977b8d3853590efc1d5e85",
"assets/assets/images/items/trashClassification_0021/images-24.jpg": "f4386a0df94732e7c1312bfd041fa3da",
"assets/assets/images/items/trashClassification_0021/images-18.jpg": "dc787632cd46ab27841553511122a36f",
"assets/assets/images/items/trashClassification_0021/images-5.jpg": "d6fd6fd83a914ae889f3be582c12a77e",
"assets/assets/images/items/trashClassification_0021/images-1.jpg": "4a7d5ccf204170382ffc426d3c7eda04",
"assets/assets/images/items/trashClassification_0021/images-20.jpg": "c7c4c5fe8ec4098d8e23642080d7c349",
"assets/assets/images/items/trashClassification_0021/images-21.jpg": "9e1898a697af4c8e5c3b56a02082de6b",
"assets/assets/images/items/trashClassification_0021/images-0.jpg": "1903665b797371e6b12ea3f815111769",
"assets/assets/images/items/trashClassification_0021/images-2.jpg": "bf7e8cd68ec85a1e5114cdce5334844e",
"assets/assets/images/items/trashClassification_0021/images-23.jpg": "f3ec1069ee8af207d5e41f45b55680aa",
"assets/assets/images/items/trashClassification_0021/images-22.jpg": "67e47bd1318242bfa3c947d61391a6d5",
"assets/assets/images/items/trashClassification_0021/images-3.jpg": "5719d73e3a5d3c8fb6dddbb1f2da43d2",
"assets/assets/images/items/trashClassification_0021/images-13.jpg": "bcae6ee64431f5e12f277ef909b61374",
"assets/assets/images/items/trashClassification_0021/images-12.jpg": "3a85e8b0737864bae28c7301ca8c966d",
"assets/assets/images/items/trashClassification_0021/images-10.jpg": "bc1352bf876025a85411e72570c6cca6",
"assets/assets/images/items/trashClassification_0021/images-11.jpg": "2182ede1a08617acd898aa4b4a9d3a39",
"assets/assets/images/items/trashClassification_0021/images-8.jpg": "0e3f4c0b425b64b7b2eb0cf4d1e5820c",
"assets/assets/images/items/trashClassification_0021/images-15.jpg": "65ab280701daba6cce06e6b42bfc7c67",
"assets/assets/images/items/trashClassification_0021/images-14.jpg": "d8ad0489041a62fa0347c1b15cdbf894",
"assets/assets/images/items/trashClassification_0021/images-9.jpg": "830b54db6dd9a652a89bf02cecb89ac4",
"assets/assets/images/items/trashClassification_0021/images-16.jpg": "f0b644e8d1f7d9b95b5b2094cc97ca30",
"assets/assets/images/items/trashClassification_0021/images-17.jpg": "e8d66c02243655a8fe5c331c32a9dbc1",
"assets/assets/images/items/trashClassification_0043/images-1.jpg": "ca0287c3b73dfe6623e76a701fed24a7",
"assets/assets/images/items/trashClassification_0043/images-0.jpg": "4d566f9d4af94c1b3be6e2ac8d0166de",
"assets/assets/images/items/trashClassification_0061/images-7.jpg": "f346056ac73272b27726885613b09557",
"assets/assets/images/items/trashClassification_0061/images-6.jpg": "11f91a55251bd6a62cb3a4981f038db2",
"assets/assets/images/items/trashClassification_0061/images-4.jpg": "e416c96c980e0df831e5718472e0227b",
"assets/assets/images/items/trashClassification_0061/images-5.jpg": "84cf1e6a5f6d7456a96c96b5a9885250",
"assets/assets/images/items/trashClassification_0061/images-1.jpg": "47f632146378935fd5936a51c24e6fbf",
"assets/assets/images/items/trashClassification_0061/images-0.jpg": "d5a53d38fd055602cb839bcc87596691",
"assets/assets/images/items/trashClassification_0061/images-2.jpg": "408dd7f4e039983dc9eebf7ea57c8f2f",
"assets/assets/images/items/trashClassification_0061/images-3.jpg": "cec54fe5e0d6ef3c5b931a16965d101b",
"assets/assets/images/items/trashClassification_0061/images-12.jpg": "d0e725cb308a1fecfdc8e5d4688ffe4a",
"assets/assets/images/items/trashClassification_0061/images-10.jpg": "c31f130a2bb5741feaebcec6d3e705c0",
"assets/assets/images/items/trashClassification_0061/images-11.jpg": "af6ec19cafd5444984680aa92b8d4d73",
"assets/assets/images/items/trashClassification_0061/images-8.jpg": "dd821db9794386b70e47840fef3e3fe0",
"assets/assets/images/items/trashClassification_0061/images-9.jpg": "b9773eb96e1f4e2de9b389faef92c016",
"assets/assets/images/items/trashClassification_0050/images-7.jpg": "df756bda8786967de75ae42edf751283",
"assets/assets/images/items/trashClassification_0050/images-6.jpg": "8ab0ba547b9566730fe979059b7de436",
"assets/assets/images/items/trashClassification_0050/images-4.jpg": "9c069ae823d06a97211ec25eaec6a14c",
"assets/assets/images/items/trashClassification_0050/images-5.jpg": "4b37be98f58ddc3f23ce134fe73b19c0",
"assets/assets/images/items/trashClassification_0050/images-1.jpg": "f4e428740e5fd779a7366cb89623c99d",
"assets/assets/images/items/trashClassification_0050/images-0.jpg": "fc4ad00808e0a132968c042f418ec49a",
"assets/assets/images/items/trashClassification_0050/images-2.jpg": "f94f6df4346e30ab9ae558c5dcebe900",
"assets/assets/images/items/trashClassification_0050/images-3.jpg": "3e364c9c8ffdd9bd1713051ab751d11a",
"assets/assets/images/items/trashClassification_0050/images-12.jpg": "c072b2cb5833f05f10e683ed200a53f3",
"assets/assets/images/items/trashClassification_0050/images-10.jpg": "980e40ac774d1071d3ebe446597af5f7",
"assets/assets/images/items/trashClassification_0050/images-11.jpg": "80e076b156afcb141613eaf94566ca57",
"assets/assets/images/items/trashClassification_0050/images-8.jpg": "adf5387c2b32e3f7e4aa85520c28b386",
"assets/assets/images/items/trashClassification_0050/images-9.jpg": "09dae7b609f0e3451c8f2c96741faa24",
"assets/assets/images/items/trashClassification_0032/images-4.jpg": "ada1cef27da6a224f5e229205d717ebe",
"assets/assets/images/items/trashClassification_0032/images-1.jpg": "fb4cb6e118167f5700172ec31cbc5042",
"assets/assets/images/items/trashClassification_0032/images-0.jpg": "ce0837b8fc7b1a4c54a1d93d2b4140e7",
"assets/assets/images/items/trashClassification_0032/images-2.jpg": "de48ceaef1e2126be9adbdc5e9d89fec",
"assets/assets/images/items/trashClassification_0032/images-3.jpg": "6ba5cd628a066fad9ac7c2b14ac5a878",
"assets/assets/images/items/trashClassification_0033/images-1.jpg": "ff8d9ccd9f1395b60e3e92384d070c6f",
"assets/assets/images/items/trashClassification_0033/images-0.jpg": "a8f88723694a6c6b599455f69b3e9d0c",
"assets/assets/images/items/trashClassification_0033/images-2.jpg": "33ca7fa7c2136ec3853a6a473f5d04a1",
"assets/assets/images/2x/settings.png": "8404e18c68ba99ca0b181bd96ace0376",
"assets/assets/images/2x/restart.png": "83aea4677055df9b0d8171f5315f2a60",
"assets/assets/images/2x/back.png": "85cda8f41a13153d6f3fb1c403f272ea",
"assets/assets/images/back.png": "3c82301693d5c4140786184a06c23f7e",
"assets/assets/images/3.5x/settings.png": "c977a1e6c59e8cfd5cd88a0c973928fc",
"assets/assets/images/3.5x/restart.png": "583169ac365d9515fc12f29e3b530de0",
"assets/assets/images/3.5x/back.png": "85db134e26410547037485447f659277",
"assets/assets/sfx/kss1.mp3": "fd0664b62bb9205c1ba6868d2d185897",
"assets/assets/sfx/spsh1.mp3": "2e1354f39a5988afabb2fdd27cba63e1",
"assets/assets/sfx/fwfwfwfw1.mp3": "d0f7ee0256d1f0d40d77a1264f23342b",
"assets/assets/sfx/fwfwfwfwfw1.mp3": "46355605b43594b67a39170f89141dc1",
"assets/assets/sfx/sh1.mp3": "f695db540ae0ea850ecbb341a825a47b",
"assets/assets/sfx/hh1.mp3": "fab21158730b078ce90568ce2055db07",
"assets/assets/sfx/p1.mp3": "ad28c0d29ac9e8adf9a91a46bfbfac82",
"assets/assets/sfx/sh2.mp3": "e3212b9a7d1456ecda26fdc263ddd3d0",
"assets/assets/sfx/hh2.mp3": "4d39e7365b89c74db536c32dfe35580b",
"assets/assets/sfx/kch1.mp3": "a832ed0c8798b4ec95c929a5b0cabd3f",
"assets/assets/sfx/oo1.mp3": "94b9149911d0f2de8f3880c524b93683",
"assets/assets/sfx/lalala1.mp3": "b0b85bf59814b014ff48d6d79275ecfd",
"assets/assets/sfx/p2.mp3": "ab829255f1ef20fbd4340a7c9e5157ad",
"assets/assets/sfx/hash3.mp3": "38aad045fbbf951bf5e4ca882b56245e",
"assets/assets/sfx/hash2.mp3": "d26cb7676c3c0d13a78799b3ccac4103",
"assets/assets/sfx/wssh1.mp3": "cf92e8d8483097569e3278c82ac9f871",
"assets/assets/sfx/dsht1.mp3": "c99ece72f0957a9eaf52ade494465946",
"assets/assets/sfx/hash1.mp3": "f444469cd7a5a27062580ecd2b481770",
"assets/assets/sfx/wssh2.mp3": "255c455d9692c697400696cbb28511cc",
"assets/assets/sfx/README.md": "33033a0943d1325f78116fcf4b8a96ec",
"assets/assets/sfx/yay1.mp3": "8d3b940e33ccfec612d06a41ae616f71",
"assets/assets/sfx/k2.mp3": "8ec44723c33a1e41f9a96d6bbecde6b9",
"assets/assets/sfx/k1.mp3": "37ffb6f8c0435298b0a02e4e302e5b1f",
"assets/assets/sfx/haw1.mp3": "00db66b69283acb63a887136dfe7a73c",
"assets/assets/sfx/ehehee1.mp3": "52f5042736fa3f4d4198b97fe50ce7f3",
"assets/assets/sfx/ws1.mp3": "5cfa8fda1ee940e65a19391ddef4d477",
"assets/assets/sfx/wehee1.mp3": "5a986231104c9f084104e5ee1c564bc4",
"assets/assets/sfx/swishswish1.mp3": "219b0f5c2deec2eda0a9e0e941894cb6",
"assets/assets/fonts/Permanent_Marker/PermanentMarker-Regular.ttf": "c863f8028c2505f92540e0ba7c379002",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
