'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "0cdd9d549ffa4f0c870dfe659be30793",
"index.html": "40aa258b7f80ce18047e7d8ec9387873",
"/": "40aa258b7f80ce18047e7d8ec9387873",
"main.dart.js": "e13571e4a0bd4a70b4f2b88d4116f8b9",
"favicon.png": "417b4caf3b33f72918b4ea4282747322",
"icons/Icon-192.png": "21f6824f5287328daf86fae16694dc01",
"icons/Icon-512.png": "5a60d8d794d20b6f3edb0e73a080075f",
"manifest.json": "50ed41dd2bcaac7ad29a21a743e174fd",
"assets/AssetManifest.json": "de45e041507005bd828bca2bef816a15",
"assets/NOTICES": "da042a1ac79ca3f38fa7760918f8af4a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/assets/images/icon.png": "182e8eaf8aff3d6b8fc2205201f0a605",
"assets/assets/images/mine_contact.png": "d5e5505df5fa696561c436fced72aa0f",
"assets/assets/images/mine_address.png": "bac388f395d6471f1c51466a1ee3bd34",
"assets/assets/images/cart_check.png": "557f202c0b8e84213d1770747a9fe5ad",
"assets/assets/images/tab_cart.png": "46d66f5d0e9c0bb8fda8f872d80f76d1",
"assets/assets/images/2.0x/mine_contact.png": "ad09e0eb1f7b4932645f92f1b309e7f2",
"assets/assets/images/2.0x/mine_address.png": "f640eb1327a7e2825638959424779c30",
"assets/assets/images/2.0x/cart_check.png": "aab143cb4057ce91630a398cf7fc243f",
"assets/assets/images/2.0x/tab_cart.png": "c7f268ae89bfd13a5bf55004b788c9d8",
"assets/assets/images/2.0x/tab_mine.png": "f6593796776b7a171f1da08249a805fc",
"assets/assets/images/2.0x/tab_mine_active.png": "c7e4d6b66952b804eb0b7d62a1566d86",
"assets/assets/images/2.0x/home_brand_list.png": "24bb3f6ca07c45df7a9792520662fb71",
"assets/assets/images/2.0x/home_brand_grid.png": "317b8c827661d0af570998648f80034b",
"assets/assets/images/2.0x/image_placeholder.png": "68bcb530f9c49f49834a148e742bfc24",
"assets/assets/images/2.0x/tab_home.png": "7e066ed05fd25f42d4ffc39babb27630",
"assets/assets/images/2.0x/home_action_notice.png": "2687da0fdf666a0f291fb86530e9f86e",
"assets/assets/images/2.0x/empty_address.png": "dfd33645012e489cf93000e00a1d0442",
"assets/assets/images/2.0x/tab_cart_active.png": "05f6db7fd1b112c3f79f07a5224fc673",
"assets/assets/images/2.0x/mine_setting.png": "bc57ab1155224ab2391087d306d02145",
"assets/assets/images/2.0x/home_search.png": "6f890bdd025d3b939cb7b47a0ed4ea9a",
"assets/assets/images/2.0x/tab_category.png": "58e06c9aaaeec3dce1ac0078f45012a9",
"assets/assets/images/2.0x/mine_feedback.png": "6ac9b6f246274ee365214026d7f618c5",
"assets/assets/images/2.0x/empty_shopping_cart.png": "bef0cdfe7b42f4f344e9258a1949782a",
"assets/assets/images/2.0x/home_action_mine.png": "0242dccd5ab8777226f5aa836ddf93e3",
"assets/assets/images/2.0x/home_pure_logo.png": "eb14181d4e44191cfb2b1d3cc8ecbc05",
"assets/assets/images/2.0x/home_action_cart.png": "62ed5804d7fed2d575098823cab47974",
"assets/assets/images/2.0x/home_logo.png": "19eeb194eb80094e169eabac24254059",
"assets/assets/images/2.0x/mine_order_message.png": "1e156c56cdfc843acd0907800c9e7aae",
"assets/assets/images/2.0x/mine_order.png": "c825fd33cebe625660cfa6496266dbf9",
"assets/assets/images/2.0x/cart_check_active.png": "c30f9e235ee80c91dce5de6579e94388",
"assets/assets/images/2.0x/empty_order.png": "6e805c6bf6da09d1f1356fe663901667",
"assets/assets/images/2.0x/product_brand_icon.png": "7fa06fa551b1c40aa0d8bdabb6e19e6a",
"assets/assets/images/2.0x/tab_category_active.png": "24e23e5cbee41b6e6c455b3af33b792e",
"assets/assets/images/2.0x/tab_home_active.png": "d849bccfffe7c8ec8152b1e76eaabdde",
"assets/assets/images/tab_mine.png": "510606979c2d3661b2ea3732eadf189f",
"assets/assets/images/tab_mine_active.png": "615a0fe0d0e99de4fc060f3af21cba4c",
"assets/assets/images/home_brand_list.png": "89cb042c558a6f0b6641ae602aec1aaa",
"assets/assets/images/home_brand_grid.png": "df312d4ed86a9820ca8ad9ba4cc541ef",
"assets/assets/images/image_placeholder.png": "8503734378bd25a06edbf91f7d83cedf",
"assets/assets/images/tab_home.png": "05a3d489e599e97c861c684927b26ac9",
"assets/assets/images/home_action_notice.png": "7410e0ff5a3f902817b2542eeab7d7be",
"assets/assets/images/3.0x/mine_contact.png": "c4b5de57e84bb3607f91a86ff52190d7",
"assets/assets/images/3.0x/mine_address.png": "7466d1264137704deaaeb56d08f4d7b5",
"assets/assets/images/3.0x/cart_check.png": "7769f35b9b9ce7ba308d59a79c0b4fb9",
"assets/assets/images/3.0x/tab_cart.png": "0943804a225db44778bb850e8a67928f",
"assets/assets/images/3.0x/tab_mine.png": "573baaae20ebfc071b053f2d9ab8b71a",
"assets/assets/images/3.0x/tab_mine_active.png": "4ad512dd4b535a8a48f5d4222f0977a0",
"assets/assets/images/3.0x/home_brand_list.png": "a10b81ec5a62f8e3ae7cca18721f0459",
"assets/assets/images/3.0x/home_brand_grid.png": "65ccc92e7dd27d234c8c35c3ace225e7",
"assets/assets/images/3.0x/image_placeholder.png": "f0d05acef5810086b545fe80793ffc7e",
"assets/assets/images/3.0x/tab_home.png": "a721182aef67d1e1377adb412e1746fe",
"assets/assets/images/3.0x/home_action_notice.png": "ff79a3fe6e1d6c9e806e7889f156b259",
"assets/assets/images/3.0x/empty_address.png": "d00434bbb5cb5ecfec0899630c19feac",
"assets/assets/images/3.0x/tab_cart_active.png": "9f0f0658c2fc9b0e2a7e2842407c9f90",
"assets/assets/images/3.0x/mine_setting.png": "1909b474241a7837e328cc57a18be60e",
"assets/assets/images/3.0x/home_search.png": "ae6f24a613a7ce62bb6a0601c1409e05",
"assets/assets/images/3.0x/tab_category.png": "911ffa5d9f1f7144c4f221ea725967be",
"assets/assets/images/3.0x/mine_feedback.png": "3f6c1a10322486bcca761b4fb2cf7a66",
"assets/assets/images/3.0x/empty_shopping_cart.png": "fd64e9a82e6f20524de36efb8126c49b",
"assets/assets/images/3.0x/home_action_mine.png": "31582d2a5cb9deb3f17ea0febc5dacd1",
"assets/assets/images/3.0x/home_pure_logo.png": "6b1e9635d3d4277a2bbde2255f696118",
"assets/assets/images/3.0x/home_action_cart.png": "12fe2ea8417d8ed9c591ae3546f2b6f0",
"assets/assets/images/3.0x/home_logo.png": "b6f36e5c7a101c5fb6c3590e0bcba5e7",
"assets/assets/images/3.0x/mine_order_message.png": "6a596965f047ef2f7fca6848666add39",
"assets/assets/images/3.0x/mine_order.png": "101d842196f582cc326cf3b7cf0a2085",
"assets/assets/images/3.0x/cart_check_active.png": "d3dbd5245fdbc1fda020798f448c3524",
"assets/assets/images/3.0x/empty_order.png": "87d07459f23c94079ad1baad4b7f88a3",
"assets/assets/images/3.0x/product_brand_icon.png": "3bba3c1fa9b635c1b4eecfa5c2123fe1",
"assets/assets/images/3.0x/tab_category_active.png": "69931ce78c6818852c5e095a48e0c9af",
"assets/assets/images/3.0x/tab_home_active.png": "332abb74ade85c1ce9cef5e6d7b4bb5a",
"assets/assets/images/empty_address.png": "5ecf77742e04f95dba620316991ec10f",
"assets/assets/images/tab_cart_active.png": "74dc9e20253c0988fbef5da710119ea4",
"assets/assets/images/mine_setting.png": "f741e5be7d30bc68ce3127e28771b502",
"assets/assets/images/no_image_placeholder.jpg": "50cffadd3860c08c1922a661c3c8eae4",
"assets/assets/images/home_search.png": "5d755de9ee67a5c8b2fa3946cab20c32",
"assets/assets/images/tab_category.png": "47413b2be366cb0b780579e51626b6c6",
"assets/assets/images/payment_balance.png": "51a02d2d709256976e6a9a0829930d9e",
"assets/assets/images/mine_feedback.png": "eccd42843467982cbac54026862894a3",
"assets/assets/images/empty_shopping_cart.png": "bc0a1f904118f2d7465797023ec0fd37",
"assets/assets/images/home_action_mine.png": "edf2a02e5121771c25508216b69947f4",
"assets/assets/images/un_login_user_avater.png": "1e976c46d0c8de419b7645c0a1835d7c",
"assets/assets/images/home_pure_logo.png": "c0b3d2e0c9062cb6273f2b0c1a4b2e66",
"assets/assets/images/home_action_cart.png": "d1efe97f6cd9f50ee9aad83e5ffcbc67",
"assets/assets/images/home_logo.png": "07170d2fe43844a5133b4b7c19564675",
"assets/assets/images/notice_example_image.jpeg": "f5a5893e4c2822c7904fa53ee6fd7846",
"assets/assets/images/mine_order_message.png": "5f9b8dfa0048416b397d4d36c80dd454",
"assets/assets/images/mine_order.png": "f4ff9aed715a2626017ff5afcf77d44b",
"assets/assets/images/cart_check_active.png": "da4b18d842b7ad53d4013d3709c23a3a",
"assets/assets/images/empty_order.png": "e32771dda870cc6e027e672046bb4b49",
"assets/assets/images/product_brand_icon.png": "070faac97ee9b96e8e3b39a4d10b884b",
"assets/assets/images/payment_alipay.png": "e5354d3fd08a2b0a12b473ab7ae294c7",
"assets/assets/images/launch.png": "e56298f97c935f9d156d3184d2771bcc",
"assets/assets/images/tab_category_active.png": "9d005f084308d65ac9c0674a9f52935d",
"assets/assets/images/tab_home_active.png": "090e4b334db24cf5c6a6be4016ed16f0",
"assets/assets/data/categories.json": "40b4390f493f9ba5c514edfd1baafd64",
"assets/assets/data/regions": "c9dca3380830439ae66fc0f9f5fdb375",
"assets/assets/data/product_detail_images": "1e65639741ee790d7b6d40f09a836f75",
"assets/assets/data/images/product_image2.jpeg": "eaf9930437c98db183efa4cfd61e6708",
"assets/assets/data/images/order_image1.jpeg": "23420fb94024ad2aeee625957fa340a7",
"assets/assets/data/images/product_image3.jpeg": "6427a30c0d1709236aec1e003c7832db",
"assets/assets/data/images/detail_image1.jpeg": "2f6ccd09a98ff5de81f0dad7bfba907b",
"assets/assets/data/images/product_list.jpeg": "cfd2b70c7798423cdd2ea37b05013ca7",
"assets/assets/data/images/detail_image12.jpeg": "7072f5429a64c153f52022114447024b",
"assets/assets/data/images/product_image4.jpeg": "a2aa42e773af4ddc27ffa8ecfa92f5c7",
"assets/assets/data/images/detail_image6.jpeg": "cf17173827d110615fd5ea0aaedc787e",
"assets/assets/data/images/brand2.jpeg": "00d5eced9d4fcf18c3827f88f57e6d77",
"assets/assets/data/images/product_image5.jpeg": "79682d6f76898cc64ba2c93534b53c02",
"assets/assets/data/images/detail_image7.jpeg": "9068a39aee0e4f6b04fef75e86015ab6",
"assets/assets/data/images/detail_image8.gif": "8c9c659a6db159ee3b8de7cee46c2299",
"assets/assets/data/images/banner2.jpeg": "182c9483473814f8bbb138098c4799d9",
"assets/assets/data/images/banner1.jpeg": "8d2597d7573e793a0aa359b978ca49f5",
"assets/assets/data/images/order_image4.jpeg": "8851b1d68fe1c4627913ccac9654ea0d",
"assets/assets/data/images/brand1.jpeg": "d938ef377f73e8f90f142c280c713427",
"assets/assets/data/images/detail_image4.gif": "bfade12006f67cdbef45e29fbe346920",
"assets/assets/data/images/detail_image10.jpeg": "7b078f2d536d047adc4d17361cda804c",
"assets/assets/data/images/detail_image11.jpeg": "476f511fea25b761029036aae2f40a48",
"assets/assets/data/images/detail_image5.jpeg": "04ae8347260d309c458c03e7726353b2",
"assets/assets/data/images/order_image5.jpeg": "f58f8a6caa2fb9321549b7894cce2eca",
"assets/assets/data/images/detail_image9.jpeg": "2a6007523a24003143a3a58bde0ac033",
"assets/assets/data/images/detail_image2.jpeg": "e6e4606910d965391ffc4750e19adf57",
"assets/assets/data/images/order_image2.jpeg": "b4cae5fba56a5d3ac99a74e8e9080e8a",
"assets/assets/data/images/order_image3.jpeg": "3d7da4be237eeb0f7cc219944850666b",
"assets/assets/data/images/detail_image3.jpeg": "12a7e55c7ae72157092f44266d49c071",
"assets/assets/data/images/product_image1.jpeg": "cfd2b70c7798423cdd2ea37b05013ca7",
"assets/assets/data/product_images": "ea5fa7a4019ce573aab8fdf155a26ea1",
"assets/assets/data/skus.json": "ad9df2d89ede1156ded506826b178620",
"assets/assets/data/shippings": "c8fcf82597684cb03325548be81c63f4",
"assets/assets/data/addresses": "201cf85cbf331a8a60db6199400fd588",
"assets/assets/data/brands.json": "600cb122f44ec9018b40bb2035a492d6",
"assets/assets/data/orders": "100cba93113772aca475cbb77af949a9",
"assets/assets/data/product.json": "54da48afdee36d31f7adac8380b2b834",
"assets/assets/data/banners.json": "6ab1c187db6b24cd7e8178964ae731c6",
"assets/assets/data/sku_items.json": "5f20469f30992281d53b22c5ad264240",
"assets/assets/data/categories/category_f5652c0174840e5becd3b83d24cf58cb.png": "9b22c07ecccb3015845361f61dd11947",
"assets/assets/data/categories/category_8520d143bc736401795c5e7aa0f3b9e2.png": "df60f514aeab2cf87c9a1ba72af6956f",
"assets/assets/data/categories/category_5b1f2e73bc9fe.png": "1315f1570fc4b6084375b8be3716d412",
"assets/assets/data/categories/category_bf48ec711eee63b49e10312fad57cbb7.png": "b9e7ed5aa5bf9ab0783e78e9939b60a7",
"assets/assets/data/categories/category_4d0f348bedcd239a82e85eb6d65b266e.png": "b4dc0816aa329463a78f7ceb8cd99b2d",
"assets/assets/data/categories/category_5b1f23478cbac.png": "f44bfb512683f51aba7a61d586f61436",
"assets/assets/data/categories/category_a805862824699e567f16bade2fd0e601.png": "6561d62c0c2f5d4293c69b05e5cb6990",
"assets/assets/data/categories/category_5bdaba1ebbba7.png": "fedd05c16b1993e39ecbfa770241d27c",
"assets/assets/data/categories/category_fa74238c37ef03584e5533d703285464.png": "4e5f2d20756b02c22a499658ecd2cf3f",
"assets/assets/data/categories/category_5b1e231c6274b.png": "264c89d822baa0cb7e6f65b9fed2491a",
"assets/assets/data/categories/category_5bdabc3c00f8e.png": "e608c07f94b2437242c4420fb0e1a540",
"assets/assets/data/categories/category_1482e9e6be7cc3f440fd473d282f04b0.png": "3314b36d9b968c9f3339629d3875dc57",
"assets/assets/data/categories/category_a62b8bb7572de6d512734cdf46642529.png": "3087d117f5df93efd9084125a4cebf9a",
"assets/assets/data/categories/category_fb1333d92c185390f7adbcf3fe40c2ce.png": "550a535c1622e7a2f0675cf9f09af69b",
"assets/assets/data/categories/category_83a376ea693cfeac19fd2ade7f77446d.png": "1cf4f12abf477267c59cb82b27ba31a2",
"assets/assets/data/categories/category_b2b85844115f5c98c88bbeaccc70549c.png": "7596a12bba33019713e3e13bdc215ad5",
"assets/assets/data/categories/category_5bd96d7e92059.png": "589572bc0ea713024d962dc64584a3ac",
"assets/assets/data/categories/category_c6956ee7251b74eeb32c0f26ad12a9ea.png": "bfd60acf75824a1de2a425b807b1fd75",
"assets/assets/data/categories/category_f8f5fcc72abfce805f9cb6245418919a.png": "8f8e25eaece517ce0eb1bee16bb8c7ca",
"assets/assets/data/categories/category_e925e02bf6afcef4be0ff643b71fab12.png": "11ababfb4d2f0209a48d6faa747d704e",
"assets/assets/data/categories/category_c991f9962b2c7e264ba28cbe04945178.png": "669e24cf1ca407e38b07cc9eab89f4af",
"assets/assets/data/categories/category_5bdaba9072793.png": "021678043a4c282481d593173c376b10",
"assets/assets/data/categories/category_986a64fb82990f6d7a6efbe694d05974.png": "f2d60787da10604479e7b3394faee391",
"assets/assets/data/categories/category_3d9307fbd0d84d66bef1d714cbcb3ce0.png": "10156395054cf8f2ee8474c9a62b3c50",
"assets/assets/data/categories/category_5b1f2bb404975.png": "5d0a1eee56cef2e9b085eb1a15c09917",
"assets/assets/data/categories/category_5b1f2b96f3853.png": "a0a6c21fb1fa6c5e25dcce7ce3704428",
"assets/assets/data/categories/category_2b10608bfd628e67940e8e32def1d74e.png": "50b4d557adf374073f832931950afca0",
"assets/assets/data/categories/category_1d529fd0d8147dcbc6d4f47203dcec12.png": "a7b70b479e007a2132f63eca0c8f8c61",
"assets/assets/data/categories/category_5b1f23f8e7564.png": "338f85439aeb5d284b0f04b1ea4305d0",
"assets/assets/data/categories/category_5bdabcd396fa1.png": "059c8c8d0bdd77f8d9de43119d7a9396",
"assets/assets/data/categories/category_5b1e2d9dcf941.png": "a295e76fdc759a8f81e4292b9dc914bb",
"assets/assets/data/categories/category_5e2e4629bff9d9a5f66780e7a182c4e9.png": "932c5496867f6882bcf718f3061327a3",
"assets/assets/data/categories/category_4b04cd6647455ddec5ba5d336a51c616.png": "50c23d2e4569992c84fa32a860b3f9d1",
"assets/assets/data/categories/category_91036e90861db86d8e1599fea8aed929.png": "dcd85942e582ebcc268b9bf3e3c613e1",
"assets/assets/data/categories/category_743df4ab7f251ac901564b929b2cc47b.png": "80697a6256473b03632706e56db590f3",
"assets/assets/data/categories/category_574582c12cb4634552dc592b376d224c.png": "523d43f5cd49f278a6e140c6179bb8ef",
"assets/assets/data/categories/category_6e7ef3208791cbf83b4bd8dd0cc19139.png": "a7c302ef8c7cb860f23729a52edcda85",
"assets/assets/data/categories/category_5b1f2f341ab11.png": "40476d7d7d17b5edb55bb65b8ced6f0f",
"assets/assets/data/categories/category_6bbffe1d01bfd6da1192d73e3eb1b139.png": "983aee3949ca9b71ae1add9156cacc7d",
"assets/assets/data/categories/category_4372817e37418bd11259506aa88f4749.png": "f8f925fa37894550e9367b06f7a5bfcf",
"assets/assets/data/categories/category_269d689ab8c5968b05cb818e757d8909.png": "16e599fbf830d092e2ee5037332d1015",
"assets/assets/data/categories/category_e841322871b02f0d18d6b03eda7e810d.png": "b6ed9530765479bab25a4ab9e821fbb8",
"assets/assets/data/categories/category_5b1f2e044a314.png": "d59b51bcb0c84c6b4dabbc01a1c43ffd",
"assets/assets/data/categories/category_b10871be7377526f3f9e3da6ee94f7d6.png": "0c6fac6b254f9b32fc1a267ce4fd3ec8",
"assets/assets/data/categories/category_5b1e2bd963d67.png": "c2627c8208c2559cdcc2bf51e17a3329",
"assets/assets/data/categories/category_ec2987ae0e5a6bf85195be15ca332268.png": "01acd96f7008575519fae26e3e94256f",
"assets/assets/data/categories/category_xiebao.png": "17a854bc89a5c2e3f50271f4a334f728",
"assets/assets/data/categories/category_09ffb84e1bd429c50168b20b574293fe.png": "6051dc3791facd03df4055c4fa16e5ce",
"assets/assets/data/categories/category_a000236b9b8207577f47ffcbc5c41de0.png": "262d8080c7c75f66ca66d203ffefc282",
"assets/assets/data/categories/category_90bc59efbfb77328d41e806ec823edf3.png": "b514865aae36bfb5cfcaba3b544e48c5",
"assets/assets/data/categories/category_59efe8bcfccc7e3d43a94ed17db2aeb1.png": "c546adee29747167bb0ba9a1e72b2797",
"assets/assets/data/categories/category_f0e04b9343802a0c5a96e81a71e23f62.png": "c9dda893a40a125c625c17e33264e592",
"assets/assets/data/categories/category_5b1f2418ed9ba.png": "e481f34d491fee877e423271394a4c67",
"assets/assets/data/categories/category_176538a59eb50ed525b5ecb26fe9200b.png": "43efb7ab85deb0826e93055789857c70",
"assets/assets/data/categories/category_5b1f241888550.png": "c8a1ddb6cc66fa6e092fdb2c4e40b28c",
"assets/assets/data/categories/category_5b1f3e82d0772.png": "e41b0364fcb24837ec326ec42d239ba8",
"assets/assets/data/categories/category_f1aa571f96983cc285abd778164f00fd.png": "0b1919dffdfa809fb7f0c076335f246b",
"assets/assets/data/categories/category_9a32fa265a3082dbea976ccc21bd4e49.png": "554f28b83b8471fa399c1ebf7565219d",
"assets/assets/data/categories/category_ad58050865164e845c1e33b76a0e4eb1.png": "2452c813f711466a4add83820ae32534",
"assets/assets/data/categories/category_shisanhang.png": "306dbbc3e18fced74ed16a086049726d",
"assets/assets/data/categories/category_542d5342d2296153a94289573a270d94.png": "50301b8f362265934ba37c61b81dfaae",
"assets/assets/data/categories/category_040d3ae17a3d378f74db220279bdb622.png": "1e330641f7a71a52455aafdd60943b00",
"assets/assets/data/categories/category_5bdac0a0eebfd.png": "3691d072eff444e9c9be38a1c663dd24",
"assets/assets/data/categories/category_d6ae3f21691ae43648d3dfc8091bb5ca.png": "1453e22a1a438957a8721291d551388a",
"assets/assets/data/categories/category_70ec205c382c6459b745e2fbd617793c.png": "6294eb32cee65e0d875cdccdedb027b6",
"assets/assets/data/categories/category_2e7f7854e5e3af85a86b2c458589ddc7.png": "fa89ea57b64094969034c188a3b6403f",
"assets/assets/data/categories/category_987239620d6810296abe5bbc79533ce5.png": "9ba03e98b45e7dc8d57954c1bfe2f48a",
"assets/assets/data/categories/category_9520e092b1fee0e71a68f6293eaac9e7.png": "54f4ddf7ac3669c8f87ce1f95fbd2624",
"assets/assets/data/categories/category_5b1e2c4b938ec.png": "136c486581cefe2df231a3c2a3645b21",
"assets/assets/data/categories/category_nanyou.png": "68926c81513504afed6290023ac8581b",
"assets/assets/data/categories/category_5b1f2bb4258a7.png": "3f827aa052660079e0b308f5b6ced12f",
"assets/assets/data/categories/category_29908acd977e0ef3c637a03da37a7d9a.png": "c0b84934633418ed67e15328bdf40ea7",
"assets/assets/data/categories/category_5bdabba93bad5.png": "c56971db4ee32abc75784baaba6ca279",
"assets/assets/data/categories/category_8ac3f51e81b31c39f5a78485a4435835.png": "347f1a3782240bf79a257b39cf142ddc",
"assets/assets/data/categories/category_e99b8ce1f6fa243e97d74e2f3d2f375f.png": "dfab34e802edfd7f68cc17fbd374d95c",
"assets/assets/data/categories/category_199be0443d0ee2861ddaf6cdf507ce2d.png": "6150e088610591599d719ef3ab464722",
"assets/assets/data/categories/category_sijiqingpuyuan.png": "a04e9b962b2685b3e3e6caa867d40479",
"assets/assets/data/categories/category_5b1f2fafc7085.png": "f759d21de6091954fa4e983570cdcfd1",
"assets/assets/data/categories/category_1c36fc04744844c8425c4fab4907282b.png": "30c017bc4a14e8c349e2bd8bec4ac7e4",
"assets/assets/data/categories/category_5b1f3248ed634.png": "f258b10bea295aed2aef1a54f7bcb9db",
"assets/assets/data/categories/category_5b1f2b5e3c5a1.png": "904ee7f92e591b59772cdbd401d993cc",
"assets/assets/data/categories/category_ebc06dd51e9a9eb4309c25fd550082b2.png": "73c46b4023f6daa3fe3b2d3ffb851500",
"assets/assets/data/categories/category_459026f5a7c67690a69adbaa80c69be5.png": "a7f9709a6b00149ee5382e508bf87a55",
"assets/assets/data/shopping_carts.json": "45e54eab8fcf42ed8299b1a87576815d",
"assets/assets/data/announcement.json": "5acaf20b27f9022e66b03ccda65eac37"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
