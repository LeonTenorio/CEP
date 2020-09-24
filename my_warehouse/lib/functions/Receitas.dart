import 'package:my_warehouse/functions/Arquivos.dart';
import 'package:my_warehouse/models/Ingredientes.dart';
import 'package:my_warehouse/models/Receitas.dart';
import 'package:my_warehouse/functions/Ingredientes.dart';

final String nomeArquivoReceitas = "receitas.json";
final String nomeArquivoReceitasFeitas = "receitasFeitas.json";
final String nomeArquivoReceitasVendidas = "receitasVendidas.json";

/*COMENTARIOS DESSE BECKEND E DAS FUNCOES USAVEIS*/
//getReceitas - lista de receitas cadastradas
//getReceitasFeitas - lista de receitas feitas
//getReceitasVendiads - lista de receitas vendidas
//addNovaReceita - adicionar uma nova receita ao cadastro de receitas
//removerReceita - remover receita do cadastro de receitas
//checkEstoqueReceita - retorna a quantidade possivel de ser feita com o estoque atual daquela receita
//fazerReceita - faz uma receita consumindo os ingredientes do estoque
//venderReceita - vende a receita que ja foi feita

Future<List<Receita>> _getReceitas({String docName}) async{
  List<Receita> ret = new List<Receita>();
  Map<String, dynamic> reload = await getDocument(docName: docName);
  List<String> identificadores = reload.keys.toList();
  for(int i=0;i<identificadores.length;i++){
    ret.add(Receita.fromJson(reload[identificadores[i]]));
  }
  return ret;
}

Future<List<Receita>> getReceitas() async{
  return await _getReceitas(docName: nomeArquivoReceitas);
}

Future<List<Receita>> getReceitasFeitas() async{
  return await _getReceitas(docName: nomeArquivoReceitasFeitas);
}

Future<List<Receita>> getReceitasVendidas() async{
  return await _getReceitas(docName: nomeArquivoReceitasVendidas);
}

Future<bool> addNovaReceita({Receita receita}) async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoReceitas);
  if(!reload.containsKey(receita.nome)){
    reload[receita.nome] = receita.toJson();
    await saveDocument(docName: nomeArquivoReceitas, map: reload);
    return true;
  }
  else{
    return false;
  }
}

Future<bool> removerReceita({String nome}) async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoReceitas);
  if(reload.containsKey(nome)){
    reload[nome] = null;
    reload.remove(nome);
    await saveDocument(docName: nomeArquivoReceitas, map: reload);
    return true;
  }
  else{
    return false;
  }
}

Future<void> _addReceitaFeita({Receita receita}) async{
  Map<String, dynamic> reload = await getDocument(docName: nomeArquivoReceitasFeitas);
  reload[receita.horarioFeito] = receita.toJson();
  await saveDocument(docName: nomeArquivoReceitasFeitas, map: reload);
}

Future<int> checkEstoqueReceita({Receita receita}) async{
  int min = 0;
  bool first = true;
  for(int i=0;i<receita.nomesIngredientes.length;i++){
    int quantidadeIngrediente = await checkEstoque(tipo: receita.nomesIngredientes[i], quantidade: receita.quantidadesIngredientes[i]);
    if(quantidadeIngrediente<=0){
      return 0;
    }
    else if(first==true || quantidadeIngrediente<min){
      min = quantidadeIngrediente;
    }
  }
  return min;
}

Future<List<dynamic>> fazerReceita({Receita receita}) async{//Desculpem, vai retornar uma flag true ou false e um texto do erro se tiver
  //[bool flag, String error]
  Map<String, dynamic> ingredientesUsados = new Map<String, dynamic>();
  List<String> nomesIngredientes = receita.nomesIngredientes;
  List<double> quantidadeIngredientes = receita.quantidadesIngredientes;
  for(int i=0;i<nomesIngredientes.length;i++){
    try{
      List<Ingrediente> ingredientesConsumidos = await consumirIngrediente(tipo: nomesIngredientes[i], quantidade: quantidadeIngredientes[i]);
      if(ingredientesConsumidos==null){
        return [false, "Está faltando ingredientes no estoque"];
      }
      else{
        if(!ingredientesUsados.containsKey(nomesIngredientes[i])){
          ingredientesUsados[nomesIngredientes[i]] = new List<dynamic>();
        }
        for(int j=0;j<ingredientesConsumidos.length;j++){
          ingredientesUsados[nomesIngredientes[i]].add(ingredientesConsumidos[j].toJson());
        }
      }
    }
    catch(e){
      print(e);
      return [false, e.toString()];
    }
  }
  receita.horarioFeito = DateTime.now().toString();
  receita.ingredientesUsados = ingredientesUsados;
  await _addReceitaFeita(receita: receita);
  return [true, ''];
}

Future<bool> venderReceita({Receita receita, double precoVenda}) async{
  Map<String, dynamic> reloadFeitos = await getDocument(docName: nomeArquivoReceitasFeitas);
  Map<String, dynamic> reloadVendidos = await getDocument(docName: nomeArquivoReceitasVendidas);
  if(reloadFeitos.containsKey(receita.horarioFeito)){
    receita = Receita.fromJson(reloadFeitos[receita.horarioFeito]);
    reloadFeitos[receita.horarioFeito] = null;
    reloadFeitos.remove(receita.horarioFeito);
    receita.percentualLucro = precoVenda;
    receita.horarioComercializado = DateTime.now().toString();
    reloadVendidos[receita.horarioComercializado] = receita.toJson();
    await saveDocument(docName: nomeArquivoReceitasVendidas, map: reloadVendidos);
    return true;
  }
  return false;
}


