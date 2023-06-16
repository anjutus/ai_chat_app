import 'package:flutter/material.dart';
import 'package:ai_chat_app/styles/font_style.dart';
import 'package:ai_chat_app/screens/search_result.dart';
import 'package:ai_chat_app/constant/openai_key.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerDays = TextEditingController(); //Text input for no. of Days
  final TextEditingController _controllerFrom = TextEditingController(); //Text input for Origin Location
  final TextEditingController _controllerTo = TextEditingController(); //Text input for Destination Location
  Future<CTResponse?>? response;
  late OpenAI? chatGPT;
  String kids = "No Kids";
  String transport = "Road Trip";
  bool _submitted = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 6)));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getResult() async {

    String promptData ="create a ${_controllerDays.value.text} days itinerary with  mode of transport as a ${transport} from the ${_controllerFrom.value.text} to the ${_controllerTo.value.text} for a family consisting of ${kids}";

    final request = CompleteText(prompt: promptData, model: Model.textDavinci2,maxTokens:500 );

     response =  chatGPT!.onCompletion(request: request);

    setState(() {
      _submitted = true;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchResult(gptResponseData: response)));
  }

  RegExp daysValidator = RegExp("[1-9]");
  bool isANumber = true;

  void setValidator(valid) {
    setState(() {
      isANumber = valid;
    });}

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text("AI Curated Travel Itinerary", style: kTitleText),
            backgroundColor:const Color.fromRGBO(163,177, 138, 1),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                 Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Add Number of days",
                    style: kSubTitleText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      controller: _controllerDays,
                      decoration: const InputDecoration(
                        hintText: 'Enter Number of Days from 1-9 days',
                      ),
                      validator: (value){ if (value == null || value.isEmpty) {
                        return 'Can\'t be empty';
                      }
                      if (!daysValidator.hasMatch(value)) {
                        return 'Please Enter Number of Days from 1-9 days';
                      }
                      return null;
                      },
                      autovalidateMode: _submitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Planning trip with kids or without",
                    style: kSubTitleText,
                  ),
                ),
                RadioListTile(
                  title: const Text("Kids"),
                  value: "Kids",
                  groupValue: kids,
                  onChanged: (value) {
                    setState(() {
                      kids = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("No Kids"),
                  value: "No Kids",
                  groupValue: kids,
                  onChanged: (value) {
                    setState(() {
                      kids = value.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Mode of transport",
                    style: kSubTitleText,
                  ),
                ),
                RadioListTile(
                  title: const Text("Flight"),
                  value: "Flight",
                  groupValue: transport,
                  onChanged: (value) {
                    setState(() {
                      transport = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("Road Trip"),
                  value: "Road Trip",
                  groupValue: transport,
                  onChanged: (value) {
                    setState(() {
                      transport = value.toString();
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Tell us city you want to visit",
                    style: kSubTitleText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: TextFormField(
                    controller: _controllerFrom,
                    decoration: const InputDecoration(
                      hintText: 'Enter an Origin',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter place';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: TextFormField(
                    controller: _controllerTo,
                    decoration: const InputDecoration(
                      hintText: 'Enter the Destination',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter place';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    style: ButtonStyle( padding: MaterialStateProperty.all(const EdgeInsets.all(10)),shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ), ),
                    onPressed: () => getResult(),
                    child: const Center(child: Text("Submit")),
                  ),
                ),
              ],
            )),
          ));
    }
  }
