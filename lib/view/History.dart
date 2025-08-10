import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../viewmodel/History_viewmodel.dart';
import '../widgets/drawer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ConversionHistoryViewModel>(context, listen: false)
          .fetchHistory(showLoading: false);
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ConversionHistoryViewModel>(context);
    final data = viewModel.history;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Conversion History',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            if (data.isNotEmpty)
              IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.delete_forever),
                  tooltip: 'Clear History',
                  onPressed: () async {
                    final viewModel =
                    context.read<ConversionHistoryViewModel>();
                    await viewModel.clearHistory();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('History cleared')),
                    );
                  }),
          ],
        ),
        drawer: MyAppDrawer(),
        body: viewModel.history.isEmpty
            ? const Center(child: Text('No history available'))
            : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color white
                    borderRadius:
                    BorderRadius.circular(12), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                        Colors.black.withOpacity(0.05), // Soft shadow
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${formatDate(item.date)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("from",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff444343))),
                                Text("${item.fromCurrency} ",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                Text("${item.amount}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff444343))),
                              ],
                            ),

                            Icon(Icons.arrow_forward),

                            // To currency column
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("to",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff444343))),
                                Text("${item.toCurrency}",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                Text(" ${item.result.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xff444343))),
                              ],
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                              'Rate: 1 ${item.fromCurrency} = ${item.rate} ${item.toCurrency}',
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff444343))),
                        ),
                      ] // Example history list
                  ));
            }));
  }
}
