import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:artvista/models/model1.dart';
import 'package:artvista/provider/post_provider.dart';
import 'package:artvista/screens/details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    super.initState();
  }

  bool isFav = false;

  var adUnit = 'ca-app-pub-8689659519341801/7129774650';
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

  @override
  void didChangeDependencies() {
    initBannerAds();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController!.dispose();
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeVertical = SizeConfig.blockSizeHorizontal!;
    double sizeHorizontal = SizeConfig.blockSizeVertical!;
    return Scaffold(
        // bottomNavigationBar: isLoaded
        //     ? SizedBox(
        //         height: bannerAd!.size.height.toDouble(),
        //         width: bannerAd!.size.width.toDouble(),
        //         child: AdWidget(ad: bannerAd!),
        //       )
        //     : const SizedBox(),
        backgroundColor: kBlack,
        // appBar: AppBar(
        //   systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarIconBrightness: Brightness.light,
        //     statusBarColor: Colors.black,
        //   ),
        //   // flexibleSpace:
        // ),
        body: SafeArea(
            child: Column(
          children: [
            isLoaded
                ? SizedBox(
                    height: bannerAd!.size.height.toDouble(),
                    width: bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: bannerAd!),
                  )
                : const SizedBox(),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                style: kEncodeSansBold.copyWith(color: kDarkGrey),
                // maxLength: 10,
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const IconTheme(
                      data: IconThemeData(color: kDarkGrey),
                      child: Icon(Icons.search)),
                  suffixIcon: IconTheme(
                      data: const IconThemeData(),
                      child: GestureDetector(
                        onTap: () {
                          _searchController!.text = '';
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: kDarkGrey,
                        ),
                      )),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                  hintText: 'Search for Arts',
                  hintStyle: kEncodeSansBold.copyWith(color: kDarkGrey),
                  label: Text(
                    'Search for Arts',
                    style: kEncodeSansSemiBold.copyWith(
                        color: kWhite,
                        fontSize: SizeConfig.blockSizeHorizontal! * 2.0),
                  ),
                  focusedBorder: kInputBorder,
                  border: kInputBorder,
                  filled: true,
                  fillColor: kBrown,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: FutureBuilder(
                future: PostProvider().searchedPost(
                    query: _searchController!.text.trim().toString()),
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
                                Post singlePost = await context
                                    .read<PostProvider>()
                                    .singlePost(
                                      id: snapshot.data![index].id,
                                    );
                                print(singlePost.author.bio.toString());
                                ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Loading...'),
                                duration: Duration(seconds: 5),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.purple,
                              )); 
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Hero(
                                            tag: item1,
                                            child: Image.network(
                                              'https://audrey-art.com$item1',
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
                                      //         setState(() {
                                      //           isFav = !isFav;
                                      //         });
                                      //         isFav
                                      //             ? ScaffoldMessenger.of(
                                      //                     context)
                                      //                 .showSnackBar(
                                      //                     const SnackBar(
                                      //                 content: Text(
                                      //                     'removed from favourite'),
                                      //                 duration:
                                      //                     Duration(seconds: 3),
                                      //                 behavior: SnackBarBehavior
                                      //                     .floating,
                                      //                 backgroundColor:
                                      //                     Colors.purple,
                                      //               ))
                                      //             : ScaffoldMessenger.of(
                                      //                     context)
                                      //                 .showSnackBar(
                                      //                     const SnackBar(
                                      //                 content: Text(
                                      //                     'Added to favourite'),
                                      //                 duration:
                                      //                     Duration(seconds: 3),
                                      //                 behavior: SnackBarBehavior
                                      //                     .floating,
                                      //                 backgroundColor:
                                      //                     Colors.purple,
                                      //               ));
                                      //         bool value = false;
                                      //         Checkbox(
                                      //             value: value,
                                      //             onChanged: null);
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
          ],
        )));
  }
}
