import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../data/response/Api_response.dart';
import '../data/response/Status.dart';
import '../model/ConversionHistoryModel.dart';
import '../model/ConversionInfo.dart';
import '../viewmodel/History_viewmodel.dart';
import '../viewmodel/currency_viewmodel.dart';
import '../viewmodel/exchange_viewmodel.dart';
import '../viewmodel/favouirte_viewmodel.dart';
import '../widgets/drawer.dart';
import '../widgets/snackbar.dart';



class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  String fromCurrency = 'USD';
  String toCurrency = 'PKR';

  List<CurrencyInfo>? currencyList;
  late CurrencyViewModel currencyProvider;
  bool showFavorites = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      currencyProvider = Provider.of<CurrencyViewModel>(context, listen: false);
      currencyProvider.fetchMoviesListApi();
    });
  }

  void convertCurrency(BuildContext context) async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      showSnackBar(context, "Please enter a valid amount", isSuccess: false);
      return;
    }

    final exchangeVM =
    Provider.of<CurrencyExchangeViewModel>(context, listen: false);
    final historyVM =
    Provider.of<ConversionHistoryViewModel>(context, listen: false);

    try {
      await exchangeVM.fetchExchangeRate(fromCurrency, toCurrency);

      final rateResponse = exchangeVM.exchangeRateResponse;

      if (rateResponse.status == Status.completed &&
          rateResponse.data != null) {
        double converted = amount * rateResponse.data!;
        exchangeVM.setamount(converted);

        ApiResponse success = await historyVM.addConversion(
          ConversionHistory(
            fromCurrency: fromCurrency,
            toCurrency: toCurrency,
            amount: amount,
            result: exchangeVM.convertedAmount!,
            rate: rateResponse.data!,
            date: DateTime.now(),
          ),
        );

        if (success.status == Status.success) {
          showSnackBar(context, "Conversion saved successfully");
        } else {
          showSnackBar(context, success.message ?? "Failed to save conversion",
              isSuccess: false);
        }
      } else if (rateResponse.status == Status.error) {
        showSnackBar(context, 'Error: ${rateResponse.message}',
            isSuccess: false);
      }
    } catch (e) {
      showSnackBar(context, "Error fetching exchange rate: $e",
          isSuccess: false);
    }
  }

  Future<List<String>> getCurrencyList(
      BuildContext context, String filter) async {
    if (showFavorites) {
      final favoritesVM =
      Provider.of<FavoriteCurrenciesViewModel>(context, listen: false);
      final favorites = favoritesVM.favoriteCurrenciesResponse.data ?? [];
      return favorites
          .where((code) => code.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } else {
      if (currencyProvider.currencyList.status != Status.completed ||
          currencyProvider.currencyList.data == null ||
          currencyProvider.currencyList.data!.isEmpty) {
        await currencyProvider.fetchMoviesListApi();
      }
      final sourceList =
          currencyProvider.currencyList.data?.map((e) => e.code).toList() ?? [];
      return sourceList
          .where((code) => code.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyViewModel>(context);
    final exchangeProvider = Provider.of<CurrencyExchangeViewModel>(context);

    final status = currencyProvider.currencyList.status;

    if (status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (status == Status.error) {
      return Center(
          child: Text(currencyProvider.currencyList.message ?? "Error"));
    } else if (status == Status.completed) {
      currencyList = currencyProvider.currencyList.data ?? [];

      if (currencyList!.isEmpty) {
        return const Center(child: Text("No currencies available"));
      }

      toCurrency = currencyProvider.tocurrency;
      fromCurrency = currencyProvider.fromcurrency;

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Currency Converter',
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        drawer: MyAppDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ToggleButtons(
                isSelected: [!showFavorites, showFavorites],
                onPressed: (index) {
                  setState(() => showFavorites = index == 1);
                },
                selectedColor: Colors.white,
                fillColor: Colors.black,
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("All Currencies")),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Favorite Currencies")),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DropdownSearch<String>(
                      selectedItem: fromCurrency,
                      items: (filter, _) => getCurrencyList(context, filter),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "From Currency...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "From Currency",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => fromCurrency = value);
                          currencyProvider.setFromCurrency(value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz, size: 30),
                    tooltip: 'Swap Currencies',
                    onPressed: () {
                      setState(() {
                        final temp = fromCurrency;
                        fromCurrency = toCurrency;
                        toCurrency = temp;

                        currencyProvider.setFromCurrency(fromCurrency);
                        currencyProvider.setToCurrency(toCurrency);
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownSearch<String>(
                      selectedItem: toCurrency,
                      items: (filter, _) => getCurrencyList(context, filter),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "To Currency...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "To Currency",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => toCurrency = value);
                          currencyProvider.setToCurrency(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Enter Amount',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'e.g. 100',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => convertCurrency(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Convert',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (exchangeProvider.exchangeRateResponse.status ==
                  Status.loading)
                const Center(child: CircularProgressIndicator()),
              if (exchangeProvider.exchangeRateResponse.status == Status.error)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Error: ${exchangeProvider.exchangeRateResponse.message}',
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (exchangeProvider.exchangeRateResponse.status ==
                  Status.completed)
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("From",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                Text(fromCurrency,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const Icon(Icons.arrow_forward, size: 32),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("To",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14)),
                                Text(toCurrency,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  exchangeProvider.convertedAmount != null
                                      ? exchangeProvider.convertedAmount!
                                      .toStringAsFixed(2)
                                      : "-",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'Rate: 1 $fromCurrency = ${exchangeProvider.exchangeRateResponse.data!.toStringAsFixed(4)} $toCurrency',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // fallback UI
    return const Center(child: CircularProgressIndicator());
  }
}
