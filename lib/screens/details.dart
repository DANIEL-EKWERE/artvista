import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:artvista/models/model1.dart';
import 'package:artvista/provider/ads_provider.dart';
import 'package:artvista/provider/post_provider.dart';
import 'package:artvista/widgets/snackbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:html/parser.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class DetailsPage extends StatefulWidget {
  final Post singlePost;
  const DetailsPage({super.key, required this.singlePost});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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

  void launchYoutubeVideo(String? url, BuildContext context) async {
    if (url != null) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'could not launch $url';
      }
    } else {
      // showMessage(context: context, message: 'video not available');
      showErrorSnackbar(message: 'video not available');
    }
  }

  static final customCacheManager = CacheManager(Config('customCacheKey',
      stalePeriod: const Duration(days: 1), maxNrOfCacheObjects: 50));
  _parseHtmlString1(String htmlString) {
    final document = parse(htmlString);
    final String parseString = parse(document.body!.text).documentElement!.text;
    return Text(
      parseString,
      style: kEncodeSansSemiBold.copyWith(
          color: kLightGrey, fontSize: SizeConfig.blockSizeHorizontal! * 2),
    );
  }

  downlaoder(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      var value = await FlutterDownloader.enqueue(
        url: url,
        headers: {}, // optionofal: header send with url (auth token etc)
        savedDir: baseStorage!.path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
        saveInPublicStorage: true,
      );
      return value;
    }
    final baseStorage = await getExternalStorageDirectory();
    var value = await FlutterDownloader.enqueue(
      url: url,
      headers: {}, // optionofal: header send with url (auth token etc)
      savedDir: baseStorage!.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
      saveInPublicStorage: true,
    );
    return value;
  }

  ReceivePort _port = ReceivePort();

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
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int statusIndex = data[0];
      DownloadTaskStatus? statusIndex1;
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(statusIndex);
      int progress = data[2];

      if (status == DownloadTaskStatus.complete) {
       showSuccessSnackbar(message: 'Completed');
      } else if (status == DownloadTaskStatus.running) {
        showSuccessSnackbar(message: 'Downloading');
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    initBannerAds();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    // int current = 0;
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
    // List<String> categories = <String>[
    //   'recent',
    //   '2D Wallpaper',
    //   'album cover',
    //   'character design',
    //   'cover ',
    //   'NFTs',
    //   'portrait toon art',
    //   'Tee j',
    //   'tuts & anim vids',
    // ];

    SizeConfig().init(context);
    // double sizeVertical = SizeConfig.blockSizeHorizontal!;
    double sizeHorizontal = SizeConfig.blockSizeVertical!;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.purple,
                onPressed: () async {
                  print(widget.singlePost.image);
                  // FileDownloader.downloadFile(
                  //   url: widget.singlePost.image,
                  //   name: widget.singlePost.title,
                  //   // onProgress: (fileName, progress) {
                  //   //   print('file $fileName has progress $progress');
                  //   // },
                  //   onDownloadCompleted: (path) {
                  //     final File file = File(path);
                  //     print('download completed file downloaded to $file');
                  //   },
                  //   onDownloadError: (errorMessage) {
                  //     print('something went wrong $errorMessage');
                  //   },
                  // );
//showMessage(message: 'download completed');
                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //   content: Text('downloading please wait...'),
                  //   duration: Duration(seconds: 5),
                  //   behavior: SnackBarBehavior.floating,
                  //   backgroundColor: Colors.purple,
                  // ));
                           showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.info(
                                  message:
                                      "Downloading please wait.......",
                                ),
                              );
                             
                  // Fluttertoast.showToast(
                  //     msg: 'this is a toast message',
                  //     toastLength: Toast.LENGTH_LONG,
                  //     gravity: ToastGravity.TOP,
                  //     backgroundColor: Colors.purple,
                  //     textColor: Colors.white,
                  //     fontSize: SizeConfig.blockSizeHorizontal! * 1.5);
                  var x = await downlaoder(widget.singlePost.image);
                  print('the value of x is........$x');
                   Provider.of<AdsProvider>(context, listen: false)
                                    .showRewardedInterstitialAd();
                  // showMessage(message: 'download completed');
                  // ignore: use_build_context_synchronously
                           showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  message:
                                      "Download completed!",
                                ),
                              );

                  Future.delayed(const Duration(seconds: 3), () {
                    Provider.of<AdsProvider>(context, listen: false)
                        .showRewardedAd();
                    print('now calling toast message....');
                    showSuccessSnackbar(message: 'download completed');
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                ),
              )),
          SizedBox(
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.purple,
                onPressed: () async {
                  if(widget.singlePost.video == null){
                             showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.error(
                                  message:
                                      "Video not available!",
                                ),
                              );
                  }
                  launchYoutubeVideo(widget.singlePost.video, context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.play_circle_outline_rounded,
                  color: Colors.white,
                ),
              ))
        ]),
      ),
      backgroundColor: kBlack,
      bottomNavigationBar: isLoaded
          ? SizedBox(
              height: bannerAd!.size.height.toDouble(),
              width: bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          : const SizedBox(),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(
              //width: double.infinity,
              height: SizeConfig.blockSizeVertical! * 40,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Hero(
                    tag: widget.singlePost,
                    child: CachedNetworkImage(
                      imageUrl: widget.singlePost.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.pink,
                        child: const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: SizeConfig.blockSizeHorizontal! * 4,
                              width: SizeConfig.blockSizeVertical! * 4,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kWhite,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kBrown.withOpacity(0.11),
                                      spreadRadius: 0.0,
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    )
                                  ]),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.chevron_left),
                            ),
                          ),
                          Container(
                            height: SizeConfig.blockSizeHorizontal! * 4,
                            width: SizeConfig.blockSizeVertical! * 4,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: kBrown.withOpacity(0.11),
                                    spreadRadius: 0.0,
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  )
                                ]),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                                'assets/images/unselected_favorite.svg'),
                          )
                        ]),
                  ),
                )
              ]),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 1,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  widget.singlePost.title,
                  style: kEncodeSansBold.copyWith(
                      color: kDarkGrey,
                      fontSize: SizeConfig.blockSizeHorizontal! * 2.6),
                )),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text(
                      widget.singlePost.created.substring(0, 10),
                      style: kEncodeSansMedium.copyWith(
                          color: kDarkGrey,
                          fontSize: SizeConfig.blockSizeHorizontal! * 1.5),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 1,
            ),
            Row(
              children: [
                Expanded(
                    child: _parseHtmlString1(
                  widget.singlePost.body,
                )
                    // Text(
                    //   widget.singlePost.body,
                    //   style: kEncodeSansSemiBold.copyWith(
                    //       color: kLightGrey,
                    //       fontSize: SizeConfig.blockSizeHorizontal! * 2),
                    // ),
                    )
              ],
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 5,
            ),
            Text(
              'Similar Posts',
              style: kEncodeSansBold.copyWith(
                  color: kLightGrey,
                  fontSize: SizeConfig.blockSizeHorizontal! * 3),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical! * 5,
            ),
            FutureBuilder(
              future: PostProvider().allPost(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    height: 700,
                    child: MasonryGridView.count(
                        itemCount: snapshot.data?.length,
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
                           //showSuccessSnackbar(message: 'loading...');
                            showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.info(
                                  message:
                                      "Loading please wait.....",
                                ),
                              );
                              Post singlePost =
                                  await context.read<PostProvider>().singlePost(
                                        id: snapshot.data![index].id,
                                      );
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(singlePost: singlePost)));
                                       showTopSnackBar(
                                Overlay.of(context),
                                CustomSnackBar.success(
                                  message:
                                      "Post Retrived!!!",
                                ),
                              );
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
                                              imageUrl: item1,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Container(
                                                    color: Colors.pink,
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
                                                      )),
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
                                    //             ? ScaffoldMessenger.of(context)
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
                                    //             : ScaffoldMessenger.of(context)
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
                                _parseHtmlString(
                                  snapshot.data![index].body,
                                  // style: kEncodeSansMedium.copyWith(
                                  //     color: kGrey,
                                  //     fontSize: sizeHorizontal * 1.5),
                                  // maxLines: 2,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        })),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
                //
              },
              // child:
            ),
          ],
        ),
      )),
    );
  }
}
