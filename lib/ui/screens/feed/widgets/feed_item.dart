import 'package:flutter/material.dart';

import 'package:svuce_app/core/models/feed/feed.dart';
import 'package:svuce_app/core/utils/date_utils.dart';
import 'package:svuce_app/core/utils/ui_helpers.dart';

class FeedItem extends StatelessWidget {
  final Feed feed;
  final UiHelpers uiHelpers;
  const FeedItem({Key key, this.feed, this.uiHelpers}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final newLine = TextSpan(text: "\n");

    return Container(
      decoration: BoxDecoration(
          color: uiHelpers.surfaceColor,
          borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: uiHelpers.textSecondaryColor,
                ),
                color: uiHelpers.backgroundColor,
                itemBuilder: (_) => [
                  PopupMenuItem(child: Text("Update", style: uiHelpers.body)),
                  PopupMenuItem(child: Text("Delete", style: uiHelpers.body))
                ],
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
              subtitle: Text.rich(
                TextSpan(
                    text: feed?.title ?? "Here comes the title of the article",
                    style: uiHelpers.title
                        .apply(color: uiHelpers.textPrimaryColor)),
              ),
              title: Text.rich(
                TextSpan(
                    text: feed?.category ?? "Category Here..",
                    style: TextStyle(color: uiHelpers.primaryColor)),
              ),
            ),
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: feed?.description ??
                      "Lorem ipsum dolor sit amet, cohorizontalSpaceLow,nsectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
                  style: uiHelpers.body
                      .apply(color: uiHelpers.textSecondaryColor)),
            ])),
            uiHelpers.verticalSpaceLow,
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 30,
                    height: 30,
                    child: feed.profileImg != null
                        ? FadeInImage(
                            imageErrorBuilder: (_, __, ___) =>
                                Image.asset("assets/images/boy1.png"),
                            placeholder: AssetImage("assets/images/boy1.png"),
                            image: NetworkImage(feed.profileImg))
                        : Image.asset("assets/images/boy1.png"),
                  ),
                ),
                uiHelpers.horizontalSpaceLow,
                Text.rich(TextSpan(
                    style: TextStyle(color: uiHelpers.textPrimaryColor),
                    children: [
                      TextSpan(
                        text: feed?.fullName ?? "User Name",
                      ),
                      TextSpan(text: " | ", style: uiHelpers.body),
                      TextSpan(
                        text: DateTimeUtils()
                                .timeAgoSinceDate(DateTime.parse(feed.timeStamp)
                                    .millisecondsSinceEpoch)
                                ?.toString() ??
                            "10 mins ago",
                      ),
                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
