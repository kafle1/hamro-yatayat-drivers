import 'package:flutter/material.dart';

class BiddingHistoryCards extends StatelessWidget {
  const BiddingHistoryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (context, _) => SizedBox(
          width: 10,
        ),
        itemBuilder: (context, index) => BuildCard(),
      ),
    );
  }
}

class BuildCard extends StatelessWidget {
  const BuildCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}
