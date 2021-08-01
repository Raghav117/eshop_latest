import 'dart:convert';

import 'package:eshop/Helper/Color.dart';
import 'package:eshop/Helper/Session.dart';
import 'package:eshop/redeemProductDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Helper/Constant.dart';
import 'Helper/String.dart';
import 'Model/Model.dart';
import 'Model/Section_Model.dart';

class Redeem extends StatefulWidget {
  const Redeem({Key key}) : super(key: key);

  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  Product p;
  getRedeemData() async {
    setState(() {
      loading = true;
    });
    Response response = await post(getRedeemProductApi, headers: headers)
        .timeout(Duration(seconds: timeOut));
    Map m = jsonDecode(response.body);
    l = m["data"];
    p = Product.fromJson(l[0]);
    print(
        "++++++++++++++++++++++++++++++++++++++++++++++++++++" + l.toString());
    setState(() {
      loading = false;
    });
  }

  bool loading;

  List l = [];

  @override
  void initState() {
    super.initState();
    getRedeemData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Redeem Now",
          style: TextStyle(color: colors.fontColor),
        ),
      ),
      body: loading == true
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                  // alignment: WrapAlignment.spaceEvenly,
                  // spacing: width * 0.1,
                  children: l.map((e) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    height: width * 0.2,
                    // width: width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: width * 0.2,
                          width: width * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              e['image'],
                              // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTT0Ei4LCBzphIoH7bDmYSOrtH1d-rquEnYZQ&usqp=CAU",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Spacer(),
                            Text(
                              e["name"],
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(),
                            ),
                            // Spacer(),
                            Text(
                              e["redeem_points"].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(
                                      color: colors.fontColor,
                                      fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            double.parse(e["redeem_points"]) >
                                    double.parse(userData["data"][0]["balance"])
                                ? Container(
                                    child: FittedBox(
                                      child: Text(
                                          "You have less \nWallet Points to Redeem.",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                                color: colors.fontColor,
                                                fontSize: 12,
                                              )),
                                    ),
                                  )
                                : MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                        return RedeemProductDetails(
                                          m: l[0],
                                          model: p,
                                        );
                                      }));
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: colors.primary,
                                    // height: 50,
                                    child: Text(
                                      "Redeem Now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              color: colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()),
            ),
    );
  }
}
