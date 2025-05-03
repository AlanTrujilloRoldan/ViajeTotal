## ViajeTotal
Viaje total para ayudarte en la totalidad de tu viaje!!

## 🏗️ Instalación
1. **Clonar el repositorio**:
   ```sh
   git clone https://github.com/AlanTrujilloRoldan/viajetotal.git

2. **Instalar dependencias**:
    ```sh
    flutter pub get

3. **Ejecutar la aplicación**:
    ```sh
    flutter run

# 📌 Estructura del Proyecto

📂 **lib/**  
   ├── 🏠 **main.dart** - Punto de entrada de la aplicación.  

📂 **screens/**  
   ├── 🏡 home_screen.dart - Pantalla de inicio.  
   ├── ✈️ trip_planning_screen.dart - Planeación de viajes.  
   ├── 🌍 local_recommendations_screen.dart - Recomendaciones locales.  
   ├── 📖 travel_journal_screen.dart - Diario de viaje.  
   ├── 🗺️ maps_navigation_screen.dart - Navegación con mapas.  
   ├── ⭐ reviews_ratings_screen.dart - Reseñas y calificaciones.  
   ├── 📌 destination_details_screen.dart - Detalles de destinos.  

📂 **widgets/**  
   ├── 🏝️ destination_card.dart - Tarjeta de destino.  
   ├── 📅 trip_timeline.dart - Línea de tiempo del viaje.  
   ├── ⭐ rating_bar.dart - Barra de calificación.  
   ├── 📝 journal_entry.dart - Entrada de diario.  
   ├── 🗺️ map_preview.dart - Vista previa de mapas.  
   ├── 🔎 search_bar.dart - Barra de búsqueda.  
   ├── 🖼️ photo_gallery.dart - Galería de fotos.  
   ├── ⏳ activity_indicator.dart - Indicador de actividad.  
   ├── 🏷️ tag_selector.dart - Selector de etiquetas.  
   ├── 💰 budget_progress.dart - Progreso del presupuesto.  

📂 **models/**  
   ├── 🏖️ trip.dart - Modelo de viaje.  
   ├── 📍 destination.dart - Modelo de destino.  
   ├── 🎯 recommendation.dart - Modelo de recomendación.  
   ├── 📝 journal_entry.dart - Modelo de entrada de diario.  

📂 **services/**  
   ├── ✈️ trip_service.dart - Servicio de gestión de viajes.  
   ├── 📍 location_service.dart - Servicio de geolocalización.  
   ├── 🗺️ maps_service.dart - Servicio de integración con mapas.  
   ├── 🔗 api_service.dart - Servicio de conexión con API externa.  

📂 **utils/**  
   ├── ⚙️ constants.dart - Variables globales y constantes.  
   ├── 🛠️ helpers.dart - Funciones auxiliares.  

📂 **theme/**  
   ├── 🎨 app_theme.dart - Definición de temas.  
   ├── 🎨 colors.dart - Paleta de colores.  