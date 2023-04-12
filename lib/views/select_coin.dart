import 'dart:convert';

import 'package:crypto_app/models/chart_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class SelectCoin extends StatefulWidget {
  final dynamic selectItem;
  const SelectCoin({
    super.key,
    this.selectItem,
  });

  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: myWidth * 0.05,
                vertical: myHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.network(
                        widget.selectItem.image,
                        height: myHeight * 0.08,
                      ),
                      SizedBox(
                        width: myWidth * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.selectItem.id,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            widget.selectItem.symbol,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: myWidth * 0.02,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$ ${widget.selectItem.currentPrice}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${widget.selectItem.marketCapChangePercentage24H}%',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              widget.selectItem.marketCapChangePercentage24H >=
                                      0
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: myWidth * 0.05,
                vertical: myHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Low',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Text(
                        '\$${widget.selectItem.low24H}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'High',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Text(
                        '\$${widget.selectItem.high24H}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Vol',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.01,
                      ),
                      Text(
                        '\$${widget.selectItem.totalVolume}',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.01,
            ),
            SizedBox(
              height: myHeight * 0.4,
              child: isRefresh == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.black26,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xffFBC700),
                        ),
                      ),
                    )
                  : SfCartesianChart(
                      trackballBehavior: trackballBehavior,
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                        zoomMode: ZoomMode.x,
                      ),
                      series: <CandleSeries>[
                        CandleSeries<ChartModel, int>(
                          enableSolidCandles: true,
                          enableTooltip: true,
                          bullColor: Colors.green,
                          bearColor: Colors.red,
                          dataSource: itemChart,
                          xValueMapper: (ChartModel sales, _) => sales.time,
                          lowValueMapper: (ChartModel sales, _) => sales.low,
                          highValueMapper: (ChartModel sales, _) => sales.high,
                          openValueMapper: (ChartModel sales, _) => sales.open,
                          closeValueMapper: (ChartModel sales, _) =>
                              sales.close,
                          animationDuration: 55,
                        )
                      ],
                    ),
            ),
            SizedBox(
              height: myHeight * 0.01,
            ),
            Center(
              child: SizedBox(
                height: myHeight * 0.04,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: text.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          textBool = [false, false, false, false, false, false];
                          textBool[index] = true;
                        });
                        setDays(
                          text[index],
                        );
                        getChart();
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: myWidth * 0.02),
                        padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.03,
                          vertical: myHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: textBool[index] == true
                              ? const Color(0xffFBC700).withOpacity(0.3)
                              : Colors.transparent,
                        ),
                        child: Text(
                          text[index],
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: myHeight * 0.04,
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.06,
                    ),
                    child: const Text(
                      'News',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: myWidth * 0.06,
                      vertical: myHeight * 0.01,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.25,
                          child: CircleAvatar(
                            radius: myHeight * 0.04,
                            backgroundImage:
                                const AssetImage('assets/image/11.PNG'),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.1,
              width: myWidth,
              // color: Colors.amber,
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: myWidth * 0.05,
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: myHeight * 0.015),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color(0xffFBC700)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: myHeight * 0.02,
                              ),
                              const Text(
                                'Add to portfolio',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: myWidth * 0.05,
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: myHeight * 0.012,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Image.asset(
                            'assets/icons/3.1.png',
                            height: myHeight * 0.03,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: myWidth * 0.05,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  bool isRefresh = true;
  List<ChartModel> itemChart = [];
  Future<void> getChart() async {
    String url =
        '${'https://api.coingecko.com/api/v3/coins/' + widget.selectItem.id}/ohlc?vs_currency=usd&days=$days';

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    try {
      if (response.statusCode == 200) {
        Iterable x = jsonDecode(response.body);
        List<ChartModel> modelList =
            x.map((e) => ChartModel.fromJson(e)).toList();
        setState(() {
          itemChart = modelList;
        });
      }
    } catch (e) {
      rethrow;
    }

    setState(() {
      isRefresh = false;
    });
  }
}
