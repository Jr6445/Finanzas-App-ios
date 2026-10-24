# Finanzas

App personal de control de gastos para iPhone, hecha en Flutter. Registra
automáticamente las compras con Apple Pay mediante una automatización de
Atajos y guarda todo localmente en el iPhone (sin servidores ni cuentas).

- Lista de compras por día, con categoría automática según el comercio.
- Compras manuales (efectivo u otras tarjetas), editar y borrar.
- Categorías y reglas automáticas editables.
- Resumen mensual por categoría, por día y por tarjeta, con presupuestos.
- Respaldo en CSV.

---

## 1. Desarrollo en Windows

Requisitos: Flutter 3.47.8 en el PATH y Visual Studio 2022 con
"Desktop development with C++". En Windows la app usa **datos de prueba**
(comercios de El Salvador) en lugar de las compras reales del iPhone.

```powershell
flutter run -d windows                         # tema según Windows
flutter run -d windows --dart-define=TEMA=claro
flutter run -d windows --dart-define=TEMA=oscuro
flutter test                                   # pruebas
dart run build_runner build                    # tras cambiar lib/core/db/tablas.dart
```

- La app se ve dentro de un marco de iPhone (device_preview; solo en debug).
- Jalar la lista de Compras hacia abajo simula un pago con Apple Pay.
- Para empezar con la base vacía, borra `%USERPROFILE%\Documents\finanzas.sqlite`.

---

## 2. Compilar el .ipa en Codemagic

El iPhone necesita la app compilada en una Mac; Codemagic lo hace en la nube
(tiene minutos gratis cada mes). El archivo `codemagic.yaml` ya trae todo.

### Una sola vez: subir el proyecto a GitHub

```powershell
git init
git add .
git commit -m "Finanzas: primera versión"
# Crea un repositorio PRIVADO vacío en github.com y luego:
git remote add origin https://github.com/TU_USUARIO/finanzas.git
git branch -M main
git push -u origin main
```

### Una sola vez: conectar Codemagic

1. Entra a [codemagic.io](https://codemagic.io) con tu cuenta de GitHub.
2. **Add application** → elige el repositorio `finanzas` → tipo **Flutter App**.
3. Cuando pregunte la configuración, elige **codemagic.yaml** (no el editor
   de workflows).

### Cada vez que quieras una versión nueva

1. Sube tus cambios: `git add . ; git commit -m "..." ; git push`.
2. En Codemagic: **Start new build** → rama `main` → workflow
   **iOS sin firmar (SideStore)**.
3. Tarda unos 10–15 minutos. Al terminar, en **Artifacts** descarga
   **`Finanzas.ipa`**.

El build corre los tests y, al final, **verifica que la acción de Atajos
quedó dentro de la app**. Si ese paso falla, no instales ese .ipa.

---

## 3. Instalar en el iPhone con SideStore

1. Pasa `Finanzas.ipa` al iPhone (AirDrop, iCloud Drive o descárgalo
   directamente desde Codemagic en Safari).
2. En SideStore: pestaña **My Apps** → **+** → elige `Finanzas.ipa`.
3. Si iOS lo pide: **Ajustes → General → VPN y gestión de dispositivos** →
   confía en tu Apple ID.
4. **Abre Finanzas una vez.** Así iOS registra la acción "Registrar compra".

Para **actualizar**, instala el .ipa nuevo igual que la primera vez: SideStore
reemplaza la app y **tus datos se conservan**.

> Con Apple ID gratis, la firma dura 7 días. SideStore la renueva
> (**Refresh All**); si se vence, la app no abre hasta renovarla, pero los
> datos no se pierden.

---

## 4. Configurar la automatización en Atajos

Requiere **iOS 17 o superior** (el disparador "Transacción" no existe en
iOS 16). Los nombres pueden variar un poco según la versión de iOS; entre
paréntesis va el nombre en inglés.

### 4.1 Prueba primero que la acción funciona

1. Abre **Atajos** → pestaña **Atajos** → **+** (nuevo atajo).
2. **Agregar acción** → busca **"Registrar compra"** (aparece bajo la app
   **Finanzas**).
3. Llena los campos con valores fijos: Comercio `Prueba`, Monto `1.23`,
   Tarjeta `Prueba`.
4. Toca ▶︎ para ejecutarlo. No debe abrirse la app.
5. Abre Finanzas: debe aparecer "Prueba" por $1.23 en **Hoy**. Bórrala
   deslizándola a la izquierda.

Si la acción no aparece en el buscador, mira la sección 6.

### 4.2 Crea la automatización

1. **Atajos** → pestaña **Automatización** → **+** (Nueva automatización).
2. Elige **Transacción** (*Transaction*).
3. Configura:
   - **Tarjetas** (*Cards*): selecciona todas tus tarjetas de Apple Pay.
   - Deja categorías y comercios sin filtrar.
   - Marca **Ejecutar inmediatamente** (*Run Immediately*) y, si quieres,
     desactiva **Notificar al ejecutar** (*Notify When Run*).
4. **Siguiente** → **Nuevo atajo en blanco** (*New Blank Automation*).
5. **Agregar acción** → **Registrar compra** (Finanzas).
6. Conecta cada campo con los datos de la transacción. Toca el campo, elige
   la variable **Entrada del atajo** (*Shortcut Input*) y luego toca la
   variable para escoger la propiedad:

   | Campo de la acción | Propiedad de la transacción        |
   |--------------------|------------------------------------|
   | Comercio           | **Comercio** (*Merchant*)          |
   | Monto              | **Importe** (*Amount*)             |
   | Tarjeta            | **Tarjeta o pase** (*Card or Pass*) |

7. **OK**. Listo.

Desde ahora, cada pago con Apple Pay queda guardado. La próxima vez que abras
Finanzas (o vuelvas a ella) la compra aparece con su categoría asignada por
las reglas.

---

## 5. Cómo funciona por dentro

```
Pago con Apple Pay
   └─► Automatización "Transacción" (Atajos)
         └─► Acción "Registrar compra"      ios/Runner/AppDelegate.swift
               └─► UserDefaults["flutter.compras_pendientes"]  (lista de JSON)
                     └─► Al abrir / volver a la app:
                           FuenteComprasIOS   lib/features/compras/data/
                           └─► ImportadorCompras (asigna categoría por reglas)
                                 └─► SQLite (drift)   lib/core/db/
```

- **Sin duplicados:** cada compra lleva un id (UUID) generado en el iPhone; si
  se importa dos veces, la base la ignora. Solo se quitan de la lista las
  compras ya importadas.
- **Monto:** Atajos lo manda como texto con el formato de tu región
  (`US$12.50`, `12,50`...). Lo interpreta `interpretarMontoDeAtajos` en
  `lib/core/format/formato.dart`. Si no se entiende, la compra se importa con
  $0.00 para que la corrijas a mano en vez de perderla.
- **Fuera del iPhone** (Windows, Chrome, Android) se usa
  `FuenteComprasFake` con datos de prueba.

Estructura principal:

```
lib/
  core/        base de datos, tema y paleta pastel, formatos, widgets comunes
  features/
    compras/       lista, formulario, importación (fake e iOS)
    categorias/    categorías y reglas automáticas
    presupuestos/  presupuesto mensual por categoría
    resumen/       resumen mensual, gráficas y detalle por categoría/tarjeta
    exportar/      respaldo CSV
    ajustes/
  shell/       pestañas
ios/Runner/AppDelegate.swift   acción "Registrar compra" (App Intent)
codemagic.yaml                 compilación del .ipa sin firmar
```

---

## 6. Solución de problemas

**"Registrar compra" no aparece en Atajos**
1. Abre Finanzas al menos una vez después de instalarla.
2. Reinicia el iPhone (iOS a veces tarda en registrar acciones nuevas).
3. Revisa que el build de Codemagic haya pasado el paso **Verificar el .ipa**.

**La compra no aparece en Finanzas**
- Cierra Finanzas por completo y vuelve a abrirla, o jala la lista hacia abajo.
- En Atajos → Automatización, revisa que la automatización esté activada y
  en **Ejecutar inmediatamente**.

**El monto llega en $0.00**
- Edita la compra para corregirla. Revisa que el campo Monto de la acción
  esté conectado a **Importe** (*Amount*).

**El build de Codemagic falla**
- *"Flutter version 3.47.8 is not available"*: en `codemagic.yaml` cambia
  `flutter: 3.47.8` por `flutter: stable`.
- Error en el paso **Compilar iOS**: el log indica el archivo y la línea
  (normalmente `ios/Runner/AppDelegate.swift`). Los logs completos de Xcode
  quedan en Artifacts.

**Respaldo**
- Ajustes → **Exportar a CSV** genera dos archivos (compras y categorías)
  que puedes guardar en Archivos o enviarte por correo. Hazlo de vez en
  cuando: si borras la app, sus datos se borran con ella.
