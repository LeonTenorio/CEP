import '../models/Ingredientes.dart';
import 'dart:async';
import 'Arquivos.dart';

final String nomeArquivoTiposIngredientes = "tiposIngredientes.json";
final String nomeArquivoIngredientesEstoque = "ingredientesEstoque.json";
final String nomeArquivoIngredientesUsados = "ingredientesUsados.json";

/*
Os tipos de ingredientes ficaram salvos assim
{
  "tipoNome1": JSON do tipo do ingrediente,
  "tipoNome2": JSON do tipo do ingrediente,
  ...
}
*/

/*getIngredientesEstoque - retorna os ingredientes estruturados em Map<String, dynamic> estruturado de ingredientes
{
  "SAL":{
    "DATAINGREDIENTE1": classe INGREDIENTE,
    "DATAINGREDIENTE2": class INGREDIENTE,
    ...
  },
  "OLEO":{
    "DATAINGREDIENTE3": classe INGREDIENTE,
    "DATAINGREDIENTE4": class INGREDIENTE,
    ...
  },
  ...
}
*/

//getListTiposIngredientes - retorna a listagem de tipos de ingredientes
//getTiposIngredientes - retorna o mapa de tipos de ingredientes
//addIngredienteEstoque - adiciona o ingrediente no estoque
//removerIngredienteEstoque - remove o ingrediente do estoque para LIXO (deleta mesmo)
//consumirIngrediente - consome o ingrediente do estoque e joga ele para o local de ingredientes usados, a quantidade que precisa deles, alem de retornar a lista de ingredientes usados nesse processo (sei la por que criterio tah isso, acho que por ordem que os ingredientes sao inseridos do mais antigo para o mais novo

Future<Map<String, TipoIngrediente>> getTiposIngredientes() async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoTiposIngredientes);
  Map<String, TipoIngrediente> ret = new Map<String, TipoIngrediente>();

  List<String> tipos = reload.keys.toList();
  for(int i=0;i<tipos.length;i++){
    ret[tipos[i]] = TipoIngrediente.fromJson(reload[tipos[i]]);
  }
  return ret;
}

Future<List<Ingrediente>> getListTiposIngredientes() async{
  Map<String, dynamic> load = await getTiposIngredientes();
  List<Ingrediente> ret = new List<Ingrediente>();
  List<String> keys = load.keys.toList();
  for(int i=0;i<keys.length;i++){
    ret.addAll(load[keys[i]]);
  }
  return ret;
}

Future<void> _addTipoIngrediente({TipoIngrediente tipoIngrediente}) async{
  print("aqui ");
  print(tipoIngrediente.toJson());
  Map<String, dynamic> tipos = await getDocument(docName: nomeArquivoTiposIngredientes);
  if(!tipos.containsKey(tipoIngrediente.nome)){
    tipos[tipoIngrediente.nome] = tipoIngrediente.toJson();
    await saveDocument(docName: nomeArquivoTiposIngredientes, map: tipos);
  }
}

/*
Os ingredientes ficaram salvos assim
{
  "nomeDoTipo1": {
    "idIngrediente1": JSON ingrediente1,
    ...
  },
  ...
}
*/

Future<void> addIngredienteEstoque(Ingrediente ingrediente) async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoIngredientesEstoque);
  if(!reload.containsKey(ingrediente.nome)){
    reload[ingrediente.nome] = new Map<String, dynamic>();
    await _addTipoIngrediente(tipoIngrediente: TipoIngrediente(nome: ingrediente.nome, ehPeso: ingrediente.ehPeso, ehVolume: ingrediente.ehVolume));
  }
  reload[ingrediente.nome][ingrediente.id] = ingrediente.toJson();
  await saveDocument(docName: nomeArquivoIngredientesEstoque, map: reload);
}

Future<Map<String, dynamic>> getIngredientesEstoque() async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoIngredientesEstoque);
  Map<String, dynamic> ret = new Map<String, dynamic>();
  List<String> tipos = reload.keys.toList();
  for(int i=0;i<tipos.length;i++){
    if(!ret.containsKey(tipos[i])){
      ret[tipos[i]] = new Map<String, dynamic>();
    }
    Map<String, dynamic> ingredientesDesteTipo = reload[tipos[i]];
    List<String> nomesIngredientesDesteTipo = ingredientesDesteTipo.keys.toList();
    for(int j=0;j<nomesIngredientesDesteTipo.length;j++){
      Ingrediente ingrediente = Ingrediente.fromJson(reload[tipos[i]][nomesIngredientesDesteTipo[j]]);
      ret[tipos[i]][ingrediente.id] = ingrediente;
    }
  }
  return ret;
}

Future<Map<String, dynamic>> getIngredientesUsados() async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoIngredientesUsados);
  Map<String, dynamic> ret = new Map<String, dynamic>();
  List<String> tipos = reload.keys.toList();
  for(int i=0;i<tipos.length;i++){
    if(!ret.containsKey(tipos[i])){
      ret[tipos[i]] = new Map<String, dynamic>();
    }
    Map<String, dynamic> ingredientesDesteTipo = reload[tipos[i]];
    List<String> nomesIngredientesDesteTipo = ingredientesDesteTipo.keys.toList();
    for(int j=0;j<nomesIngredientesDesteTipo.length;j++){
      Ingrediente ingrediente = Ingrediente.fromJson(reload[tipos[i]][nomesIngredientesDesteTipo[j]]);
      ret[tipos[i]][ingrediente.id] = ingrediente;
    }
  }
  return ret;
}

Future<void> removerIngredienteEstoque({Ingrediente ingrediente}) async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoIngredientesEstoque);
  reload[ingrediente.nome].remove(ingrediente.id);
  await saveDocument(docName: nomeArquivoIngredientesEstoque, map: reload);
}

Future<List<Ingrediente>> consumirIngrediente({String tipo, double peso, double volume}) async{
  Map<String, dynamic> estoque = await getDocument(docName: nomeArquivoIngredientesEstoque);
  Map<String, dynamic> usados = await getDocument(docName: nomeArquivoIngredientesUsados);
  List<Ingrediente> ret = new List<Ingrediente>();

  List<String> datasProdutos = estoque[tipo].keys.toList();
  datasProdutos.sort((a,b) => a.compareTo(b));//Lista crescente
  double soma = 0.0;
  int i=0;
  while((peso!=null && soma<peso) || (volume!=null && soma<volume)){
    if(i>=datasProdutos.length){
      throw("Não tem estoque suficiente desse produto");
    }
    Ingrediente ingrediente = Ingrediente.fromJson(estoque[tipo][datasProdutos[i]]);
    if(!usados.containsKey(ingrediente.nome))
      usados[ingrediente.nome] = new Map<String, dynamic>();
    if(ingrediente.ehPeso){
      if(peso==null){
        throw("Métrica para tirar do estoque é diferente da métrica passada");
      }
      if(soma+ingrediente.pesoIngrediente>=peso){
        estoque[tipo].remove(ingrediente.id);
        i++;
      }
      else{
        ingrediente.pesoIngrediente = peso - soma;
        estoque[tipo][ingrediente.id]['peso_ingrediente'] = estoque[tipo][ingrediente.id]['peso_ingrediente'] - ingrediente.pesoIngrediente;
      }
      soma = soma + ingrediente.pesoIngrediente;
    }
    else if(ingrediente.ehVolume){
      if(volume==null){
        throw("Métrica para tirar do estoque é diferente da métrica passada");
      }
      if(soma+ingrediente.volumeIngrediente>=peso){
        estoque[tipo].remove(ingrediente.id);
        i++;
      }
      else{
        ingrediente.volumeIngrediente = volume - soma;
        estoque[tipo][ingrediente.id]['volume_ingrediente'] = estoque[tipo][ingrediente.id]['volume_ingrediente'] - ingrediente.volumeIngrediente;
      }
      soma = soma + ingrediente.volumeIngrediente;
    }
    else{
      throw("Ingrediente "+ingrediente.id+" sem métrica de quantidade no estoque");
    }
    ingrediente.horarioUsado = DateTime.now().toString();
    ret.add(ingrediente);
    ingrediente.id = ingrediente.id + DateTime.now().toString();
    usados[ingrediente.nome][ingrediente.id] = ingrediente.toJson();
  }
  await saveDocument(docName: nomeArquivoIngredientesEstoque, map: estoque);
  await saveDocument(docName: nomeArquivoIngredientesUsados, map: usados);
  return ret;
}
