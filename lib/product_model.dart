class Product{
  final String id , name, photo;

  Product({
    required this.id,
    required this.name,
    required this.photo,
});
  factory Product.formJson(Map<String, dynamic>jsno){
    return Product(
        id: jsno['id'],
        name: jsno['name'],
        photo: jsno['photo']
    );
  }
}