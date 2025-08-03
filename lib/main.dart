import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Cadastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormularioCadastro(),
    );
  }
}

class FormularioCadastro extends StatefulWidget {
  @override
  _FormularioCadastroState createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();

  String? _sexoSelecionado;
  DateTime? _dataNascimento;

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  // Função para calcular a idade
  int calcularIdade(DateTime dataNascimento) {
    DateTime hoje = DateTime.now();
    int idade = hoje.year - dataNascimento.year;

    if (hoje.month < dataNascimento.month ||
        (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)) {
      idade--;
    }

    return idade;
  }

  // Função para mostrar o seletor de data
  Future<void> _selecionarData(BuildContext context) async {
    DateTime dataInicial = DateTime.now().subtract(Duration(days: 365 * 18));
    DateTime dataMinima = DateTime(1900);
    DateTime dataMaxima = DateTime.now();

    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: dataMinima,
      lastDate: dataMaxima,
      locale: const Locale('pt', 'BR'),
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (dataSelecionada != null) {
      setState(() {
        _dataNascimento = dataSelecionada;
        _dataController.text =
            '${dataSelecionada.day.toString().padLeft(2, '0')}/'
            '${dataSelecionada.month.toString().padLeft(2, '0')}/'
            '${dataSelecionada.year}';
      });
    }
  }

  // Função para validar o formulário
  void _validarFormulario() {
    if (_formKey.currentState!.validate()) {
      if (_dataNascimento != null) {
        int idade = calcularIdade(_dataNascimento!);

        if (idade >= 18) {
          // Cadastro válido
          _mostrarSucesso();
        } else {
          _mostrarErroIdade();
        }
      }
    }
  }

  void _mostrarSucesso() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro Realizado!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${_nomeController.text}'),
              Text('Data de Nascimento: ${_dataController.text}'),
              Text('Sexo: $_sexoSelecionado'),
              Text('Idade: ${calcularIdade(_dataNascimento!)} anos'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _limparFormulario();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarErroIdade() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Idade Insuficiente'),
          content: Text(
            'É necessário ter 18 anos ou mais para realizar o cadastro.\n'
            'Sua idade atual: ${calcularIdade(_dataNascimento!)} anos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _limparFormulario() {
    setState(() {
      _nomeController.clear();
      _dataController.clear();
      _sexoSelecionado = null;
      _dataNascimento = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Cadastro'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Nome Completo
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome completo';
                  }
                  if (value.trim().split(' ').length < 2) {
                    return 'Por favor, insira nome e sobrenome';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Campo Data de Nascimento
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => _selecionarData(context),
                  ),
                ),
                readOnly: true,
                onTap: () => _selecionarData(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione sua data de nascimento';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Campo Sexo
              Text(
                'Sexo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Homem'),
                      value: 'Homem',
                      groupValue: _sexoSelecionado,
                      onChanged: (String? value) {
                        setState(() {
                          _sexoSelecionado = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text('Mulher'),
                      value: 'Mulher',
                      groupValue: _sexoSelecionado,
                      onChanged: (String? value) {
                        setState(() {
                          _sexoSelecionado = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              if (_sexoSelecionado == null)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    'Por favor, selecione uma opção',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              SizedBox(height: 32),

              // Botões
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_sexoSelecionado == null) {
                          setState(() {}); // Para mostrar a mensagem de erro
                          return;
                        }
                        _validarFormulario();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Cadastrar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _limparFormulario,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Limpar', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
