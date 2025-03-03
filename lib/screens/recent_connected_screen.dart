import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/provider/user_info_form_state_provider.dart';
import 'package:nfc_app/screens/connection_profile_preview_screen.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_loader_widget.dart';
import 'package:nfc_app/shared/common_widgets/custom_snackbar_widget.dart';

import 'package:provider/provider.dart';
import '../responsive/device_dimensions.dart';

class RecentConnected extends StatefulWidget {
  const RecentConnected({super.key});

  @override
  State<RecentConnected> createState() => _RecentConnectedState();
}

class _RecentConnectedState extends State<RecentConnected> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.clear();
      Provider.of<ConnectionProvider>(context, listen: false).resetSearch();
      Provider.of<ConnectionProvider>(context, listen: false)
          .loadRecommendedConnections();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: Column(
          children: [
            SizedBox(
              height: DeviceDimensions.screenHeight(context) * 0.0001,
            ),
            AbsherAppBar3(
              title: 'Connections',
              onLeftButtonTap: () {
                Navigator.pop(context);
              },
              rightButton: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    width: DeviceDimensions.screenWidth(context) * 0.035),
              ),
            ),
            SizedBox(height: DeviceDimensions.screenHeight(context) * 0.020),
            Flexible(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (query) {
                                      Provider.of<ConnectionProvider>(context,
                                              listen: false)
                                          .searchConnections(query);
                                      if (query.isEmpty) {
                                        Provider.of<ConnectionProvider>(context,
                                                listen: false)
                                            .resetSearch();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: SvgPicture.asset(
                                            "assets/icons/search.svg"),
                                      ),
                                      hintText: "Search links",
                                      filled: true,
                                      fillColor: const Color(0xFFF0F3F5),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 2),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          searchController
                                              .clear(); // Clear search bar
                                          Provider.of<ConnectionProvider>(
                                                  context,
                                                  listen: false)
                                              .resetSearch(); // Reset search results
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //const SizedBox(width: 10),
                              // SvgPicture.asset(
                              //   "assets/icons/filter.svg",
                              //   height: 42,
                              //   width: 42,
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.020),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: DeviceDimensions.screenWidth(context) * 0.92,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Consumer<ConnectionProvider>(
                                  builder:
                                      (context, connectionProvider, child) {
                                    final addedConnections = connectionProvider
                                            .searchAddedConnections.isNotEmpty
                                        ? connectionProvider
                                            .searchAddedConnections
                                        : connectionProvider.addedConnections;
                                    if (addedConnections.isEmpty) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 30),
                                        child: Center(
                                          child: Text(
                                            'No Connections are added',
                                            style: TextStyle(
                                                fontFamily: 'Barlow-Regular'),
                                          ),
                                        ),
                                      );
                                    }

                                    if (connectionProvider.isSearchEmpty) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 40),
                                        child: Center(
                                          child: Text(
                                            'Connection not found',
                                            style: TextStyle(
                                                fontFamily: 'Barlow-Regular'),
                                          ),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: addedConnections.length < 4
                                          ? addedConnections.length
                                          : 4,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final reversedConnections =
                                            addedConnections.reversed.toList();
                                        final addedConnection =
                                            reversedConnections[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              // Navigator.pushNamed(context, '/profile',
                                              //     arguments: addedConnection.uid);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConnectionProfilePreview(
                                                          userId:
                                                              addedConnection
                                                                  .uid),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -1),
                                              leading: Container(
                                                width: 41,
                                                height: 41,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  color: Colors.black54,
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        addedConnection
                                                                .profileImage
                                                                .isNotEmpty
                                                            ? addedConnection
                                                                .profileImage
                                                            : 'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/default_profile.jpg?alt=media&token=dec3b09a-d6fd-47a2-ae5b-cb0e248ae21c'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                "${addedConnection.firstName} ${addedConnection.lastName}",
                                                style: TextStyle(
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.040,
                                                    fontFamily:
                                                        'Barlow-Regular',
                                                    color:
                                                        AppColors.textColorBlue,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              subtitle: Text(
                                                addedConnection.designation,
                                                style: TextStyle(
                                                    fontSize: DeviceDimensions
                                                            .responsiveSize(
                                                                context) *
                                                        0.032,
                                                    fontFamily:
                                                        'Barlow-Regular',
                                                    color: const Color(
                                                        0xFF909091)),
                                              ),
                                              trailing: SvgPicture.asset(
                                                  "assets/icons/more.svg",
                                                  height: 17),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.038),
                              ],
                            ),
                          ),
                          Positioned(
                            left:
                                DeviceDimensions.screenWidth(context) / 2 - 48,
                            bottom:
                                0, // Set bottom to 0 to keep it within bounds
                            child: Transform.translate(
                              offset: Offset(0, 20), // Adjust offset as needed
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/recent-connected-list');
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: SvgPicture.asset(
                                  "assets/icons/more2.svg",
                                  height: 70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      Container(
                        width: DeviceDimensions.screenWidth(context) * 0.92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 17, top: 15, bottom: 5),
                                  child: Text(
                                    "Recommended for you",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColorBlue,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 25),
                                  child: SizedBox(
                                    height: 33,
                                    width: 45,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Consumer2<ConnectionProvider,
                                          UserInfoFormStateProvider>(
                                        builder: (context, connectionProvider,
                                            userProvider, child) {
                                          return Switch(
                                            activeColor: Colors.white,
                                            activeTrackColor:
                                                AppColors.appOrangeColor,
                                            inactiveTrackColor:
                                                const Color(0xFFEFEFEF),
                                            inactiveThumbColor:
                                                AppColors.appBlueColor,
                                            value:
                                                userProvider.connectionTypeAll,
                                            onChanged: (value) async {
                                              await connectionProvider
                                                  .toggleConnections(
                                                      context, value);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Consumer<ConnectionProvider>(
                              builder: (context, connectionProvider, child) {
                                if (connectionProvider.isLoading) {
                                  return SizedBox(
                                    height:
                                        DeviceDimensions.screenHeight(context) *
                                            0.25,
                                    width:
                                        DeviceDimensions.screenWidth(context) *
                                            0.92,
                                    child: ConnectionLoader(),
                                  );
                                }
                                final recommendedConnections =
                                    connectionProvider
                                            .searchRecommendedConnections
                                            .isNotEmpty
                                        ? connectionProvider
                                            .searchRecommendedConnections
                                        : connectionProvider
                                            .recommendedConnections;
                                if (recommendedConnections.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 80),
                                    child: Center(
                                      child: Text(
                                        'No more Connections are available',
                                        style: TextStyle(
                                            fontFamily: 'Barlow-Regular'),
                                      ),
                                    ),
                                  );
                                }

                                if (connectionProvider.isSearchEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40),
                                    child: Center(
                                      child: Text(
                                        'Connection not found',
                                        style: TextStyle(
                                            fontFamily: 'Barlow-Regular'),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recommendedConnections.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final reversedConnections =
                                        recommendedConnections.reversed
                                            .toList();

                                    final recommendedConnection =
                                        reversedConnections[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          CustomSnackbar().snakBarError(context,
                                              "Kindly add this person as connection to view Profile");
                                        },
                                        child: ListTile(
                                          visualDensity:
                                              const VisualDensity(vertical: -3),
                                          leading: Container(
                                            width: 41,
                                            height: 41,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color: Colors.black54,
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        recommendedConnection
                                                            .profileImage),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "${recommendedConnection.firstName} ${recommendedConnection.lastName}",
                                            style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.040,
                                                fontFamily: 'Barlow-Regular',
                                                color: AppColors.textColorBlue,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            recommendedConnection.designation,
                                            style: TextStyle(
                                                fontSize: DeviceDimensions
                                                        .responsiveSize(
                                                            context) *
                                                    0.032,
                                                fontFamily: 'Barlow-Regular',
                                                color: const Color(0xFF909091)),
                                          ),
                                          trailing: IconButton(
                                            onPressed: () async {
                                              connectionProvider.addConnection(
                                                  recommendedConnection);
                                              CustomSnackbar().snakBarMessage(
                                                  context,
                                                  '${recommendedConnection.firstName} added successfully!');
                                            },
                                            icon: SvgPicture.asset(
                                                "assets/icons/addconnections.svg",
                                                height: 28),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            SizedBox(
                                height: DeviceDimensions.screenHeight(context) *
                                    0.010),
                          ],
                        ),
                      ),
                      SizedBox(
                          height:
                              DeviceDimensions.screenHeight(context) * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
