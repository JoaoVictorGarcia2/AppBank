import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Banco());

class Banco extends StatelessWidget {
  const Banco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaTransferencia()),
                );
              },
              child: Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Transferências",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Contatos()),
                );
              },
              child: Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Contatos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerCampoNumeroConta = TextEditingController();
  final TextEditingController _controllerCampoValor = TextEditingController();

  FormularioTransferencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nova Transferência",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Editor(controlador: _controllerCampoNumeroConta, rotulo: 'Número da conta', dica: '0000'),
          Editor(controlador: _controllerCampoValor, rotulo: 'Valor', dica: '0.00', icone: Icons.monetization_on),
          ElevatedButton(
            onPressed: () {
              _criarTransferencia(context, _controllerCampoNumeroConta, _controllerCampoValor);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _criarTransferencia(BuildContext context, TextEditingController controllerCampoNumeroConta, TextEditingController controllerCampoValor) {
    debugPrint("Clicou em confirmar");
    final int? numeroConta = int.tryParse(controllerCampoNumeroConta.text);
    final double? valor = double.tryParse(controllerCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      debugPrint('Criando transferência');
      debugPrint('$transferenciaCriada');
      Navigator.pop(context, transferenciaCriada);
    }
  }
}

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;

  const Editor({super.key, this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24.0),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone, color: Colors.green) : null,
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Transferência{valor: $valor, numeroConta: $numeroConta}';
  }
}

class ListaTransferencia extends StatefulWidget {
  final List<Transferencia> _transferencias = [];

  ListaTransferencia({super.key});

  @override
  State<StatefulWidget> createState() {
    return ListaTransferenciasState();
  }
}

class ListaTransferenciasState extends State<ListaTransferencia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transferências",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: widget._transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = widget._transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Future<Transferencia?> future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
            if (transferenciaRecebida != null) {
              setState(() {
                widget._transferencias.add(transferenciaRecebida);
              });
            }
          });
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add_circle_rounded,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia, {super.key});

  @override
  Widget build(BuildContext context) {
    String valorFormatado = _transferencia.valor
        .toStringAsFixed(2)
        .replaceAll('.', ',')
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.");

    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.green),
        title: Text("R\$ $valorFormatado"),
        subtitle: Text(_transferencia.numeroConta.toString()),
      ),
    );
  }
}

class Contato {
  final String nome;
  final String endereco;
  final String telefone;
  final String email;
  final String cpf;

  Contato(this.nome, this.endereco, this.telefone, this.email, this.cpf);
}

class FormularioContato extends StatelessWidget {
  final Function(Contato) onContatoAdicionado;
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEndereco = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();

  FormularioContato({super.key, required this.onContatoAdicionado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Contato"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _controllerEndereco,
              decoration: const InputDecoration(labelText: "Endereço"),
            ),
            TextField(
              controller: _controllerTelefone,
              decoration: const InputDecoration(labelText: "Telefone"),
            ),
            TextField(
              controller: _controllerEmail,
              decoration: const InputDecoration(labelText: "E-mail"),
            ),
            TextField(
              controller: _controllerCpf,
              decoration: const InputDecoration(labelText: "CPF"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                final novoContato = Contato(
                  _controllerNome.text,
                  _controllerEndereco.text,
                  _controllerTelefone.text,
                  _controllerEmail.text,
                  _controllerCpf.text,
                );
                onContatoAdicionado(novoContato);
                Navigator.pop(context);
              },
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  final List<Contato> _contatos = [];

  void _adicionarContato(Contato contato) {
    setState(() {
      _contatos.add(contato);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lista de Contatos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: _contatos.length,
        itemBuilder: (context, index) {
          final contato = _contatos[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text("Nome: ${contato.nome}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Endereço: ${contato.endereco}"),
                  Text("Telefone: ${contato.telefone}"),
                  Text("E-mail: ${contato.email}"),
                  Text("CPF: ${contato.cpf}"),
                ],
              ),
              trailing: const Icon(Icons.person, color: Colors.green),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormularioContato(
                onContatoAdicionado: _adicionarContato,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add_circle_rounded,
          size: 35,
          color: Colors.white,
        ),
      ),
    );
  }
}
