# SpaceConnect - Flutter MVVM

Aplicativo Flutter que consome a API NASA APOD (Astronomy Picture of the Day) para exibir imagens astronômicas diárias. Projeto transcrito do app Kotlin com Clean Architecture para Flutter seguindo o padrão **MVVM** com Provider e GetIt.

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

## Mapeamento Kotlin → Flutter

| Kotlin (Clean Architecture)       | Flutter (MVVM)                     |
|-----------------------------------|------------------------------------|
| `domain/model/Astronomy.kt`      | `domain/models/astronomy_model.dart` |
| `data/remote/AstronomyApi.kt`    | `data/services/nasa_api_service.dart` |
| `data/repository/AstronomyRepositoryImpl.kt` | `data/repositories/astronomy_repository.dart` |
| `presentation/list/AstronomyListViewModel.kt` | `presentation/view_models/gallery_view_model.dart` |
| `presentation/list/AstronomyListScreen.kt` | `presentation/gallery_screen.dart` |
| `presentation/detail/AstronomyDetailScreen.kt` | `presentation/detail_screen.dart` |
| `presentation/favorites/AstronomyFavoritesScreen.kt` | `presentation/favorites_screen.dart` |

## Tecnologias

- **Flutter** 3.x + Dart 3.x
- **Provider** - Gerenciamento de estado (ChangeNotifier)
- **GetIt** - Injeção de dependências
- **HTTP** - Requisições à API NASA
- **SharedPreferences** - Persistência local (auth + favoritos)
- **Google Fonts** - Tipografia (Space Grotesk)
- **Intl** - Formatação de datas
- **Cached Network Image** - Cache de imagens

## Funcionalidades

- Splash Screen com animação
- Onboarding com 4 páginas
- Autenticação (Login + Cadastro) com persistência local
- Galeria APOD com busca por intervalo de datas
- Filtro de texto por título/descrição
- Tela de detalhes com imagem hero
- Sistema de favoritos com persistência local
- Navegação inferior (Galeria / Favoritos)

## Como Executar

```bash
# Instalar dependências
flutter pub get

# Executar no modo debug
flutter run

# Executar para web
flutter run -d chrome

# Build para produção (web)
flutter build web
```

## API

O projeto utiliza a API NASA APOD:
- **Base URL**: `https://api.nasa.gov`
- **Endpoint**: `/planetary/apod`
- **Documentação**: https://api.nasa.gov/
