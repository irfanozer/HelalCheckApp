import 'package:flutter/material.dart';
import 'products.dart';

void main() {
  runApp(HalalCheckerApp());
}

class HalalCheckerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halal Checker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    'Candy',
    'Chocolate',
    'Ice Cream',
    'Baking Ingredients',
    'Dairy Products',
    'Meat and Poultry',
    'Seafood',
    'Fruits',
    'Bread and Bakery',
    'Pastas and Noodles',
    'Grains and Cereals',
    'Sauces and Condiments',
    'Spices and Herbs',
    'Frozen Foods',
    'Pickle and Olives',
    'Snacks and Nuts',
    'Jam and Spreads',
    'Ready-to-Eat Meals',
    'Canned Foods',
    'Oils and Fats',
    'Vegetables',
    'Fruits',
    'Restaurant Foods',
    'Juices',
    'Carbonated Drinks',
    'Supplements',
    'Coffee',
    'Tea',
    'Energy Drinks',
    'Plant-Based Milks',
    'Other'
  ];

  String? selectedCategory; // Nullable to allow "no category selected"
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = null; // categories.first; // Default category
    _filterProducts('');
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        // Show all or category-specific products if no search query is entered
        filteredProducts = selectedCategory == null
            ? products // All products
            : products
                .where((product) => product['category'] == selectedCategory)
                .toList();
      } else {
        // Filter by query and category
        filteredProducts = products.where((product) {
          final matchesQuery =
              product['name']!.toLowerCase().contains(query.toLowerCase()) ||
                  product['description']!
                      .toLowerCase()
                      .contains(query.toLowerCase());
          final matchesCategory = selectedCategory == null ||
              product['category'] == selectedCategory;
          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halal Checker',
          style: TextStyle(
            fontFamily: 'Raleway', // Replace with your preferred font
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search all products...',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Categories Section
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1, // +1 for the "All" category
              itemBuilder: (context, index) {
                final category = index == 0
                    ? 'All'
                    : categories[index - 1]; // "All" is the first item
                final isSelected = selectedCategory == null && index == 0 ||
                    selectedCategory == category; // Highlight logic

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory =
                          index == 0 ? null : category; // Null for "All"
                      searchController
                          .clear(); // Clear search bar when a category is selected
                      _filterProducts('');
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Product List Section
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              product['name']![0]
                                  .toUpperCase(), // First letter of the product name
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            product['name']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            product['description']!.length > 50
                                ? '${product['description']!.substring(0, 50)}...'
                                : product['description']!,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                          trailing:
                              Icon(Icons.arrow_forward, color: Colors.teal),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
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

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']!),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product['name']!,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  product['description']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final String category;

  ProductListScreen({required this.category});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, String>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = products
        .where((product) => product['category'] == widget.category)
        .toList();
  }

  void _filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product['category'] == widget.category &&
              product['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Products'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ),
      ),
      body: filteredProducts.isEmpty
          ? Center(
              child: Text('No products found'),
            )
          : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ListTile(
                  title: Text(product['name']!),
                  subtitle: Text(product['description']!),
                  leading: Icon(Icons.label),
                );
              },
            ),
    );
  }
}
