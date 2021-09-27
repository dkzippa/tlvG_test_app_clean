import 'package:app_01/widgets/cosmonaut_animation.dart';
import 'package:app_01/widgets/missions_list.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';

class PageSearch extends StatefulWidget {
  const PageSearch({Key? key}) : super(key: key);

  @override
  _PageSearchState createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  final _searchInputController = TextEditingController();
  final GlobalKey<FormState> _searchFormKey = GlobalKey<FormState>();
  String? inputError;

  @override
  void initState() {
    super.initState();

    _searchInputController.addListener(() {
      if (_searchInputController.text.length > 0 && _searchInputController.text.length <= AppConfig.minTextLength) {
        setState(() {
          inputError = 'Please type correct mission name, (min $AppConfig.minTextLength symbols)';
        });
      } else {
        setState(() {
          inputError = '';
        });
      }
    });
  }

  @override
  void dispose() {
    _searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image(image: AssetImage('assets/images/spacex.png'), width: MediaQuery.of(context).size.width * 0.6),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: (inputError == '' || inputError == null) ? Theme.of(context).cardColor : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Form(
                        key: _searchFormKey,
                        child: TextFormField(
                          controller: _searchInputController,
                          maxLines: 1,
                          obscureText: false,
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.continueAction,
                          autofocus: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Search missions by name',
                            hintStyle: TextStyle(fontSize: 18, decorationThickness: 0.0, height: 1),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    if (_searchInputController.text.isNotEmpty) ...[
                      TextButton(
                        onPressed: () {
                          _searchInputController.clear();
                          Focus.of(context).unfocus();
                        },
                        child: Icon(Icons.clear, color: Colors.redAccent, size: 30.0),
                        style: TextButton.styleFrom(shape: CircleBorder(), primary: Theme.of(context).cardColor),
                      )
                    ] else ...[
                      SizedBox(height: 48.0),
                    ],
                  ],
                ),
              ),
              (_searchInputController.text.length > AppConfig.minTextLength)
                  ? MissionsList(searchStr: _searchInputController.text)
                  : Center(
                      child: Column(
                      children: [
                        Text(inputError ?? '', style: TextStyle(color: Colors.redAccent, fontSize: 14.0)),
                        CosmonautAnimation(),
                      ],
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
