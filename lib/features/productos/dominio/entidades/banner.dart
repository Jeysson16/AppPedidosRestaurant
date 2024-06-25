
class BannerOfertas{
  final String? id;
  final String titulo;
  final String? url;
  final String? categoriaId;
  final String? productoId;
  final bool esProducto;

  BannerOfertas({
    this.id,
    required this.titulo,
    this.url,
    this.categoriaId,
    this.productoId,
    required this.esProducto,
  });

  factory BannerOfertas.fromJson(Map<String, dynamic> json) {
    return BannerOfertas(
      id: json['id'],
      titulo: json['titulo'],
      url: json['url'],
      categoriaId: json['categoriaId'],
      productoId: json['productoId'],
      esProducto: json['esProducto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'url': url,
      'categoriaId': categoriaId,
      'productoId': productoId,
      'esProducto': esProducto,
    };
  }

  BannerOfertas copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    String? url,
    String? categoriaId,
    String? productoId,
    bool? esProducto,
  }) {
    return BannerOfertas(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      url: url ?? this.url,
      categoriaId: categoriaId ?? this.categoriaId,
      productoId: productoId ?? this.productoId,
      esProducto: esProducto ?? this.esProducto,
    );
  } 
}