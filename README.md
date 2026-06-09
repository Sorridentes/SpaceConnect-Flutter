# SpaceConnect - Flutter MVVM

## Descrição da solução

SpaceConnect é um aplicativo Flutter que consome a API NASA APOD (Astronomy Picture of the Day) para exibir imagens astronômicas e informações diárias. A aplicação traz uma experiência mobile moderna com autenticação local, navegação organizada, filtros e um sistema de favoritos.

## Proposta da aplicação

A proposta do SpaceConnect é transformar o conteúdo da NASA em um app intuitivo, permitindo que o usuário explore imagens do dia, visualize detalhes com efeito hero, salve favoritos e filtre resultados por data e texto.
O objetivo é oferecer um produto funcional para descoberta de astronomia, com persistência de login e favoritos usando armazenamento local.

## Integrantes do grupo

- Rodrigo Silva Rocha RM: 552857 - Desenvolvimento Flutter
- Felipe Lima Bonato Testa RM: 553780 - Design e UI
- Thiago Luiz Pereira RM: 553720 - Lógica de negócios e integração API

## Funcionalidades principais

- Tela de splash com animação
- Onboarding com 4 páginas
- Login e cadastro com persistência
- Galeria APOD com busca por intervalo de datas
- Filtro por título e descrição
- Tela de detalhes com imagem em destaque (Hero)
- Favoritos persistidos localmente
- Navegação inferior entre Galeria e Favoritos

## Como rodar

```bash
# Instalar dependências para flutter
flutter pub get

# Instalar dependências para o proxy-server
npm install

# Executar para iniciar o proxy-server
node proxy-server/server.js

# Abra outro terminal para rodar o app Flutter
# Executar no modo debug
flutter run

# Executar para web
flutter run -d chrome

```

> Observação: o projeto está configurado para usar proxy na exibição de imagens, garantindo que as imagens APOD sejam carregadas corretamente em ambientes onde o acesso direto pode ser restrito.

## Vídeo Pitch

Link do vídeo Pitch: [Video do Youtube](https://youtu.be/V75YywlTELU?si=uG9MIuNVvOFAaWOU)

## Arquitetura

O projeto segue o padrão **MVVM (Model-View-ViewModel)** com a seguinte estrutura de pastas:

```
lib/
├── core/                          # Configurações centrais
│   ├── dependency_injections.dart # Injeção de dependências (GetIt)
│   ├── app_theme.dart             # Tema e design tokens
│   └── app_routes.dart            # Definição de rotas
│
├── data/                          # Camada de dados
│   ├── repositories/              # Repositórios (coordenam services)
│   │   ├── astronomy_repository.dart
│   │   └── auth_repository.dart
│   └── services/                  # Serviços (API, persistência)
│       ├── nasa_api_service.dart
│       ├── auth_local_service.dart
│       └── favorites_local_service.dart
│
├── domain/                        # Camada de domínio
│   └── models/                    # Modelos de dados
│       ├── astronomy_model.dart
│       ├── user_model.dart
│       └── onboarding_page_model.dart
│
├── presentation/                  # Camada de apresentação
│   ├── view_models/               # ViewModels (ChangeNotifier)
│   │   ├── splash_view_model.dart
│   │   ├── onboarding_view_model.dart
│   │   ├── login_view_model.dart
│   │   ├── registration_view_model.dart
│   │   ├── gallery_view_model.dart
│   │   ├── detail_view_model.dart
│   │   └── favorites_view_model.dart
│   ├── widgets/                   # Widgets reutilizáveis
│   │   └── astronomy_card.dart
│   ├── splash_screen.dart
│   ├── onboarding_screen.dart
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── gallery_screen.dart
│   ├── detail_screen.dart
│   └── favorites_screen.dart
│
└── main.dart                      # Entry point
```

## Tecnologias

- **Flutter** 3.x + Dart 3.x
- **Provider** - Gerenciamento de estado (ChangeNotifier)
- **GetIt** - Injeção de dependências
- **HTTP** - Requisições à API NASA
- **SharedPreferences** - Persistência local (auth + favoritos)
- **Google Fonts** - Tipografia (Space Grotesk)
- **Intl** - Formatação de datas
- **Cached Network Image** - Cache de imagens

## API

O projeto utiliza a API NASA APOD:

- **Base URL**: `https://api.nasa.gov`
- **Endpoint**: `/planetary/apod`
- **Documentação**: https://api.nasa.gov/
