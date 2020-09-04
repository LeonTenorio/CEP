//Estou tentando estruturar os tipos de ingredientes e os Ingredientes que vao para o estoque
//Os Tipos tá ai para na hr de inserir selecionar qual o tipo e não ficar nomes mudando por quase nada

//Achei esses campos interessantes para o json de cada um deles, se quiserem colocar mais podem colocar
//Soh lembrar que pra nao dar erro nos dados antigos coloquem no fromJson if(json.constains(campo)) ai pega o campo novo

class TipoIngrediente {
  String nome;
  bool peso;
  double pesoComum;
  bool volume;
  int volumeComum;

  TipoIngrediente(
      {this.nome, this.peso, this.pesoComum, this.volume, this.volumeComum});

  TipoIngrediente.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    peso = json['peso'];
    pesoComum = json['peso_comum'];
    volume = json['volume'];
    volumeComum = json['volume_comum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['peso'] = this.peso;
    data['peso_comum'] = this.pesoComum;
    data['volume'] = this.volume;
    data['volume_comum'] = this.volumeComum;
    return data;
  }
}

class Ingrediente {
  String id;
  String nome;
  bool peso;
  double pesoIngrediente;
  bool volume;
  double volumeIngrediente;
  double preco;
  String horarioAdicionado;
  String horarioUsado;
  String validade;
  String marca;

  Ingrediente(
      {this.nome,
        this.peso,
        this.pesoIngrediente,
        this.volume,
        this.volumeIngrediente,
        this.preco,
        this.horarioAdicionado,
        this.horarioUsado,
        this.validade,
        this.marca}){
    this.id = DateTime.now().toString();
  }

  Ingrediente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    peso = json['peso'];
    pesoIngrediente = json['peso_ingrediente'];
    volume = json['volume'];
    volumeIngrediente = json['volume_ingrediente'];
    preco = json['preco'];
    horarioAdicionado = json['horario_adicionado'];
    horarioUsado = json['horario_usado'];
    validade = json['validade'];
    marca = json['marca'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['peso'] = this.peso;
    data['peso_ingrediente'] = this.pesoIngrediente;
    data['volume'] = this.volume;
    data['volume_ingrediente'] = this.volumeIngrediente;
    data['preco'] = this.preco;
    data['horario_adicionado'] = this.horarioAdicionado;
    data['horario_usado'] = this.horarioUsado;
    data['validade'] = this.validade;
    data['marca'] = this.marca;
    return data;
  }
}