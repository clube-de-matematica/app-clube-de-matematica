import 'dart:io';

///Classe usada para gerenciar downloads.
class Downloads {
  Future<File> smallFile() {}

  ///Faz o download de uma imágem no Firebase Storage, caso não esteja no armazenamento local.
  ///Retornará `null` se o usuário não estiver logado ou ocrrer algum erro ao buscar o arquivo.
  Future<File> _downloadImagemFile(File fileTemp,
      {String nome}) async {
    ///Garantir condições para os atributos.
    assert(fileTemp != null);
    assert(nome != null);

    /* try {
      ///Se o arquivo não existe, ele será baixado.
      if (await fileTemp.exists()) return fileTemp;

      ///Fazer o download e salvar em `fileTemp`.
      return await storageRepository.downloadFile(
          dirImagensInDb.child(nome), fileTemp);
    } on MyExceptionStorageRepository catch (error) {
      print(error.toString());
      return null;
    } */
  }

  
}
