import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:majrekar_app/model/DataModel.dart';

class VoterItem extends StatelessWidget {
  final EDetails actor;

  const VoterItem({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${actor.lnEnglish} ${actor.fnEnglish}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${actor.lnMarathi} ${actor.fnMarathi}',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
      );

  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('no voter is found with this name'),
      ],
    );
  }
}