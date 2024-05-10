import 'package:artvista/customizations/app_style.dart';
import 'package:artvista/customizations/size_config.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'Google Services',
              style: kEncodeSansSemiBold.copyWith(
                  color: kDarkGrey,
                  fontSize: SizeConfig.blockSizeHorizontal! * 2),
              textAlign: TextAlign.justify,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'We use Google Analytics to collect information about how visitors use our website. Google Analytics collects information such as how often users visit our website, what pages they visit when they do so, and what other sites they used prior to coming to our website. We use the information we get from Google Analytics to improve our website and services. We also use Google Search Console to monitor and optimize the performance of our website in Google search results. Google Search Console collects information such as search queries, click-through rates, and website errors. Google may use cookies to collect information about your use of our website. You can learn more about how Google uses cookies by visiting Google\'s "https://policies.google.com/privacy?hl=en-US" (Privacy & Terms) page.',
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'Sercurity',
              style: kEncodeSansSemiBold.copyWith(
                  color: kDarkGrey,
                  fontSize: SizeConfig.blockSizeHorizontal! * 2),
              textAlign: TextAlign.justify,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'We take reasonable steps to protect the personal information we collect from unauthorized access, disclosure, alteration, or destruction. However, no website can be completely secure, so we cannot guarantee the security of your personal information.',
              textAlign: TextAlign.justify,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'Changes to this Policy',
              style: kEncodeSansSemiBold.copyWith(
                  color: kDarkGrey,
                  fontSize: SizeConfig.blockSizeHorizontal! * 2),
              textAlign: TextAlign.justify,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Text(
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new privacy policy on this page. You are advised to review this privacy policy periodically for any changes.',
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
