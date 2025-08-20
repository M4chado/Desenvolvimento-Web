import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Simulação de autenticação
bool isAuthenticated = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rotas Nomeadas',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Verificação de rotas privadas
        if (settings.name == '/private1' || settings.name == '/private2') {
          if (!isAuthenticated) {
            return MaterialPageRoute(
              builder: (context) => LoginScreen(),
            );
          }
        }

        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => HomeScreen());
          case '/private1':
            return MaterialPageRoute(builder: (context) => PrivateScreen1());
          case '/private2':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
                builder: (context) => PrivateScreen2(data: args));
        }
        return null;
      },
    );
  }
}

// ------------------- TELAS -------------------

// Tela pública
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Pública")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bem-vindo!"),
            ElevatedButton(
              onPressed: () {
                isAuthenticated = true;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Usuário autenticado!")),
                );
              },
              child: Text("Fazer Login"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/private1');
              },
              child: Text("Ir para Rota Privada 1"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/private2',
                  arguments: {
                    "nome": "Eduardo Martins",
                    "dataNascimento": "19/08/1999",
                    "telefone": "(11) 91234-5678",
                  },
                );
              },
              child: Text("Ir para Rota Privada 2 (com dados)"),
            ),
          ],
        ),
      ),
    );
  }
}

// Tela de login (exibida se tentar acessar rota privada sem autenticação)
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Necessário")),
      body: Center(
        child: Text("Você precisa estar autenticado para acessar essa página."),
      ),
    );
  }
}

// Primeira tela privada
class PrivateScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rota Privada 1")),
      body: Center(
        child: Text("Conteúdo exclusivo da rota privada 1."),
      ),
    );
  }
}

// Segunda tela privada (recebe dados via Map)
class PrivateScreen2 extends StatelessWidget {
  final Map<String, dynamic>? data;

  const PrivateScreen2({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rota Privada 2")),
      body: Center(
        child: data == null
            ? Text("Nenhum dado recebido.")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Nome: ${data!['nome']}"),
                  Text("Data de Nascimento: ${data!['dataNascimento']}"),
                  Text("Telefone: ${data!['telefone']}"),
                ],
              ),
      ),
    );
  }
}
