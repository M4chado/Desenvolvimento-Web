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
  final PageController _pageController = PageController();
  final _nomeController = TextEditingController();
  final _dataController = TextEditingController();

  String? _sexoSelecionado;
  DateTime? _dataNascimento;
  int _currentPage = 0;

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    _pageController.dispose();
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

  // Função para validar se todos os campos estão preenchidos
  bool _todosOsCamposPreenchidos() {
    return _nomeController.text.isNotEmpty &&
        _dataNascimento != null &&
        _sexoSelecionado != null;
  }

  // Função para validar o nome
  String? _validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu nome completo';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Por favor, insira nome e sobrenome';
    }
    return null;
  }

  // Função para validar o formulário
  void _validarFormulario() {
    if (_todosOsCamposPreenchidos()) {
      String? erroNome = _validarNome(_nomeController.text);
      if (erroNome != null) {
        _mostrarErro(erroNome);
        return;
      }

      int idade = calcularIdade(_dataNascimento!);

      if (idade >= 18) {
        _mostrarSucesso();
      } else {
        _mostrarErroIdade();
      }
    } else {
      _mostrarErro('Por favor, preencha todos os campos');
    }
  }

  void _mostrarErro(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro de Validação'),
          content: Text(mensagem),
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
      _currentPage = 0;
    });
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildNomeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'Nome Completo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Digite seu nome completo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              if (_nomeController.text.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Preenchido',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'Data de Nascimento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Selecione sua data de nascimento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.calendar_month),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () => _selecionarData(context),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                readOnly: true,
                onTap: () => _selecionarData(context),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              if (_dataNascimento != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Idade: ${calcularIdade(_dataNascimento!)} anos',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSexoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'Sexo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[50],
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('Homem', style: TextStyle(fontSize: 16)),
                      value: 'Homem',
                      groupValue: _sexoSelecionado,
                      onChanged: (String? value) {
                        setState(() {
                          _sexoSelecionado = value;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    RadioListTile<String>(
                      title: Text('Mulher', style: TextStyle(fontSize: 16)),
                      value: 'Mulher',
                      groupValue: _sexoSelecionado,
                      onChanged: (String? value) {
                        setState(() {
                          _sexoSelecionado = value;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              if (_sexoSelecionado != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text(
                        _sexoSelecionado!,
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Cadastro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Indicador de progresso
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey[300],
                  ),
                );
              }),
            ),
          ),

          // Carrossel de cards
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildNomeCard(),
                _buildDataCard(),
                _buildSexoCard(),
              ],
            ),
          ),

          // Botões de navegação e ação
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: Icon(Icons.arrow_back),
                      label: Text('Anterior'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                
                if (_currentPage > 0) SizedBox(width: 16),
                
                Expanded(
                  child: _currentPage < 2
                      ? ElevatedButton.icon(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text('Próximo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _validarFormulario,
                          icon: Icon(Icons.check),
                          label: Text('Cadastrar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                ),
                
                SizedBox(width: 16),
                
                OutlinedButton.icon(
                  onPressed: _limparFormulario,
                  icon: Icon(Icons.clear),
                  label: Text('Limpar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}