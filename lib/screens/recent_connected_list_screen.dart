import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_app/chat/chat_screen2.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/screens/connection_profile_preview_screen.dart';
import 'package:nfc_app/shared/common_widgets/custom_app_bar_widget.dart';

import 'package:provider/provider.dart';
import '../responsive/device_dimensions.dart';

class RecentConnectedList extends StatefulWidget {
  const RecentConnectedList({super.key});

  @override
  State<RecentConnectedList> createState() => _RecentConnectedListState();
}

class _RecentConnectedListState extends State<RecentConnectedList> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.clear();
      Provider.of<ConnectionProvider>(context, listen: false).resetSearch();
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
        // appBar: AbsherAppBar(title: 'Recent Connections'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SizedBox(
                  height: DeviceDimensions.screenHeight(context) * 0.0001,
                ),
                AbsherAppBar3(
                  title: 'Recent Connected',
                  onLeftButtonTap: () {
                    Provider.of<ConnectionProvider>(context, listen: false)
                        .resetSearch();
                    Navigator.pop(context);
                  },
                  rightButton: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                        width: DeviceDimensions.screenWidth(context) * 0.035),
                  ),
                ),
                SizedBox(
                    height: DeviceDimensions.screenHeight(context) * 0.020),
                Flexible(
                  child: Container(
                    // height: DeviceDimensions.screenHeight(context) * 0.85,
                    width: DeviceDimensions.screenWidth(context) * 0.92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
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
                                          "assets/icons/search.svg",
                                        ),
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
                              // const SizedBox(width: 10),
                              // SvgPicture.asset(
                              //   "assets/icons/filter.svg",
                              //   height: 42,
                              //   width: 42,
                              // ),
                            ],
                          ),
                        ),
                        Consumer<ConnectionProvider>(
                          builder: (context, connectionProvider, child) {
                            final addedConnections = connectionProvider
                                    .searchAddedConnections.isNotEmpty
                                ? connectionProvider.searchAddedConnections
                                : connectionProvider.addedConnections;
                            if (addedConnections.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    'No Connections are added',
                                    style:
                                        TextStyle(fontFamily: 'Barlow-Regular'),
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
                                    style:
                                        TextStyle(fontFamily: 'Barlow-Regular'),
                                  ),
                                ),
                              );
                            }

                            return Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: addedConnections.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final reversedConnections =
                                      addedConnections.reversed.toList();
                                  final connection = reversedConnections[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigator.pushNamed(context, '/profile',
                                        //     arguments: connection.uid);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConnectionProfilePreview(
                                                    userId: connection.uid),
                                          ),
                                        );
                                      },
                                      child: ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: -1),
                                        leading: Container(
                                          width: 41,
                                          height: 41,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            color: Colors.black54,
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  connection.profileImage
                                                          .isNotEmpty
                                                      ? connection.profileImage
                                                      : 'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/default_profile.jpg?alt=media&token=dec3b09a-d6fd-47a2-ae5b-cb0e248ae21c'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          "${connection.firstName} ${connection.lastName}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textColorBlue,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        subtitle: Text(
                                          connection.designation,
                                          style: const TextStyle(
                                              fontSize: 11.50,
                                              color: Color(0xFF909091)),
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            // Navigator.pushNamed(
                                            //   context,
                                            //   '/chat-screen2',
                                            // );
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Chatting(
                                                          userId:
                                                              connection.uid,
                                                          userName:
                                                              "${connection.firstName} ${connection.lastName}",
                                                          profileImage:
                                                              connection
                                                                  .profileImage,
                                                        )));
                                          },
                                          child: SvgPicture.asset(
                                              "assets/icons/chat.svg",
                                              height: 28),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
