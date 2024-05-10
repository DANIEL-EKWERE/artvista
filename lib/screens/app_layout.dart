import 'package:artvista/customizations/size_config.dart';
import 'package:artvista/screens/favourite.dart';
import 'package:artvista/screens/homescreen.dart';
import 'package:artvista/screens/search.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/snackbar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_nav_bar/google_nav_bar.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    initBannerAds();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bannerAd!.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  bool isChecked = false;
  int currentIndex = 1;
// late VoidCallback openDrawer;
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

  void launchEamil(BuildContext context) async {
    // if (url != null) {
    Uri email = Uri.parse(
        'mailto:audreyart062@gmail.com?subject=Art Vista&body=hello there Art Vista.....');
    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      throw 'could not launch $email';
    }
    // } else {
    //   showMessage(context: context, message: 'something went wrong');
    // }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchPage(),
  ];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
//double sizeVertical = SizeConfig.blockSizeHorizontal!;
    return Scaffold(
      bottomNavigationBar: isLoaded
          ? SizedBox(
              height: bannerAd!.size.height.toDouble(),
              width: bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: bannerAd!),
            )
          : const SizedBox(),
      body: Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          // vertical: 10,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          SizedBox(
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.purple,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchPage()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )),
          SizedBox(
              width: 100,
              child: FloatingActionButton(
                backgroundColor: Colors.purple,
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const FavouriteScreen()));
                  launchEamil(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ))
        ]),
      ),
    );
  }
}
