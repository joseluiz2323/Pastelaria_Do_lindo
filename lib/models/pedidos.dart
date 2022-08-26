import 'package:flutter/src/material/list_tile.dart';

class Pedidos {
  final String cliente;
  final DateTime data;
  final String mesa;
  final List<ProdutoPedido> produtos;
  final int finalizado;
  final List<ProdutoPedido> produtosAdicionais;

  Pedidos({
    required this.cliente,
    required this.data,
    required this.mesa,
    required this.produtos,
    required this.finalizado,
    required this.produtosAdicionais,
  });

  double get total =>
      produtos.fold(0, (total, produto) => total + produto.total);
  double get totalAdicionais =>
      produtosAdicionais.fold(0, (total, produto) => total + produto.total);

  factory Pedidos.fromJson(Map<String, dynamic> json) {
    final data = DateTime.parse(json['data'] as String);
    return Pedidos(
      cliente: json['cliente'] as String,
      data: data.isUtc ? data.toLocal() : data,
      mesa: json['mesa'] as String,
      produtosAdicionais: (json['produtosAdicionais'] as List<dynamic>)
          .map((produto) =>
              ProdutoPedido.fromJson(produto as Map<String, dynamic>))
          .toList(),
      produtos: (json['produtos'] as List<dynamic>)
          .map((produto) =>
              ProdutoPedido.fromJson(produto as Map<String, dynamic>))
          .toList(),
      finalizado: json['finalizado'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente': cliente,
      'data': data.toUtc().toIso8601String(),
      'mesa': mesa,
      'produtos': produtos.map((p) => p.toJson()).toList(),
      'finalizado': finalizado,
      'produtosAdicionais': produtosAdicionais.map((p) => p.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJsonadd() {
    return {
      'finalizado': finalizado,
      'produtos': produtos.map((p) => p.toJson()).toList(),
      'produtosAdicionais': produtosAdicionais.map((p) => p.toJson()).toList(),
    };
  }
}

class ProdutoPedido {
  final String nome;
  final double qtde;
  final double unitario;

  ProdutoPedido({
    required this.nome,
    required this.qtde,
    required this.unitario,
  });

  double get total => qtde * unitario;

  factory ProdutoPedido.fromJson(Map<String, dynamic> json) {
    return ProdutoPedido(
      nome: json['nome'] as String,
      qtde: double.parse(json['qtde'].toString()),
      unitario: double.parse(json['unitario'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'qtde': qtde,
      'unitario': unitario,
      
    };
  }

  map(ListTile Function(dynamic p) param0) {}
}