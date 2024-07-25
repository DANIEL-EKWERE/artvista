import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:artvista/models/model1.dart';
import 'package:artvista/provider/ads_provider.dart';
import 'package:artvista/provider/post_provider.dart';
import 'package:artvista/screens/about.dart';
import 'package:artvista/screens/privacy_policy.dart';
import 'package:artvista/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';
import 'details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var item;
  int current = 0;
  // final imageList = [
  //   '2D Wallpaper.jpg',
  //   'album cover.jpg',
  //   'character design.jpg',
  //   'cover .jpg',
  //   'NFTs.jpg',
  //   'portrait toon art.jpg',
  //   'Tee j.jpg',
  //   'tuts & anim vids.jpg',
  // ];
  //final itemCount = imageList.length;

  bool isFav = false;
  List<String> categories = <String>[
    'All',
    '2D Wallpaper',
    'music cover art',
    'character design',
    'NFTs',
    'portrait toon art',
    'Tee jay',
    'sketches',
  ];

  String cat = 'all-post';

  Future fetchPost() async {
    final List<Post> posts = await PostProvider().allPost();

    // Use the TransactionProvider to update the state
    Provider.of<PostProvider>(context, listen: false).allPost();
    return posts;
  }

  Future fetchPostBasedCategory() async {
    final List<Post> posts = await PostProvider().postBasedCategory(cat: cat);

    // Use the TransactionProvider to update the state
    Provider.of<PostProvider>(context, listen: false).allPost();
    return posts;
  }

  Future fetchSinglePost() async {
    print('this is single post beem called 1');
    final Post posts = await PostProvider().singlePost(id: 4);

    // Use the TransactionProvider to update the state
    Provider.of<PostProvider>(context, listen: false).allPost();
    print('this is single post beem called 1 2');
    return posts;
  }

  var adUnit = 'ca-app-pub-3940256099942544/6300978111';
  BannerAd? bannerAd;
  bool isLoaded = false;
  initBannerAds() {
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isLoaded = true;
            });
            print('loading.......');
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());

    bannerAd!.load();
  }

  bool all = true;
  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 1), maxNrOfCacheObjects: 100));

  @override
  void initState() {
    Provider.of<AdsProvider>(context, listen: false)
        .createRewardedInterstitialAd();
    Provider.of<AdsProvider>(context, listen: false).createInterstitialAd();
    Provider.of<AdsProvider>(context, listen: false).createRewardedAd();
    Provider.of<AdsProvider>(context, listen: false).createNativeAd();
    Provider.of<AdsProvider>(context, listen: false).showNativeAd();

    Provider.of<AdsProvider>(context, listen: false).initBannerAds();
    initBannerAds();
    super.initState();

    fetchPost();
    fetchSinglePost();
  }

  @override
  void dispose() {
    super.dispose();
    AdsProvider().interstitialAd?.dispose();
    AdsProvider().rewardedAd?.dispose();
    AdsProvider().rewardedInterstitialAd?.dispose();
    AdsProvider().bannerAd!.dispose();
    AdsProvider().nativeAd!.dispose();
  }

  _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parseString = parse(document.body!.text).documentElement!.text;
    return Text(
      parseString,
      style: kEncodeSansMedium.copyWith(
          color: kGrey, fontSize: SizeConfig.blockSizeHorizontal! * 1.5),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  void launchWebSite(String? url, BuildContext context) async {
    if (url != null) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'could not launch $url';
      }
    } else {
      showErrorSnackbar(message: 'video not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeVertical = SizeConfig.blockSizeHorizontal!;
    double sizeHorizontal = SizeConfig.blockSizeVertical!;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Artvista',
          style: kEncodeSansBold.copyWith(
              color: Colors.purple, fontSize: sizeVertical * 3),
        ),
        // leading: const Drawer(
        //   child: Icon(Icons.menu),
        // ),
        iconTheme: const IconThemeData(color: kWhite),
        flexibleSpace:
            Container(decoration: const BoxDecoration(color: Colors.black)),
        elevation: 0,
        shadowColor: const Color.fromARGB(0, 255, 255, 255)..withOpacity(0.9),
        backgroundColor:
            const Color.fromARGB(0, 255, 255, 255).withOpacity(0.9),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                const Text('AUDREY ART'),
                SizedBox(
                  height: sizeVertical * 2,
                ),
                const Image(
                  image: AssetImage('assets/images/artvista logo.jpg'),
                  fit: BoxFit.cover,
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              'About',
              style: kEncodeSansMedium.copyWith(
                  color: kGrey, fontSize: SizeConfig.blockSizeHorizontal! * 2),
            ),
            onTap: () {
              Navigator.of(context).push(
                  CupertinoPageRoute(builder: (context) => const About()));
              Provider.of<AdsProvider>(context, listen: false)
                  .showRewardedInterstitialAd();
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Privacy Policy',
              style: kEncodeSansMedium.copyWith(
                  color: kGrey, fontSize: SizeConfig.blockSizeHorizontal! * 2),
            ),
            onTap: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const PrivacyPolicy()));
              Provider.of<AdsProvider>(context, listen: false)
                  .showInterstitialAd();
            },
          ),
          const Divider(),
          ListTile(
            title: Text(
              'visit site',
              style: kEncodeSansMedium.copyWith(
                  color: kGrey, fontSize: SizeConfig.blockSizeHorizontal! * 2),
            ),
            onTap: () {
              launchWebSite('https://audrey-art.com', context);
            },
          ),
        ]),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: sizeVertical * 2,
          ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      setState(() {
                        cat = 'all-post';
                        all = true;
                      });
                    } else if (index == 5) {
                      setState(() {
                        cat = 'portrait-toon-art';
                        all = false;
                      });
                    } else if (index == 3) {
                      setState(() {
                        cat = 'character-design';
                        all = false;
                      });
                    } else if (index == 2) {
                      setState(() {
                        cat = 'music-cover-art';
                        all = false;
                      });
                    } else if (index == 1) {
                      setState(() {
                        cat = '2d-wallpaper';
                        all = false;
                      });
                    } else if (index == 4) {
                      setState(() {
                        cat = 'NFTs';
                        all = false;
                      });
                    } else if (index == 7) {
                      setState(() {
                        cat = 'sketches';
                        all = false;
                      });
                    } else if (index == 6) {
                      setState(() {
                        cat = 'tee-jay';
                        all = false;
                      });
                    } else if (index == 9) {
                      setState(() {
                        cat = 'tutorials';
                        all = false;
                      });
                    }
                    setState(() {
                      current = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: current == 0 ? 12 : 15,
                      right: current == categories.length - 1 ? 15 : 1,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: current == index ? Colors.purple : kWhite,
                      border: current == index
                          ? null
                          : Border.all(
                              color: kLightGrey,
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          categories[index],
                          style: kEncodeSansMedium.copyWith(
                            color: current == index ? kWhite : kDarkBrown,
                            fontSize: SizeConfig.blockSizeHorizontal! * 2,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: sizeVertical * 1,
          ),
          // const Text('Recent Posts'),
          Padding(
            padding:
                const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 200),
            child: FutureBuilder(
              future: all
                  ? PostProvider().allPost()
                  : PostProvider().postBasedCategory(cat: cat),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 700,
                    child: MasonryGridView.count(
                        itemCount: snapshot.data!.length,
                        mainAxisSpacing: 27,
                        crossAxisSpacing: 23,
                        crossAxisCount: 2,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          final item1 = snapshot.data![index].image;
                          return GestureDetector(
                            key: UniqueKey(),
                            onTap: () async {
                              // print(item1);
                              if (index == 3 &&
                                  context.read<AdsProvider>().nativeAd !=
                                      null) {
                                return Provider.of<AdsProvider>(context,
                                        listen: false)
                                    .showNativeAd();
                              }
                              if (context.read<AdsProvider>().clickCount == 3) {
                                Provider.of<AdsProvider>(context, listen: false)
                                    .showRewardedInterstitialAd();
                                context.read<AdsProvider>().resetCount();
                              } else {
                                context.read<AdsProvider>().increamentCount();
                              }
                              showSuccessSnackbar(message: 'loading...');
                              Post singlePost =
                                  await context.read<PostProvider>().singlePost(
                                        id: snapshot.data![index].id,
                                      );
                              print(singlePost.author.bio.toString());
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(singlePost: singlePost)));
                              //     print(item1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Hero(
                                          tag: item1,
                                          child: CachedNetworkImage(
                                            cacheManager: customCacheManager,
                                            key: UniqueKey(),
                                            imageUrl: item1,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(
                                              color: Colors.purple,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.pink,
                                              child: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: 80,
                                              ),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Positioned(
                                    //     top: 10,
                                    //     right: 10,
                                    //     child: GestureDetector(
                                    //       onTap: () {
                                    //         //   print(index);
                                    //         // setState(() {
                                    //         //   isFav = !isFav;
                                    //         // });
                                    //         // isFav
                                    //         //     ? ScaffoldMessenger.of(context)
                                    //         //         .showSnackBar(
                                    //         //             const SnackBar(
                                    //         //         content: Text(
                                    //         //             'removed from favourite'),
                                    //         //         duration:
                                    //         //             Duration(seconds: 3),
                                    //         //         behavior: SnackBarBehavior
                                    //         //             .floating,
                                    //         //         backgroundColor:
                                    //         //             Colors.purple,
                                    //         //       ))
                                    //         //     : ScaffoldMessenger.of(context)
                                    //         //         .showSnackBar(
                                    //         //             const SnackBar(
                                    //         //         content: Text(
                                    //         //             'Added to favourite'),
                                    //         //         duration:
                                    //         //             Duration(seconds: 3),
                                    //         //         behavior: SnackBarBehavior
                                    //         //             .floating,
                                    //         //         backgroundColor:
                                    //         //             Colors.purple,
                                    //         //       ));
                                    //         bool value = false;
                                    //         Checkbox(
                                    //             value: value, onChanged: null);
                                    //       },
                                    //       child: SvgPicture.asset(isFav
                                    //           ? 'assets/images/unselected_favorite.svg'
                                    //           : 'assets/images/selected_favorite.svg'),
                                    //     )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                //List<bool> likedList = List.generate(imageList.length, (index) => false);
                                Text(
                                  snapshot.data![index].title,
                                  style: kEncodeSansBold.copyWith(
                                      color: kWhite,
                                      fontSize: sizeHorizontal * 1.8),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data![index].created
                                      .substring(0, 10),
                                  style: kEncodeSansSemiBold.copyWith(
                                      color: kLightGrey,
                                      fontSize: sizeHorizontal * 1.2),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                _parseHtmlString(snapshot.data![index].body),
                              ],
                            ),
                          );
                        })),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: sizeVertical * 40),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Center(child: CircularProgressIndicator())),
                  );
                }
                //
              },
              // child:
            ),
          ),
          SizedBox(
            height: sizeVertical * 4,
          ),
        ],
      )),
    ));
  }
}
