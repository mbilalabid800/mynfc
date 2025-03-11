// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/models/connections_model.dart';
import 'package:nfc_app/provider/connection_details_provider.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/services/contact_service.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/utils/url_launcher_helper.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';
import 'package:provider/provider.dart';

class ConnectionProfilePreview extends StatefulWidget {
  final String userId;
  const ConnectionProfilePreview({super.key, required this.userId});

  @override
  State<ConnectionProfilePreview> createState() =>
      _ConnectionProfilePreviewState();
}

class _ConnectionProfilePreviewState extends State<ConnectionProfilePreview> {
  late ConnectionDetailsProvider connectionProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final connectionProfile =
          Provider.of<ConnectionDetailsProvider>(context, listen: false);
      if (widget.userId.isNotEmpty) {
        connectionProfile.loadConnectionDetails(widget.userId);
      } else {
        debugPrint("Error: userId is empty or invalid");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFEF),
        body: Consumer<ConnectionDetailsProvider>(
          builder: (context, connectiondetailsprovider, child) {
            final connectionDetails =
                connectiondetailsprovider.connectionDetails;
            if (connectiondetailsprovider.isLoading) {
              return Center(child: ScreenLoader());
            }

            if (connectionDetails == null) {
              return const Center(
                child: Text(
                  "",
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.0001),
                kIsWeb
                    ? AbsherAppBar(
                        title: 'Profile',
                      )
                    : AbsherAppBar3(
                        title: 'Profile',
                        onLeftButtonTap: () {
                          Navigator.pop(context);
                        },
                        rightButton: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                              width: DeviceDimensions.screenWidth(context) *
                                  0.035),
                        ),
                      ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.020),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // SizedBox(
                        //     height:
                        //         DeviceDimensions.screenHeight(context) * 0.050),
                        Container(
                          width: DeviceDimensions.screenWidth(context) * 0.90,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Center(
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         vertical: 12.0),
                              //     child: Text(
                              //       "Profile",
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.w600,
                              //           fontSize:
                              //               DeviceDimensions.responsiveSize(
                              //                       context) *
                              //                   0.041,
                              //           fontFamily: 'Barlow-Regular'),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenWidth(context) *
                                          0.025),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 15),
                                    child: CircleAvatar(
                                      radius: 58,
                                      backgroundColor: Colors.black54,
                                      child: CachedNetworkImage(
                                        imageUrl: connectionDetails
                                                .profileImage.isNotEmpty
                                            ? connectionDetails.profileImage
                                            : 'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/default_profile.jpg?alt=media&token=dec3b09a-d6fd-47a2-ae5b-cb0e248ae21c',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 58,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: SmallThreeBounceLoader(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/default_profile.jpg'),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.48,
                                          child: Text(
                                            "${connectionDetails.firstName} ${connectionDetails.lastName}",
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.055,
                                              fontFamily: 'Barlow-Regular',
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: DeviceDimensions.screenWidth(
                                                  context) *
                                              0.45,
                                          child: Text(
                                            connectionDetails.designation,
                                            style: TextStyle(
                                              fontSize: DeviceDimensions
                                                      .responsiveSize(context) *
                                                  0.040,
                                              fontFamily: 'Barlow-Regular',
                                              color: const Color(0xFF909091),
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          "at ${connectionDetails.companyName}",
                                          style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.039,
                                            fontFamily: 'Barlow-Regular',
                                            // color: const Color(0xFF909091),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Padding(
                                        //       padding: const EdgeInsets.only(
                                        //           left: 1.5),
                                        //       child: SvgPicture.asset(
                                        //         "assets/icons/dot.svg",
                                        //         width: 5,
                                        //         color: Colors.black,
                                        //       ),
                                        //     ),
                                        //     SizedBox(
                                        //         width: DeviceDimensions
                                        //                 .screenWidth(context) *
                                        //             0.015),
                                        //     Text(
                                        //       connectionDetails.businessType,
                                        //       style: TextStyle(
                                        //           fontSize: DeviceDimensions
                                        //                   .responsiveSize(
                                        //                       context) *
                                        //               0.045,
                                        //           fontWeight: FontWeight.w600,
                                        //           fontFamily: 'Barlow-Regular'),
                                        //     ),
                                        //   ],
                                        // )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.035),
                              Padding(
                                padding: const EdgeInsets.only(left: 17.0),
                                child: Text(
                                  "Bio",
                                  style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.058,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Barlow-Bold'),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.010),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 17.0, right: 17),
                                child: Text(
                                  "${connectionDetails.bio}",
                                  style: TextStyle(
                                    color: const Color(0xFF909091),
                                    fontSize: DeviceDimensions.responsiveSize(
                                            context) *
                                        0.036,
                                    fontFamily: 'Barlow-Regular',
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.025),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 27.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: connectionDetails.isPrivate
                                    ? null
                                    : () async {
                                        UrlLauncherHelper.launchPhone(context,
                                            connectionDetails.contactNumber);
                                      },
                                child: Container(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.11,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFEFEF),
                                    border: Border.all(
                                      color: const Color(0xFFC7C7C7),
                                      width: 1.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/phoneblack.svg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.020),
                              GestureDetector(
                                onTap: connectionDetails.isPrivate
                                    ? null
                                    : () async {
                                        UrlLauncherHelper.launchEmail(
                                          context,
                                          connectionDetails.email,
                                          subject: 'Business Query',
                                          body:
                                              'Hello ${connectionDetails.firstName}, How are you?',
                                        );
                                      },
                                child: Container(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.11,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFEFEF),
                                    border: Border.all(
                                      color: const Color(0xFFC7C7C7),
                                      width: 1.5,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(11.0),
                                    child: SvgPicture.asset(
                                      "assets/icons/emailblack.svg",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.040,
                                width: DeviceDimensions.screenWidth(context) *
                                    0.25,
                                child: ElevatedButton(
                                  onPressed: connectionDetails.isPrivate
                                      ? null
                                      : () async {
                                          try {
                                            await ContactService.saveContact(
                                              fullName:
                                                  "${connectionDetails.firstName} ${connectionDetails.lastName}",
                                              phoneNumber: connectionDetails
                                                  .contactNumber,
                                              email: connectionDetails.email,
                                            );

                                            CustomSnackbar().snakBarMessage(
                                              context,
                                              kIsWeb
                                                  ? 'Contact downloaded! Open the .vcf file to import!'
                                                  : 'Contact saved successfully! Check your contacts!',
                                            );
                                          } catch (e) {
                                            CustomSnackbar().snakBarError(
                                              context,
                                              'Contact save failed: ${e.toString().replaceFirst('Exception: ', '')}',
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: Text(
                                    'Save Contact',
                                    style: TextStyle(
                                      fontSize: DeviceDimensions.responsiveSize(
                                              context) *
                                          0.028,
                                      fontFamily: 'Barlow-Regular',
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.025),
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: SizedBox(
                                  height:
                                      DeviceDimensions.screenHeight(context) *
                                          0.040,
                                  width: DeviceDimensions.screenWidth(context) *
                                      0.25,
                                  child: Consumer<ConnectionProvider>(
                                    builder: (context, provider, child) {
                                      final connection = ConnectionsModel(
                                        uid: widget.userId,
                                        firstName: connectionDetails.firstName,
                                        lastName: connectionDetails.lastName,
                                        profileImage:
                                            connectionDetails.profileImage,
                                        designation:
                                            connectionDetails.designation,
                                        companyName:
                                            connectionDetails.companyName,
                                        timestamp: Timestamp.now(),
                                      );
                                      final isAdded = provider
                                          .isInAddedConnections(connection);
                                      final bool isWeb = kIsWeb;
                                      return ElevatedButton(
                                        onPressed: isWeb
                                            ? null
                                            : () {
                                                final provider = Provider.of<
                                                        ConnectionProvider>(
                                                    context,
                                                    listen: false);

                                                if (isAdded) {
                                                  provider.removeConnection(
                                                      connection);
                                                  CustomSnackbar().snakBarError(
                                                    context,
                                                    '${connection.firstName} disconnected successfully!',
                                                  );
                                                } else {
                                                  provider.addConnection(
                                                      connection);
                                                  CustomSnackbar()
                                                      .snakBarMessage(
                                                    context,
                                                    '${connection.firstName} connected successfully!',
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isAdded
                                              ? Colors.black
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              side: BorderSide(
                                                color: isWeb
                                                    ? const Color.fromARGB(
                                                        215, 220, 217, 217)
                                                    : Colors.black,
                                                width: 1.2,
                                              )),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(
                                          isAdded ? 'Disconnect' : 'Connect',
                                          style: TextStyle(
                                            fontSize:
                                                DeviceDimensions.responsiveSize(
                                                        context) *
                                                    0.033,
                                            fontFamily: 'Barlow-Regular',
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                            color: isAdded
                                                ? Colors.white
                                                : isWeb
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                        connectionDetails.isPrivate
                            ? Container(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 50),
                                  child: Center(
                                      child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/icons/lock2.svg"),
                                      SizedBox(height: 10),
                                      Text(
                                        'Profile is Private',
                                        style: TextStyle(
                                            fontFamily: 'Barlow-Regular',
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  )),
                                ),
                              )
                            : Container(
                                width: DeviceDimensions.screenWidth(context) *
                                    0.90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.030),
                                    const Text(
                                      "All Links",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.020),
                                    if (connectionDetails.socialApps!.isEmpty)
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: Text(
                                            'No Social app added',
                                            style: TextStyle(
                                                fontFamily: 'Barlow-Regular'),
                                          ),
                                        ),
                                      )
                                    else
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: connectionDetails
                                            .socialApps?.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20,
                                          childAspectRatio: 2.1,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final platform =
                                              connectionDetails.socialApps?[
                                                  connectiondetailsprovider
                                                          .connectionDetails!
                                                          .socialApps!
                                                          .length -
                                                      1 -
                                                      index];

                                          return Row(
                                            children: [
                                              SizedBox(
                                                  width: DeviceDimensions
                                                          .screenWidth(
                                                              context) *
                                                      0.050),
                                              GestureDetector(
                                                onTap: () {
                                                  UrlLauncherHelper
                                                      .launchSocialApps(
                                                          context,
                                                          platform.profileLink +
                                                              platform
                                                                  .userName);
                                                },
                                                child: Container(
                                                  width: 54,
                                                  height: 54,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35),
                                                    color: Colors.black54,
                                                    image: DecorationImage(
                                                      image:
                                                          CachedNetworkImageProvider(
                                                        platform!.icon,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: DeviceDimensions
                                                          .screenWidth(
                                                              context) *
                                                      0.020),
                                              GestureDetector(
                                                onTap: () {
                                                  UrlLauncherHelper
                                                      .launchSocialApps(
                                                          context,
                                                          platform.profileLink +
                                                              platform
                                                                  .userName);
                                                },
                                                child: Text(
                                                  platform.name,
                                                  style: TextStyle(
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.035,
                                                    fontFamily:
                                                        'Barlow-Regular',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    SizedBox(
                                        height: DeviceDimensions.screenHeight(
                                                context) *
                                            0.025),
                                  ],
                                ),
                              ),
                        SizedBox(
                            height:
                                DeviceDimensions.screenHeight(context) * 0.030),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
