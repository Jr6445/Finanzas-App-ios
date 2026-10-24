# Finanzas

App personal de control de gastos para iPhone, hecha en Flutter. Registra
automáticamente las compras con Apple Pay mediante una automatización de
Atajos y guarda todo localmente en el iPhone (sin servidores ni cuentas en
línea).

- **Compras:** lista por día, con categoría automática según el comercio;
  compras manuales (efectivo u otras tarjetas), editar y borrar.
- **Resumen:** gasto del mes por categoría, por día y por cuenta, con
  presupuestos por categoría y detalle de cada categoría o cuenta.
- **Cuentas:** saldo de débito y efectivo; en tarjetas de crédito, deuda,
  límite, corte, pago pendiente y aviso antes de la fecha límite. Depósitos,
  transferencias, pagos de tarjeta y ajustes.
- **Ajustes:** categorías, reglas automáticas, presupuestos y respaldo CSV.

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
- Las notificaciones de pago solo se programan en el iPhone.
- Para empezar con la base vacía, borra `%USERPROFILE%\Documents\finanzas.sqlite`.
- Si `flutter build windows` falla sin explicación, revisa que la app no
  esté abierta: Windows no deja reemplazar un `.exe` en uso.

---

## 2. Compilar el .ipa en Codemagic

El iPhone necesita la app compilada en una Mac; Codemagic lo hace en la nube
(tiene minutos gratis cada mes). El archivo `codemagic.yaml` ya trae todo.
El repositorio está en GitHub: `Jr6445/Finanzas-App-ios` (privado).

### Una sola vez: conectar Codemagic

1. Entra a [codemagic.io](https://codemagic.io) con tu cuenta de GitHub.
2. **Add application** → elige `Finanzas-App-ios` → tipo **Flutter App**.
3. Cuando pregunte la configuración, elige **codemagic.yaml** (no el editor
   de workflows).

### Cada vez que quieras una versión nueva

1. Sube tus cambios:
   ```powershell
   git add .
   git commit -m "Describe el cambio"
   git push
   ```
2. En Codemagic: **Start new build** → rama `main` → workflow
   **iOS sin firmar (SideStore)**. Deja **SSH/VNC** desactivado.
3. Tarda unos 10–15 minutos. Al terminar, en **Artifacts** descarga
   **`Finanzas.ipa`**.

El build corre los tests y, al final, **verifica que la acción de Atajos
quedó dentro de la app**. Si ese paso falla, no instales ese .ipa.

---

## 3. Instalar en el iPhone con SideStore

### Una sola vez: instalar SideStore

SideStore no está en la App Store; se instala desde la PC una sola vez.

1. En la PC: instala **iTunes** (de la página de Apple) y
   [**iloader**](https://docs.sidestore.io/docs/installation/prerequisites).
2. Conecta el iPhone por USB, confía en la computadora, inicia sesión en
   iloader con tu Apple ID e instala **SideStore (Stable)**.
3. En el iPhone:
   - **Ajustes → General → VPN y gestión de dispositivos** → confía en tu
     Apple ID.
   - **Ajustes → Privacidad y seguridad → Modo de desarrollador** → activar.
   - Instala **LocalDevVPN** de la App Store. Debe estar **conectada** cada
     vez que SideStore instale o renueve apps.

### Instalar o actualizar Finanzas

1. En el iPhone, abre Codemagic en Safari → tu build → **Artifacts** →
   descarga **Finanzas.ipa** (queda en Archivos → Descargas).
2. Con LocalDevVPN conectada y en Wi-Fi: SideStore → **My Apps** → **+** →
   elige `Finanzas.ipa`.
3. **Abre Finanzas una vez.** Así iOS registra la acción "Registrar compra".

Para **actualizar**, instala el .ipa nuevo igual: SideStore reemplaza la app
y **tus datos se conservan** (la base de datos se migra sola a la versión
nueva).

> Con Apple ID gratis puedes tener **3 apps firmadas** (SideStore cuenta como
> una) y la firma dura **7 días**: abre SideStore con la VPN conectada y toca
> **Refresh All** antes de que venza. Si se vence, la app no abre hasta
> renovarla, pero los datos no se pierden.

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
   deslizándola a la izquierda. (También se habrá creado una cuenta "Prueba"
   sin configurar; bórrala en Cuentas → Prueba → Editar → Borrar cuenta.)

Si la acción no aparece en el buscador, mira la sección 7.

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
las reglas y asociada a la cuenta de esa tarjeta.

---

## 5. Usar la app

### Compras
- **+** agrega una compra manual (efectivo, transferencias, otras tarjetas):
  comercio, monto, **cuenta** (se propone la última que usaste), categoría
  (se sugiere sola según el comercio) y fecha.
- Toca una compra para editarla; deslízala a la izquierda para borrarla.

### Resumen
- Elige el mes con las flechas. Verás el total, la barra por categorías, el
  gasto por día y por cuenta.
- Toca una categoría o una cuenta para ver todas sus compras de ese mes.
- Si una categoría tiene presupuesto, verás cuánto queda o cuánto te pasaste.

### Cuentas
Arriba, el **total disponible** (débito + efectivo) y la **deuda en
tarjetas**. Cada cuenta se muestra como una tarjeta de Wallet.

**Configurar una cuenta.** Con la primera compra de cada tarjeta, Finanzas
crea la cuenta como **"Sin configurar"**. Tócala → **Editar** y elige:

- **Débito / Efectivo:** el saldo que tienes **hoy**.
- **Crédito:** la deuda de **hoy**, el límite, el **día de corte**, el **día
  límite de pago** y con cuántos días de anticipación quieres el aviso.

También puedes crear cuentas a mano con **+** (por ejemplo, "Efectivo").

> El saldo que escribes es el punto de partida: solo cuentan los movimientos
> posteriores, así las compras viejas no se restan dos veces.

**Nombres en Apple Pay.** Si la tarjeta llega desde Atajos con otro nombre
(p. ej. "Visa ••4821"), escríbelo en ese campo de la cuenta para que sus
compras se asocien solas.

**Mantener el saldo real** (desde el detalle de la cuenta):

| Botón | Para qué | Efecto |
|---|---|---|
| **Depósito** | Salario, transferencias que recibes | Sube el saldo |
| **Transferir** | Retirar efectivo (débito → Efectivo) | Sale de una cuenta, entra en otra |
| **Pagar** (crédito) | Abonar a la tarjeta desde tu débito | Baja la deuda y el saldo de la débito |
| **Ajustar saldo / deuda** | Igualar con lo que dice tu banco | Guarda la diferencia como ajuste |

Las transferencias y los pagos de tarjeta **no cuentan como gasto** en el
Resumen: el gasto ya se contó cuando hiciste la compra.

**Tarjetas de crédito.** Con el día de corte y de pago, el detalle muestra:
- **Saldo al corte:** lo que debías al cerrar el último corte.
- **Abonado:** lo que pagaste después de ese corte.
- **Pendiente de pagar:** lo que falta, con la fecha límite. Si ya pasó,
  la tarjeta lo marca como **Vencido** en rojo.
- **Compras del ciclo actual:** lo que entrará en el próximo corte.

**Recordatorio de pago.** Si queda algo pendiente, llega una notificación a
las 9:00 los días que elegiste antes de la fecha límite. La primera vez, iOS
pide permiso para mostrar notificaciones.

### Ajustes
- **Categorías** y **Reglas automáticas** ("si el comercio contiene…").
- **Presupuestos** mensuales por categoría.
- **Exportar a CSV:** respaldo de todo (ver sección 7).

---

## 6. Cómo funciona por dentro

```
Pago con Apple Pay
   └─► Automatización "Transacción" (Atajos)
         └─► Acción "Registrar compra"      ios/Runner/AppDelegate.swift
               └─► UserDefaults["flutter.compras_pendientes"]  (lista de JSON)
                     └─► Al abrir / volver a la app:
                           FuenteComprasIOS   lib/features/compras/data/
                           └─► ImportadorCompras
                                 ├─ categoría según las reglas
                                 ├─ cuenta según el nombre de la tarjeta
                                 │  (o crea una "Sin configurar")
                                 └─► SQLite (drift)   lib/core/db/
```

- **Sin duplicados:** cada compra lleva un id (UUID) generado en el iPhone; si
  se importa dos veces, la base la ignora. Solo se quitan de la lista las
  compras ya importadas.
- **Monto:** Atajos lo manda como texto con el formato de tu región
  (`US$12.50`, `12,50`...). Lo interpreta `interpretarMontoDeAtajos` en
  `lib/core/format/formato.dart`. Si no se entiende, la compra se importa con
  $0.00 para que la corrijas a mano en vez de perderla.
- **Saldos:** se calculan, no se guardan: saldo inicial + depósitos y
  transferencias recibidas − compras − transferencias enviadas ± ajustes
  (`lib/features/cuentas/domain/estado_cuenta.dart`). En crédito el mismo
  cálculo da la deuda.
- **Recordatorios:** notificaciones locales (`flutter_local_notifications`)
  que programa la propia app; no usan push, por eso funcionan con Apple ID
  gratis. Se reprograman cada vez que cambian saldos o cortes.
- **Base de datos:** versión 3. Las versiones anteriores se migran solas al
  abrir la app (`lib/core/db/base_datos.dart`).
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
    resumen/       resumen mensual, gráficas y detalle por categoría/cuenta
    cuentas/       cuentas, movimientos, saldos, cortes y recordatorios
    exportar/      respaldo CSV
    ajustes/
  shell/       pestañas
ios/Runner/AppDelegate.swift   acción "Registrar compra" (App Intent) y
                               configuración de notificaciones
codemagic.yaml                 compilación del .ipa sin firmar
```

---

## 7. Solución de problemas

**SideStore: "Failed to Sign In (-80045)"**
Es un fallo del lado de Apple que afecta a varias herramientas. Lo que
funcionó: SideStore → **Settings → Advanced Settings → Anisette Servers** →
elegir otro servidor (p. ej. **SideStore (New)**), luego **User
Customizations → Reset adi.pb**, cerrar SideStore por completo y volver a
iniciar sesión con LocalDevVPN conectada. Si no, probar otro servidor de la
lista.

**"Registrar compra" no aparece en Atajos**
1. Abre Finanzas al menos una vez después de instalarla.
2. Reinicia el iPhone (iOS a veces tarda en registrar acciones nuevas).
3. Revisa que el build de Codemagic haya pasado el paso **Verificar el .ipa**.

**La compra no aparece en Finanzas**
- Cierra Finanzas por completo y vuelve a abrirla, o jala la lista hacia abajo.
- En Atajos → Automatización, revisa que la automatización esté activada y
  en **Ejecutar inmediatamente**.

**La compra quedó en una cuenta "Sin configurar" nueva en vez de la mía**
- Apple Pay mandó la tarjeta con otro nombre. Agrega ese nombre en
  **Nombres en Apple Pay** de tu cuenta, cambia la cuenta de esas compras
  (tócalas → Cuenta) y borra la cuenta sobrante.

**El saldo no coincide con el banco**
- Revisa que hayas registrado depósitos y retiros. Para corregirlo, usa
  **Ajustar saldo** (o **Ajustar deuda**) con el valor del banco.

**No llega el recordatorio de pago**
- Revisa **Ajustes de iOS → Finanzas → Notificaciones** (activadas).
- La tarjeta debe tener día de corte, día de pago y un aviso distinto de
  "No", y algo **pendiente** del último corte.
- Abre Finanzas después de cambiar algo: los avisos se reprograman al abrir.

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
- Ajustes → **Exportar a CSV** genera cuatro archivos (compras, categorías,
  cuentas y movimientos) que puedes guardar en Archivos o enviarte por
  correo. Hazlo de vez en cuando: si borras la app, sus datos se borran con
  ella.
