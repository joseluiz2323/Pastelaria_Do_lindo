import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:pastelaria/components/text_field_custom.dart';
import 'package:pastelaria/utils/extensions.dart';

import '../../models/pedidos.dart';
import '../../models/produtos.dart';

class AdicionarPedidoPage extends StatefulWidget {
  Pedidos? pedido;
  final pedidoData;
  final bool? addnovo;
  final bool? unir;
  AdicionarPedidoPage(
      {Key? key, this.pedido, this.pedidoData, this.addnovo, this.unir})
      : super(key: key);

  @override
  State<AdicionarPedidoPage> createState() => _AdicionarPedidoPageState();
}

class _AdicionarPedidoPageState extends State<AdicionarPedidoPage> {
  List<Produto> produtosPedido = [];
  List<Produto> unirProdutos = [];
  final mesaController = TextEditingController();
  final clienteController = TextEditingController();

  @override
  void initState() {
    _init();
    if (widget.unir == true) {
      unir();
    }
    super.initState();
  }

  void unir() {
    for (var produto in widget.pedido!.produtos) {
      for (var i = 1; i <= (produto.qtde.toInt()); i++) {
        unirProdutos.add(Produto(
          nome: produto.nome,
          unitario: produto.unitario,
          estoque: produto.qtde,
        ));
      }
    }
    for (var produto in widget.pedido!.produtosAdicionais) {
      for (var i = 1; i <= (produto.qtde.toInt()); i++) {
        unirProdutos.add(Produto(
          nome: produto.nome,
          unitario: produto.unitario,
          estoque: produto.qtde,
        ));
      }
    }
  }

  void _init() {
    if (widget.addnovo == true) {
      mesaController.text = widget.pedido!.mesa;
      clienteController.text = widget.pedido!.cliente;
    } else if (widget.pedido != null) {
      mesaController.text = widget.pedido!.mesa;
      clienteController.text = widget.pedido!.cliente;
      for (var produto in widget.pedido!.produtos) {
        for (var i = 1; i <= (produto.qtde.toInt()); i++) {
          produtosPedido.add(Produto(
            nome: produto.nome,
            unitario: produto.unitario,
            estoque: produto.qtde,
          ));
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Pedido'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          TextFieldCustom(
            label: 'Mesa',
            keyboardType: TextInputType.number,
            controller: mesaController,
          ),
          TextFieldCustom(
            label: 'Cliente',
            controller: clienteController,
          ),
          const Divider(height: 18),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
                  FirebaseFirestore.instance.collection('pedidos').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro ao carregar vendas'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final vendasData = snapshot.data?.docs ?? [];
                final vendas = vendasData
                    .map((doc) => Pedidos.fromJson(doc.data()))
                    .where((p) =>
                        p.data.start.isAtSameMomentAs(DateTime.now().start))
                    .toList();

                final produtosVendas = vendas
                    .map((v) => v.produtos)
                    .expand((p) => p)
                    .map((e) => Produto(
                          estoque: e.qtde,
                          nome: e.nome,
                          unitario: e.unitario,
                        ))
                    .toList();

                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('produtos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar produtos'),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final produtos = snapshot.data?.docs ?? [];
                    return GroupedListView<dynamic, String>(
                      elements: produtos,
                      groupBy: (element) => element.data()['tipo'],
                      groupComparator: (value1, value2) =>
                          value2.compareTo(value1),
                      itemComparator: (item1, item2) =>
                          item1['tipo'].compareTo(item2['tipo']),
                      order: GroupedListOrder.DESC,
                      useStickyGroupSeparators: true,
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      itemBuilder: (c, element) {
                        final produtoData = element;
                        final produto = Produto.fromJson(produtoData.data());
                        final vendidos = produtosVendas
                            .where((p) => p == produto)
                            .fold<double>(0, (total, e) => total + e.estoque);
                        final restantes = produto.estoque - vendidos;
                        final quantidade =
                            produtosPedido.where((p) => p == produto).length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            child: ListTile(
                              title: Text(produto.nome),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(produto.unitario.formatted),
                                  Text(
                                    'Restante: ${restantes.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FloatingActionButton(
                                      child: const Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          final i =
                                              produtosPedido.indexOf(produto);
                                          if (i != -1) {
                                            produtosPedido.removeAt(i);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      quantidade.toString(),
                                      style: const TextStyle(
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: FloatingActionButton(
                                      onPressed: quantidade < restantes
                                          ? () {
                                              setState(() {
                                                produtosPedido.add(produto);
                                              });
                                            }
                                          : null,
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Produtos: ${produtosPedido.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Total: ${produtosPedido.fold<double>(0, (total, p) => total + p.unitario).formatted}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: produtosPedido.isEmpty
            ? null
            : () {
                bool valuevolt = false;
                showDialog(
                  context: context,
                  builder: (BuildContext cxt) {
                    List produtoss = [];
                    return AlertDialog(
                      title: Text(
                        'Total: ${produtosPedido.length} x ${produtosPedido.fold<double>(0, (total, p) => total + p.unitario).formatted}'
                        '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ListView.builder(
                            itemCount: produtosPedido.length,
                            itemBuilder: (_, index) {
                              final produto = produtosPedido[index];
                              if (produtoss.contains(produto.nome)) {
                                return Container();
                              } else {
                                produtoss.add(produto.nome);
                                return ListTile(
                                  title: Text(
                                      "${produtosPedido.where((p) => p.nome == produto.nome).fold<int>(0, (total, p) => total + 1)} x ${produto.nome}"),
                                  //valor total os produtosPedido
                                  subtitle: Text(
                                    produto.unitario.formatted,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }
                            }),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Salvar Pedido"),
                          onPressed: () {
                            final unique = produtosPedido.toSet().toList();
                            final produtos = unique
                                .map((p) => ProdutoPedido(
                                      nome: p.nome,
                                      qtde: double.parse(produtosPedido
                                          .where((p2) => p2 == p)
                                          .length
                                          .toString()),
                                      unitario: p.unitario,
                                    ))
                                .toList();

                            if (widget.addnovo == false) {
                              final pedido = Pedidos(
                                mesa: mesaController.text,
                                data: widget.pedido!.data,
                                cliente: clienteController.text,
                                produtos: produtos,
                                finalizado: 0,
                                produtosAdicionais: [],
                              );
                              final data = pedido.toJson();

                              FirebaseFirestore.instance
                                  .collection('pedidos')
                                  .doc(widget.pedidoData!.id)
                                  .update(data)
                                  .then(
                                (doc) {
                                  valuevolt = true;
                                  Navigator.of(context).pop();
                                },
                              );
                            } else if (widget.addnovo == true) {
                              final unir = unirProdutos.toSet().toList();
                              final produtosadicionaislist = unir
                                  .map((p) => ProdutoPedido(
                                        nome: p.nome,
                                        qtde: double.parse(unirProdutos
                                            .where((p2) => p2 == p)
                                            .length
                                            .toString()),
                                        unitario: p.unitario,
                                      ))
                                  .toList();
                              final pedidoadicionais = Pedidos(
                                  mesa: mesaController.text,
                                  data: DateTime.now(),
                                  cliente: clienteController.text,
                                  produtos: produtosadicionaislist,
                                  finalizado: 0,
                                  produtosAdicionais: produtos);

                              final data2 = pedidoadicionais.toJsonadd();
                              FirebaseFirestore.instance
                                  .collection('pedidos')
                                  .doc(widget.pedidoData!.id)
                                  .update(data2)
                                  .then(
                                (doc) {
                                  valuevolt = true;
                                  Navigator.of(context).pop();
                                },
                              );
                            } else {
                              final pedido = Pedidos(
                                  mesa: mesaController.text,
                                  data: DateTime.now(),
                                  cliente: clienteController.text,
                                  produtos: produtos,
                                  finalizado: 0,
                                  produtosAdicionais: []);
                              final data = pedido.toJson();
                              FirebaseFirestore.instance
                                  .collection('pedidos')
                                  .add(data)
                                  .then(
                                (doc) {
                                  valuevolt = true;
                                  Navigator.of(context).pop();
                                },
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar')),
                      ],
                    );
                  },
                ).then((value) {
                  if (valuevolt) {
                    Future.delayed(
                      const Duration(milliseconds: 200),
                      () {
                        Navigator.of(context).pop();
                      },
                    );
                  }
                });
              },
        label: const Text('Salvar pedido'),
      ),
    );
  }
}