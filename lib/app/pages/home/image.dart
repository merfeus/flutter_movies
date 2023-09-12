import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final String imageUrl;

  const ImageDetailPage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Adicione um ícone para fechar a tela de detalhes aqui, se desejar.
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(
          imageUrl,
          // Defina a propriedade fit para BoxFit.contain ou BoxFit.cover, dependendo do comportamento desejado.
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
