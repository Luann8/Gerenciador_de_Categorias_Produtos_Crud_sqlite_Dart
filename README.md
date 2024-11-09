# Gerenciador de Categorias e Produtos

Este é um projeto Flutter que implementa um CRUD (Create, Read, Update, Delete) para gerenciar **Categorias** e **Produtos** com relacionamento usando o SQLite como banco de dados local.

## Funcionalidades

- **Gerenciamento de Categorias**: Adicione, edite e exclua categorias.
- **Gerenciamento de Produtos**: Cada produto é vinculado a uma categoria específica e contém informações de nome e preço. É possível adicionar, editar e excluir produtos, mantendo o relacionamento com a categoria.

## Interface

A interface do aplicativo é intuitiva e permite fácil navegação entre as seções de **Categorias** e **Produtos**:

- **Página Inicial**: Apresenta uma lista de categorias, cada uma com seus produtos organizados abaixo.
- **Adicionar ou Editar Categorias**: Inclui um formulário simplificado para entrada e atualização de categorias.
- **Adicionar ou Editar Produtos**: Permite adicionar um novo produto com um nome e preço, além de associá-lo a uma categoria. 
- **Design Limpo e Intuitivo**: Os ícones de adicionar (`+`), editar (ícone de lápis) e excluir (ícone de lixeira) facilitam a navegação e execução das operações CRUD para ambas as categorias e produtos.

## Pré-requisitos

Antes de começar, certifique-se de que possui as seguintes ferramentas instaladas:

- [Flutter](https://flutter.dev/docs/get-started/install) 
- [Dart SDK](https://dart.dev/get-dart) (incluso no Flutter)

## Configuração do Ambiente

1. **Instale as Dependências**

Use o comando abaixo para instalar as dependências do projeto:

```bash
flutter pub get

```
**Inicie o Emulador ou Conecte um Dispositivo**

Certifique-se de que um dispositivo Android e esteja conectado e configurado ou que um emulador esteja em execução.
 


**Execute o Projeto**


Para rodar o projeto, use o seguinte comando:

```bash
flutter run
```
![Interface do Aplicativo](https://github.com/Luann8/test2/blob/main/image.png)
