import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/response/Status.dart';
import '../viewmodel/currency_viewmodel.dart';
import '../viewmodel/favouirte_viewmodel.dart';
import '../widgets/drawer.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String? selectedCurrencyCode;
  bool showFavorites = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CurrencyViewModel>(context, listen: false)
          .fetchMoviesListApi();
      Provider.of<FavoriteCurrenciesViewModel>(context, listen: false)
          .fetchFavorites();
    });
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
      final currencyprovider =
      Provider.of<CurrencyViewModel>(context, listen: false);
      if (currencyprovider.currencyList.status != Status.completed ||
          currencyprovider.currencyList.data == null ||
          currencyprovider.currencyList.data!.isEmpty) {
        await currencyprovider.fetchMoviesListApi();
      }
      List<String> sourceList =
          currencyprovider.currencyList.data?.map((e) => e.code).toList() ?? [];
      return sourceList
          .where((code) => code.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyViewModel = context.watch<CurrencyViewModel>();
    final favoritesVM = context.watch<FavoriteCurrenciesViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Favorite Currencies",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      drawer: MyAppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown
            if (currencyViewModel.currencyList.status == Status.loading)
              const CircularProgressIndicator()
            else if (currencyViewModel.currencyList.status == Status.error)
              Text(
                'Error: ${currencyViewModel.currencyList.message}',
                style: const TextStyle(color: Colors.red),
              )
            else
              DropdownSearch<String>(
                selectedItem: selectedCurrencyCode,
                items: (f, cs) async => getCurrencyList(context, f),
                popupProps: const PopupProps.menu(
                  showSearchBox: true,
                ),
                decoratorProps: const DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select Currency",
                    border: OutlineInputBorder(),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedCurrencyCode = value;
                  });
                },
              ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add to Favorites"),
              onPressed: selectedCurrencyCode == null
                  ? null
                  : () async {
                await favoritesVM.addFavorite(selectedCurrencyCode!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                    Text('$selectedCurrencyCode added to favorites'),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Favorites list
            Expanded(
              child: Builder(builder: (_) {
                final response = favoritesVM.favoriteCurrenciesResponse;

                if (response.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (response.status == Status.error) {
                  return Center(
                    child: Text(
                      'Error: ${response.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final favoriteCurrencies = response.data ?? [];
                if (favoriteCurrencies.isEmpty) {
                  return const Center(
                    child: Text("You have no favorite currencies"),
                  );
                }

                return ListView.builder(
                  itemCount: favoriteCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = favoriteCurrencies[index];
                    return ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text(currency),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await favoritesVM.removeFavorite(currency);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$currency removed from favorites'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
