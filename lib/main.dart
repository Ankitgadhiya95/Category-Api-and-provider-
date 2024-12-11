import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => DataProvider())],
      child: Builder(builder: (context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedCategory = 'All';
  double selectedRating = 0.0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<DataProvider>(context, listen: false);
    provider.getPostData(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DataProvider>(context);

    // Fetch categories dynamically
    final categories = provider.histList?.products
        .map((product) => product.category.name)
        .toSet()
        .toList() ??
        [];

    final filteredProducts = provider.histList?.products
        .where((product) =>
    (selectedCategory == 'All' ||
        product.category.name.toLowerCase() ==
            selectedCategory!.toLowerCase()) &&
        product.rating >= selectedRating)
        .toList() ??
        [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.histList == null
          ? const Center(child: Text("No data available"))
          : Column(
        children: [
          // Filters Row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Category Filter
                Row(
                  children: [
                    const Text(
                      "Category:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 2),
                    DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      items: ['All', ...categories]
                          .map((category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category[0].toUpperCase() +
                              category.substring(1),
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                // Rating Filter
                Row(
                  children: [
                    const Text(
                      "Rating:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 7),
                    DropdownButton<double>(
                      value: selectedRating,
                      onChanged: (value) {
                        setState(() {
                          selectedRating = value!;
                        });
                      },
                      items: [0.0, 3.0, 4.0, 4.5]
                          .map((rating) => DropdownMenuItem<double>(
                        value: rating,
                        child: Text(rating == 0.0
                            ? "All"
                            : "$rating+ ⭐"),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Products GridView
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.71,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        product.images.isNotEmpty
                            ? product.images.first
                            : 'https://via.placeholder.com/150',
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Price: \$${product.price}",
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rating: ${product.rating} ⭐",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.orange),
                      ),
                      Text(
                        "Category: ${product.category.name}",
                        style: const TextStyle(
                            fontSize: 12, color: Colors.blue),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
