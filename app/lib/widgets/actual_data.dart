// import 'package:flutter/material.dart';
// import 'package:yantra_blackspace/services/api_services.dart';
// import '../models/solar_data.dart';

// class ActualData extends StatefulWidget {
//   @override
//   _ActualDataState createState() => _ActualDataState();
// }

// class _ActualDataState extends State<ActualData> {
//   SolarData? solarData;
//   final ApiService apiService = ApiService();

//   @override
//   void initState() {
//     super.initState();
//     fetchSolarData();
//   }

//   Future<void> fetchSolarData() async {
//     final data = await apiService.fetchSolarData();
//     setState(() {
//       solarData = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Solar Panel Data')),
//       body: solarData != null
//           ? ListView.builder(
//               itemCount: solarData!.data.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title:
//                       Text('Row $index: ${solarData!.data[index].join(', ')}'),
//                 );
//               },
//             )
//           : Center(child: CircularProgressIndicator()),
//     );
//   }
// }
