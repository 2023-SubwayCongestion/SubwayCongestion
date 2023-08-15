import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:subway_congestion/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:subway_congestion/model/model_congestion.dart';
import 'package:subway_congestion/widget/congestion_view.dart';
import 'package:subway_congestion/widget/custom_button.dart';

class CongestionDetailScreen extends StatefulWidget {
  final String subwayName;
  final String direction1;
  final String direction2;
  final firestore = FirebaseFirestore.instance;
  
  CongestionDetailScreen({
    super.key,
    required this.subwayName,
    required this.direction1,
    required this.direction2,
  });
  

  @override
  State<CongestionDetailScreen> createState() => _CongestionDetailScreenState();
}

class _CongestionDetailScreenState extends State<CongestionDetailScreen> {


  List<double> tmp1=[];
  // List<double> tmp1 = List<double>.filled(100, 0.0);



  @override
  void initState() {
    super.initState();
    fetchData();
  }
  List<List<DocumentSnapshot>> splitDocumentsByWeekday(List<DocumentSnapshot> documents) {
    List<DocumentSnapshot> weekdays = [];
    List<DocumentSnapshot> saturday = [];
    List<DocumentSnapshot> holiday = [];

    for (DocumentSnapshot document in documents) {
      String weekday = document['요일구분'];

      if (weekday == '평일') {
        weekdays.add(document);
      } else if (weekday == '토요일') {
        saturday.add(document);
      } else if (weekday == '공휴일') {
        holiday.add(document);
      }
    }

    return [weekdays, saturday, holiday];
  }
  Future<void> fetchData() async {
    List<DocumentSnapshot> congestionDocuments = await getCongestionDocuments();

    List<List<DocumentSnapshot>> splittedDocuments = splitDocumentsByWeekday(congestionDocuments);
    List<DocumentSnapshot> weekdays = splittedDocuments[0];
    List<DocumentSnapshot> saturday = splittedDocuments[1];
    List<DocumentSnapshot> holiday = splittedDocuments[2];

// 분리된 문서 리스트를 원하는 방식으로 활용
// 예: 각 문서의 데이터에 접근, 출력 등





    for (DocumentSnapshot document in weekdays) {
      print('평일부분임');
      tmp1=[
        double.parse(document.get("6시00분").toString()),
        double.parse(document.get("6시30분").toString()),
        double.parse(document.get("7시00분").toString()),
        double.parse(document.get("7시30분").toString()),
        double.parse(document.get("8시00분").toString()),
        double.parse(document.get("8시30분").toString()),
        double.parse(document.get("9시00분").toString()),
        double.parse(document.get("9시30분").toString()),
        double.parse(document.get("10시00분").toString()),
        double.parse(document.get("10시30분").toString()),
        double.parse(document.get("11시00분").toString()),
        double.parse(document.get("11시30분").toString()),
        double.parse(document.get("12시00분").toString()),
        double.parse(document.get("12시30분").toString()),
        double.parse(document.get("13시00분").toString()),
        double.parse(document.get("13시30분").toString()),
        double.parse(document.get("14시00분").toString()),
        double.parse(document.get("14시30분").toString()),
        double.parse(document.get("15시00분").toString()),
        double.parse(document.get("15시30분").toString()),
        double.parse(document.get("16시00분").toString()),
        double.parse(document.get("16시30분").toString()),
        double.parse(document.get("17시00분").toString()),
        double.parse(document.get("17시30분").toString()),
        double.parse(document.get("18시00분").toString()),
        double.parse(document.get("18시30분").toString()),
        double.parse(document.get("19시00분").toString()),
        double.parse(document.get("19시30분").toString()),
        double.parse(document.get("20시00분").toString()),
        double.parse(document.get("20시30분").toString()),
        double.parse(document.get("21시00분").toString()),
        double.parse(document.get("21시30분").toString()),
        double.parse(document.get("22시00분").toString()),
        double.parse(document.get("22시30분").toString()),
        double.parse(document.get("23시00분").toString()),
        double.parse(document.get("23시30분").toString()),

      ];

      print(tmp1.toString());

      // print(document.data()); // 문서 데이터 출력 예시
      // print(document.get("14시00분"));
    }



    // for (DocumentSnapshot document in saturday) {
    //   print('토요일부분임');
    //   print(document.data()); // 문서 데이터 출력 예시
    // }
    //
    // for (DocumentSnapshot document in holiday) {
    //   print('공휴일부분임');
    //   print(document.data()); // 문서 데이터 출력 예시
    // }


    setState(() {

    });
  }

  List<List<dynamic>> convertTo2DList(Map<String, dynamic> data) {
    List<List<dynamic>> result = [];
    List<dynamic> keys = data.keys.toList();
    List<dynamic> values = data.values.toList();

    int length = keys.length;

    for (int i = 0; i < length; i++) {
      List<dynamic> row = [keys[i], values[i]];
      result.add(row);
    }

    return result;
  }




  Future<List<DocumentSnapshot>> getCongestionDocuments() async {
    List<DocumentSnapshot> documents = [];
    String directionName = "";
    if (widget.direction1 == '1') {
      directionName = "상선";
    }
    else {
      directionName = "하선";
    }
    if (widget.subwayName.substring(0, widget.subwayName.length - 1) ==
        "미아사거리") {
      QuerySnapshot snapshot = await widget.firestore
          .collection('2022congestion')
          .where('출발역', isEqualTo: widget.subwayName.substring(
          0, widget.subwayName.length - 1))
          .where('상하구분', isEqualTo: directionName)
          .get();
      documents = snapshot.docs;
      print("미아");
    } else {
      QuerySnapshot snapshot = await widget.firestore
          .collection('2022congestion')
          .where('출발역', isEqualTo: widget.subwayName.substring(
          0, widget.subwayName.length - 1))
          .where('상하구분', isEqualTo: directionName)
          .get();

      documents = snapshot.docs;
      print(widget.subwayName.substring(0, widget.subwayName.length - 1));

    }
    return documents;
  }



  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];bool showAvg = false;
  int _selectedWidgetIndex = 0;

  

  @override
  Widget build(BuildContext context) {

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      fetchData();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getColor('main2'),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel_outlined,
            size: 30,
          ),
          color: getColor('main1'),
          // X 버튼의 색상을 변경합니다. 원하는 색상으로 변경하세요.
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로 가기 버튼과 동일한 동작을 수행합니다.
          },
        ),
        title: Center(
          child: Text(
            widget.subwayName + ' 혼잡도 통계     ',
            style: TextStyle(
                color: getColor('main1'),
                fontWeight: FontWeight.bold,
            ),

          ),
        ),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: getColor('main2'),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            SafeArea(
              child: Column(
                children: <Widget>[
                  TextButton(
                    child: Text(
                      showAvg ? '시간대별 혼잡율 보기' : '평균 혼잡율 보기',
                      style: TextStyle(
                          color: getColor('main1'),
                          // showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
                      )),
                    onPressed: () {
                      print('click');
                      setState(() {
                        showAvg = !showAvg;
                      });
                    },
                  ),
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        color: getColor('white')),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                        child: LineChart(
                          showAvg ? avgChart() : mainChart(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Text('(단위 : %,  단위기준 : 열차 1량의 승차인원 = 160명 = 100%)'),
            // SizedBox(
            //   height: 20,
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       '< 혼잡도 수치에 따른 체감정도 >',
            //       style: TextStyle(
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     // SizedBox(height: 20),
            //     Text(
            //       '34% - 서있는 사람 없이 좌석에 모두 앉은 상태',
            //       textAlign: TextAlign.left,
            //     ),
            //     Text(
            //       '100% - 한 칸에 160명이 탑승한 상태',
            //       textAlign: TextAlign.left,
            //     ),
            //     Text(
            //       '125% - 이동시 다소 부딪힐 정도의 상태',
            //       textAlign: TextAlign.left,
            //     ),
            //     Text(
            //       '140% - 출입문 주변 혼잡, 이동시 어깨 부딪힐 정도의 상태',
            //       textAlign: TextAlign.left,
            //     ),
            //     Text(
            //       '200% 이상 - 밀착되고 숨이 막히는 수준',
            //       textAlign: TextAlign.left,
            //     ),
            //     Text(
            //       '230% - 수용 한계점',
            //       textAlign: TextAlign.left,
            //     ),
            //   ],
            // ),




          ],
        ),
      ),



    );
  }



  LineChartData mainChart() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,

        bottomTitles: AxisTitles(
          axisNameWidget: Text(
            '시간',
            style: TextStyle(
              fontSize: 10,
              // color: mainLineColor,
              fontWeight: FontWeight.bold,
              color: getColor('main1'),
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 18,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),

        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: const Text(
            '혼잡도(%)',
            style: TextStyle(
              // color: getColor('main1'),
              // color: AppColors.mainTextColor2,
            ),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 40,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),

        //오른쪽 0 50 100 150 지우기
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )
        ),

        //위쪽 0 50 100 150 지우기
        topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            )
        ),

      ),
      borderData: FlBorderData(
          show: false, //테두리선
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 6,
      maxX: 24,
      minY: 0,
      maxY: 200,

      lineBarsData: [

        LineChartBarData(
          show: true,
          spots: [
            FlSpot(6, tmp1[0]),
            FlSpot(6.5, tmp1[1]),
            FlSpot(7, tmp1[2]),
            FlSpot(7.5, tmp1[3]),
            FlSpot(8, tmp1[4]),
            FlSpot(8.5, tmp1[5]),
            FlSpot(9, tmp1[6]),
            FlSpot(9.5, tmp1[7]),
            FlSpot(10, tmp1[8]),
            FlSpot(10.5, tmp1[9]),
            FlSpot(11, tmp1[10]),
            FlSpot(11.5, tmp1[11]),
            FlSpot(12, tmp1[12]),
            FlSpot(12.5, tmp1[13]),
            FlSpot(13, tmp1[14]),
            FlSpot(13.5, tmp1[15]),
            FlSpot(14, tmp1[16]),
            FlSpot(14.5, tmp1[17]),
            FlSpot(15, tmp1[18]),
            FlSpot(15.5, tmp1[19]),
            FlSpot(16, tmp1[20]),
            FlSpot(16.5, tmp1[21]),
            FlSpot(17, tmp1[22]),
            FlSpot(17.5, tmp1[23]),
            FlSpot(18, tmp1[24]),
            FlSpot(18.5, tmp1[25]),
            FlSpot(19, tmp1[26]),
            FlSpot(19.5, tmp1[27]),
            FlSpot(20, tmp1[28]),
            FlSpot(20.5, tmp1[29]),
            FlSpot(21, tmp1[30]),
            FlSpot(21.5, tmp1[31]),
            FlSpot(22, tmp1[32]),
            FlSpot(22.5, tmp1[33]),
            FlSpot(23, tmp1[34]),
            FlSpot(23.5, tmp1[35]),
            FlSpot(24, tmp1[35]),


          ],

          isCurved: true,
          color: Color.fromRGBO(84, 162, 154, 1),
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          // belowBarData: BarAreaData(
          //   show: true,
          //   color: Colors.blue,
          // ),
        ),
      ],
    );
    }

    LineChartData avgChart() {
      return LineChartData(
        lineTouchData: LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: getColor('main1'),
              strokeWidth: 1,
            );
          },
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: getColor('main1'),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          //오른쪽 0 50 100 150 지우기
          rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              )
          ),

          //위쪽 0 50 100 150 지우기
          topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              )
          ),
          // bottomTitles: SideTitles(
          //   showTitles: true,
          //   reservedSize: 22,
          //   textStyle: const TextStyle(
          //       color: Color(0xff68737d),
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16),
          //   getTitles: (value) {
          //     switch (value.toInt()) {
          //       case 2:
          //         return 'MAR';
          //       case 5:
          //         return 'JUN';
          //       case 8:
          //         return 'SEP';
          //     }
          //     return '';
          //   },
          //   margin: 8,
          // ),
          // leftTitles: SideTitles(
          //   showTitles: true,
          //   textStyle: const TextStyle(
          //     color: Color(0xff67727d),
          //     fontWeight: FontWeight.bold,
          //     fontSize: 15,
          //   ),
          //   getTitles: (value) {
          //     switch (value.toInt()) {
          //       case 1:
          //         return '10k';
          //       case 3:
          //         return '30k';
          //       case 5:
          //         return '50k';
          //     }
          //     return '';
          //   },
          //   reservedSize: 28,
          //   margin: 12,
          // ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: getColor('main1'), width: 1)),
        minX: 6,
        maxX: 24,
        minY: 0,
        maxY: 200,

        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(6, 40),
              FlSpot(24, 40),
            ],
            isCurved: true,
            // colors: [
            //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
            //       .lerp(0.2),
            //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
            //       .lerp(0.2),
            // ],
            barWidth: 10,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(show: true,
              //     colors: [
              //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
              //       .lerp(0.2)
              //       .withOpacity(0.1),
              //   ColorTween(begin: gradientColors[0], end: gradientColors[1])
              //       .lerp(0.2)
              //       .withOpacity(0.1),
              // ]
            ),
          ),
        ],
      );
    }


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      case 12:
        text = '12';
        break;
      case 14:
        text = '14';
        break;
      case 16:
        text = '16';
        break;
      case 18:
        text = '18';
        break;
      case 20:
        text = '20';
        break;
      case 22:
        text = '22';
        break;
      case 24:
        text = '24';
        break;

      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: getColor('main1'),
          // color: mainLineColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.red,
      fontSize: 13,
    );
    String text;
    switch (value.toInt()) {
      case 50:
        text = '50';
        break;
      case 100:
        text = '100';
        break;
      case 150:
        text = '150';
        break;
      case 200:
        text = '200';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: getColor('main1'),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

  }


}
