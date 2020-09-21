//Estou tentando estruturar os tipos de ingredientes e os Ingredientes que vao para o estoque
//Os Tipos tá ai para na hr de inserir selecionar qual o tipo e não ficar nomes mudando por quase nada

//Achei esses campos interessantes para o json de cada um deles, se quiserem colocar mais podem colocar
//Soh lembrar que pra nao dar erro nos dados antigos coloquem no fromJson if(json.constains(campo)) ai pega o campo novo

class TipoIngrediente {
  String nome;
  bool ehPeso;
  double pesoComum;
  bool ehVolume;
  int volumeComum;

  TipoIngrediente(
      {this.nome, this.ehPeso, this.pesoComum, this.ehVolume, this.volumeComum});

  TipoIngrediente.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    ehPeso = json['eh_peso'];
    pesoComum = json['peso_comum'];
    ehVolume = json['eh_volume'];
    volumeComum = json['volume_comum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['eh_peso'] = this.ehPeso;
    data['peso_comum'] = this.pesoComum;
    data['eh_volume'] = this.ehVolume;
    data['volume_comum'] = this.volumeComum;
    return data;
  }
}

class Ingrediente {
  String id;
  String nome;
  bool ehPeso;
  double pesoIngrediente;
  bool ehVolume;
  double volumeIngrediente;
  double preco;
  String horarioAdicionado;
  String horarioUsado;
  String validade;
  String marca;

  Ingrediente(
      {this.nome,
        this.ehPeso,
        this.pesoIngrediente,
        this.ehVolume,
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
    ehPeso = json['eh_peso'];
    pesoIngrediente = json['peso_ingrediente'];
    ehVolume = json['eh_volume'];
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
    data['eh_peso'] = this.ehPeso;
    data['peso_ingrediente'] = this.pesoIngrediente;
    data['eh_volume'] = this.ehVolume;
    data['volume_ingrediente'] = this.volumeIngrediente;
    data['preco'] = this.preco;
    data['horario_adicionado'] = this.horarioAdicionado;
    data['horario_usado'] = this.horarioUsado;
    data['validade'] = this.validade;
    data['marca'] = this.marca;
    return data;
  }
}