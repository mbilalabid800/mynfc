import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nfc_app/constants/appColors.dart';
import 'package:nfc_app/provider/connection_provider.dart';
import 'package:nfc_app/responsive/device_dimensions.dart';
import 'package:nfc_app/widgets/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';

class ConnectionsRequest extends StatelessWidget {
  const ConnectionsRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: const CustomAppBar(title: "Connection Requests"),
        body: Consumer<ConnectionProvider>(
          builder: (context, connectionProvider, child) {
            final connectionRequests =
                connectionProvider.recommendedConnections;
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Container(
                      width: DeviceDimensions.screenWidth(context) * 0.92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: connectionRequests.isEmpty
                          ? _buildNoConnectionsPlaceholder()
                          : _buildConnectionList(context, connectionRequests),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Widget to display when no connection requests are available
  Widget _buildNoConnectionsPlaceholder() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          'No Connection Requests',
          style: TextStyle(fontFamily: 'Barlow-Regular'),
        ),
      ),
    );
  }

  /// Widget to build the list of connection requests
  Widget _buildConnectionList(
      BuildContext context, List<dynamic> connectionRequests) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: connectionRequests.length,
      itemBuilder: (context, index) {
        final connection = connectionRequests[index];
        return _buildConnectionTile(context, connection);
      },
    );
  }

  /// Widget to build each connection request tile
  Widget _buildConnectionTile(BuildContext context, dynamic connection) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: ListTile(
          leading: _buildProfileImage(connection.profileImage),
          title: Text(
            "${connection.firstName} ${connection.lastName}",
            style: TextStyle(
              fontSize: DeviceDimensions.responsiveSize(context) * 0.040,
              fontFamily: 'Barlow-Bold',
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: _buildConnectionDetails(context, connection),
        ),
      ),
    );
  }

  /// Widget to build the profile image
  Widget _buildProfileImage(String profileImageUrl) {
    final defaultImage =
        'https://firebasestorage.googleapis.com/v0/b/nfc-project-21b56.appspot.com/o/default_profile.jpg?alt=media&token=dec3b09a-d6fd-47a2-ae5b-cb0e248ae21c';
    return Container(
      width: 56,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: AppColors.appBlueColor,
        image: DecorationImage(
          image: CachedNetworkImageProvider(
              profileImageUrl.isNotEmpty ? profileImageUrl : defaultImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// Widget to build connection details and actions
  Widget _buildConnectionDetails(BuildContext context, dynamic connection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildConnectionInfo(context, connection),
        SizedBox(height: DeviceDimensions.screenHeight(context) * 0.010),
        _buildActionButtons(context),
      ],
    );
  }

  /// Widget to display connection info
  Widget _buildConnectionInfo(BuildContext context, dynamic connection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${connection.designation} at ${connection.companyName}",
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.037,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "23h", // Placeholder for time; replace with actual data if available
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.035,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Widget to build action buttons (Confirm and Cancel)
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildActionButton(
          context,
          label: "Confirm",
          backgroundColor: AppColors.appBlueColor,
          textColor: Colors.white,
          onPressed: () {
            // Add confirm action here
          },
        ),
        SizedBox(width: DeviceDimensions.screenWidth(context) * 0.054),
        _buildActionButton(
          context,
          label: "Cancel",
          backgroundColor: Colors.white,
          textColor: AppColors.appBlueColor,
          borderColor: AppColors.appBlueColor,
          onPressed: () {
            // Add cancel action here
          },
        ),
      ],
    );
  }

  /// Helper function to build individual action buttons
  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: DeviceDimensions.screenHeight(context) * 0.040,
      width: DeviceDimensions.screenWidth(context) * 0.25,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: DeviceDimensions.responsiveSize(context) * 0.038,
            fontFamily: 'Barlow-Regular',
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
