# NOYA

[English version](README.md)

NOYA é um aplicativo móvel para gestão de finanças pessoais. Ao contrário de outros aplicativos similares, ele não acessa seus dados bancários ou sua fatura de cartão de crédito, funcionando baseado unicamente em sua disciplina para registrar cada transação realizada. Essa abordagem pode ser trabalhosa, mas visa preservar um fator precioso nos dias atuais: sua privacidade. Dessa forma, o objetivo do NOYA é fornecer meios para que essa rotina seja um pouco mais fácil, além de lhe permitir analisar suas receitas e despesas.

Ainda sobre a questão da privacidade, os dados registrados no aplicativo NOYA são armazenados localmente no dispositivo, em uma área de armazenamento privada do aplicativo, sem envio para locais externos a não ser que explicitamente solicitado (para fins de backup). Além disso, o criador do aplicativo NOYA, Fabiano Oliveira, determinou que o software deve ser _open-source_. Portanto, caso haja alguma dúvida sobre o que o NOYA está fazendo com seus dados, você (ou algum progamador de sua confiança) pode conferir o código-fonte para esclarecer qualquer questão. Você também é livre para clonar o projeto e utilizar o código-fonte conforme os termos da [licença](LICENSE).

O NOYA é gratuito, sem anúncios no aplicativo. O criador Fabiano Oliveira o construiu para seu uso pessoal e, imaginando que outras pessoas possam ter necessidades parecidas, disponibilizou o aplicativo para o público. Se você deseja relatar um defeito ou sugerir uma melhoria, sinta-se à vontade para criar uma issue [clicando aqui](https://github.com/fabianoww/noya/issues/new). Contudo, compreenda que esse projeto é mantido, no presente momento, por uma única pessoa em seu tempo livre. Portanto, pode levar um tempo para atender a essas demandas. Se esse aplicativo te ajudou de alguma forma e você deseja demonstrar sua gratidão, você pode me pagar um café através do botão abaixo:

<a href="https://www.buymeacoffee.com/fabianooliveira" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-orange.png" alt="Gostou? Me pague um café!"  style="height: 51px !important;width: 217px !important;" ></a>

## Instalação

O NOYA é construído utilizando [Flutter](https://flutter.dev). É altamente recomendável que você siga o ["get started" documentation](https://flutter.dev/docs/get-started/install) para configurar seu ambiente de desenvolvimento.

### Requisitos

* Flutter SDK 3.41.6
* Android SDK 36
* Git 2.43 or posterior
* Um dispositivo móvel (físico ou virtual)

### Clonando o projeto

Clone o projeto em seu repositório local utilizando SSH:
```
git clone git@github.com:fabianoww/noya.git
```
ou HTTPS:
```
git clone https://github.com/fabianoww/noya.git
```

### Executando

Para executar seu aplicativo, você precisará um dispositivo para runtime, que pode ser um telefone celular o um dispositivo virtual. Para listar os dispositivos Android disponíveis, rode o comando abaixo:
```
flutter devices
```
Se ao menos um item for listado, você está pronto para prosseguir.

**Aviso importante:** Para utilizar um dispositivo físico, você terá que [habilitar a depuração USB](https://developer.android.com/studio/run/device).
```
flutter run
```

## Procedimentos técnicos

### Gerar o ícone "launcher" do aplicativo

Coloque as imagens no seguinte diretório:
```
assets\launcher
```

**Aviso importante:** Mantenha os mesmos nomes de arquivos e resolução das imagens.

Gere os ícones "launcher" através do comando abaixo:

```
flutter packages pub run flutter_launcher_icons:main
```

### Internacionalização (i18n)

O aplicativo suporta atualmente as seguintes línguas:
* Português
* Inglês

Para incluir uma nova língua, é recomendável utilizar o [Flutter Intl extension](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) no VSCode. Uma vez instalada a extensão, você pode abrir a Paleta de Comandos (Ctrl+3) e digitar:
```
Flutter Intl: Add locale
```
Será solicitado o código da localização que você está adicionando. Em seguida, basta editar o arquivo .arb correspondente localizado no seguinte diretório:
```
lib\l10n
```
Você pode utilizar os arquivos .arb existentes nessa pasta como modelos.

## Suporte

Se você precisar de ajuda, fique à vontade para [abrir uma issue nesse projeto](https://github.com/fabianoww/noya/issues/new). Pode levar um tempo para responder (já que sou uma "euquipe"), mas eu farei o possível! :)

If you're looking for help, feel free to [open an issue on this project](https://github.com/fabianoww/noya/issues/new). It might take a while (since I'm one man army), but I'll do my best! 😄

## Autores e créditos
* Fabiano Oliveira - https://fabiano.dev

## Licença
Esse projeto _open-source_ é licenciado pela [GNU General Public License v3.0](LICENSE).