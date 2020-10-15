import 'package:my_warehouse/models/Ingredientes.dart';

class Receita {
  String nome;
  String horarioAdicionado;
  double percentualLucro;
  double precoReceita;
  double precoComercializado;
  String horarioAtualizado;
  String horarioFeito;
  String horarioComercializado;
  List<String> nomesIngredientes;
  List<double> quantidadesIngredientes;
  Map<String, dynamic> ingredientesUsados;

  double getCusto(){
    /*ingredientesUsados = {
    *   "tipo1": [INGREDIENTE 1, INGREDIENTE2, ...],
    *   "tipo2": [INGREDIENTE 3, INGREDIENTE4, ...],
    *   ...
    * }
    * */
    double custo = 0.0;
    List<String> tiposIngredientes = this.ingredientesUsados.keys.toList();
    for(int i=0;i<tiposIngredientes.length;i++){
      List<dynamic> ingredientesTipo = this.ingredientesUsados[tiposIngredientes[i]];
      for(int j=0;j<ingredientesTipo.length;j++){
        Ingrediente ingrediente = Ingrediente.fromJson(ingredientesTipo[j]);
        custo = custo + ingrediente.preco;
      }
    }
    return custo;
  }

  Receita(
      {this.nome,
        this.horarioAdicionado,
        this.precoReceita,
        this.nomesIngredientes,
        this.horarioAtualizado,
        this.quantidadesIngredientes,
        this.percentualLucro});

  Receita.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    horarioAdicionado = json['horario_adicionado'];
    precoReceita = json['preco_receita'];
    precoComercializado = json['preco_comercializado'];
    horarioAtualizado = json['horario_atualizado'];
    horarioComercializado = json['horario_comercializado'];
    nomesIngredientes = json['nomes_ingredientes'].cast<String>();
    quantidadesIngredientes = json['quantidades_ingredientes'].cast<double>();
    percentualLucro = json['percentual_lucro'];
    ingredientesUsados = json['ingredientes_usados'];
    horarioFeito = json['horario_feito'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['horario_adicionado'] = this.horarioAdicionado;
    data['preco_receita'] = this.precoReceita;
    data['preco_comercializado'] = this.precoComercializado;
    data['horario_atualizado'] = this.horarioAtualizado;
    data['horario_comercializado'] = this.horarioComercializado;
    data['nomes_ingredientes'] = this.nomesIngredientes;
    data['quantidades_ingredientes'] = this.quantidadesIngredientes;
    data['ingredientes_usados'] = this.ingredientesUsados;
    data['horario_feito'] = this.horarioFeito;
    data['percentual_lucro'] = this.percentualLucro;
    return data;
  }
}
