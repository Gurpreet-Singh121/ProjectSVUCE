import 'package:flutter/material.dart';
import 'package:svuce_app/app/colors.dart';
import 'package:svuce_app/app/default_view.dart';
import 'package:svuce_app/ui/views/select_clubs/select_clubs_viewmodel.dart';
import 'package:svuce_app/ui/widgets/club_tile.dart';

class SelectClubsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilder<SelectClubsViewModel>(
      viewModel: SelectClubsViewModel(),
      onModelReady: (model) {
        model.getClubListOnce();
      },
      builder: (context, uiHelpers, model) {
        return WillPopScope(
          onWillPop: model.onWillPop,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                "Explore Clubs",
                style: uiHelpers.headline.copyWith(color: textPrimaryColor),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: model.clubs == null
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: model.clubs.length,
                    itemBuilder: (context, index) {
                      return ClubTile(
                        index: index,
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}