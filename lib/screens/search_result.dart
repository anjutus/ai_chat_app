import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:ai_chat_app/styles/font_style.dart';

class SearchResult extends StatelessWidget {
 final Future<CTResponse?>? gptResponseData;

  const SearchResult({super.key, required this.gptResponseData});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
        title: Text("AI Curated Travel Itinerary", style: kTitleText),
    backgroundColor:const Color.fromRGBO(163,177, 138, 1),
    ),
    body: FutureBuilder<CTResponse?>(
        future: gptResponseData,
        builder: (context, snapshot) {
          final text = snapshot.data?.choices.single.text;
          return Container(
             margin: const EdgeInsets.all(10.0),
             padding: const EdgeInsets.all(10.0),
              color: const Color.fromRGBO(241,250,238, 1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Your Chat GPT curated Itinerary",
                    style: kSubTitleText,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                  ,Text(
                    text ?? 'Loading...',
                    style: kSubTitleText,
                  ),
                ],))
              );}
            ));

        }
  }
