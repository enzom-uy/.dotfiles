# 🍅 Bunnipom Plugin - Implementation Guide

Este documento te guiará paso a paso para implementar el plugin de pomodoro integrado con el script `pom` de Bashbunni.

---

## 🎯 Objetivo

Crear un plugin de Noctalia que:
- Inicie sesiones de pomodoro desde el Launcher (25/5 o 50/10)
- Muestre un contador en tiempo real en la barra
- Se comunique bidireccionalmente con el script `pom` vía IPC
- Solo aparezca en la barra cuando hay una sesión activa

---

## 📋 Prerequisitos

Antes de empezar, verifica:

1. **Comando timer**: Averigua qué es `timer` en tu shell
   ```bash
   type timer
   which timer
   ```

2. **Ubicación de la función pom**: Encuentra dónde está definida
   ```bash
   grep -r "^pom()" ~/.*rc ~/.config/zsh 2>/dev/null
   ```

3. **IPC de Noctalia**: Prueba que funciona
   ```bash
   qs -c noctalia-shell ipc call plugin:bunnipom testPom
   ```

---

## 🏗️ Arquitectura General

```
Usuario selecciona sesión en Launcher
           ↓
    Main.qml recibe IPC
           ↓
    Ejecuta script pom con POMO_SPLIT
           ↓
    Script pom envía updates vía IPC
           ↓
    BarWidget muestra contador
```

---

## 📝 Fases de Implementación

### Fase 1: Estado y Comunicación IPC Básica

#### 1.1 Modificar `Main.qml`

**Objetivo**: Crear handlers IPC para manejar el estado del plugin

**Tareas**:
- [ ] Agregar función IPC `startSession(workMinutes, breakMinutes)`
  - Guardar `workMinutes`, `breakMinutes` en `pluginSettings`
  - Setear `isActive: true`
  - Ejecutar el script pom con variable de entorno `POMO_SPLIT`
  - Guardar PID del proceso

- [ ] Agregar función IPC `updateTimer(remainingSeconds, phase)`
  - `phase` puede ser "work" o "break"
  - Actualizar `remainingSeconds` y `phase` en `pluginSettings`
  - Llamar `pluginApi.saveSettings()` para que el widget se actualice

- [ ] Agregar función IPC `sessionEnded()`
  - Setear `isActive: false`
  - Limpiar el estado
  - Guardar settings

- [ ] Agregar función IPC `cancelSession()`
  - Matar el proceso pom (usar el PID guardado)
  - Llamar internamente a `sessionEnded()`

**Propiedades del estado que necesitas**:
```javascript
pluginSettings = {
  isActive: boolean,        // ¿Hay sesión activa?
  phase: string,           // "work" o "break"
  remainingSeconds: int,   // Tiempo restante
  workMinutes: int,        // Duración del trabajo
  breakMinutes: int,       // Duración del break
  pomPid: int              // PID del proceso
}
```

**Pistas**:
- Usa `Quickshell.Process` para ejecutar el script y obtener el PID
- Para matar un proceso: busca cómo hacerlo con Quickshell o bash

**Cómo probar**:
```bash
# Iniciar sesión
qs -c noctalia-shell ipc call plugin:bunnipom startSession 25 5

# Simular update del timer
qs -c noctalia-shell ipc call plugin:bunnipom updateTimer 1500 work

# Ver el estado guardado
cat ~/.config/noctalia/plugins/bunnipom/settings.json

# Terminar sesión
qs -c noctalia-shell ipc call plugin:bunnipom sessionEnded
```

---

#### 1.2 Modificar `BarWidget.qml`

**Objetivo**: Mostrar contador básico que reaccione al estado

**Tareas**:
- [ ] Hacer que el widget sea visible solo cuando `isActive == true`
  - Bindear la propiedad `visible` al estado

- [ ] Mostrar el icono según la fase
  - 🍅 (o icono "clock") para "work"
  - ☕ (o icono "coffee") para "break"

- [ ] Mostrar el tiempo en formato MM:SS
  - Convertir `remainingSeconds` a minutos y segundos
  - Formatear con padding (ej: 05:03, no 5:3)

- [ ] Agregar un Timer QML que decremente localmente
  - Interval: 1000ms (1 segundo)
  - Running: solo cuando el widget es visible
  - onTriggered: decrementar `remainingSeconds` localmente

**Layout sugerido**:
```
┌──────────────┐
│ 🍅  23:45   │
└──────────────┘
```

**Pistas**:
- Para formatear tiempo: `Math.floor(seconds / 60)` para minutos, `seconds % 60` para segundos
- Para padding: busca cómo agregar ceros a la izquierda en QML/JavaScript
- El widget debe leer el estado de `pluginApi.pluginSettings`

**Cómo probar**:
```bash
# Activar el widget con 10 minutos
qs -c noctalia-shell ipc call plugin:bunnipom updateTimer 600 work

# Deberías ver aparecer el widget en la barra con "10:00"
# Debería decrementar automáticamente

# Cambiar a break
qs -c noctalia-shell ipc call plugin:bunnipom updateTimer 300 break

# Ocultar el widget
qs -c noctalia-shell ipc call plugin:bunnipom sessionEnded
```

---

### Fase 2: Integración con LauncherProvider

#### 2.1 Modificar `LauncherProvider.qml`

**Objetivo**: Agregar opciones para iniciar sesiones desde el launcher

**Tareas**:
- [ ] Implementar función `getResults(searchText)`
  - Si `searchText` es `">bunnipom"` o `">bunnipom "`, retornar array con dos opciones:
    1. "25/5 work session" (25 min trabajo, 5 min break)
    2. "50/10 work session" (50 min trabajo, 10 min break)

- [ ] Configurar cada resultado con:
  - `name`: Nombre descriptivo de la sesión
  - `description`: Explicación (ej: "25 minutes work, 5 minutes break")
  - `icon`: Un icono apropiado (ej: "clock", "clock-play", "apple")
  - `isTablerIcon: true`
  - `onActivate`: Función que:
    1. Llame a la función IPC `startSession(work, break)` del Main.qml
    2. Cierre el launcher con `launcher.close()`
    3. Opcionalmente muestre un Toast de confirmación

**Pistas**:
- Para llamar IPC desde QML necesitas acceso a `pluginApi`
- Busca en la documentación de Noctalia cómo un componente QML llama IPC internamente
- Alternativa: Usar señales/métodos del `pluginApi` si lo expone

**Cómo probar**:
1. Abre el launcher (Super+Space)
2. Escribe `>bunnipom`
3. Deberías ver dos opciones: 25/5 y 50/10
4. Selecciona una
5. El widget debería aparecer en la barra con el contador

---

### Fase 3: Modificar el Script `pom`

**Objetivo**: Hacer que el script notifique a Noctalia sobre el estado del timer

#### 3.1 Identificar cómo funciona `timer`

**Tareas**:
- [ ] Descubrir qué es el comando `timer` en tu sistema
- [ ] Ver si es una función, alias, o comando externo
- [ ] Entender cómo funciona (¿usa sleep? ¿termdown? ¿otro tool?)

**Comandos útiles**:
```bash
type timer
declare -f timer
which timer
```

---

#### 3.2 Agregar notificaciones IPC al script `pom`

**Objetivo**: Enviar actualizaciones periódicas a Noctalia

**Tareas**:
- [ ] Al inicio de una fase (work o break), enviar IPC con tiempo total
  ```bash
  # Ejemplo conceptual (no código exacto):
  qs -c noctalia-shell ipc call plugin:bunnipom updateTimer <segundos> <fase>
  ```

- [ ] Durante el timer, enviar actualizaciones cada 10 segundos
  - Opción A: Modificar la función `timer` para que emita updates
  - Opción B: Crear un loop paralelo que calcule tiempo restante y envíe updates

- [ ] Al terminar una fase, enviar el inicio de la siguiente fase
  - Después de `notify-send "Work Timer is up!"`, enviar IPC para iniciar break
  - Después de break, enviar IPC `sessionEnded`

- [ ] Capturar Ctrl+C para limpiar estado
  ```bash
  trap 'qs -c noctalia-shell ipc call plugin:bunnipom sessionEnded' INT TERM
  ```

**Desafío**: El script usa la variable `POMO_SPLIT` para saltar el diálogo. Asegúrate de que:
- Cuando `POMO_SPLIT=25/5`, el script funcione sin interacción
- Las notificaciones IPC se envíen correctamente en modo automático

**Ubicaciones clave en el script donde agregar IPC**:
1. Después de determinar `work` y `break` (línea ~23-24)
2. Después de iniciar `timer "$work"` (necesitas wrappear o modificar timer)
3. Después de `notify-send "Work Timer is up!"`
4. Después de iniciar `timer "$break"`
5. Después de `notify-send "Break is over!"`
6. En el trap de señales

---

### Fase 4: Sincronización y Polish

#### 4.1 Sincronizar widget con script real

**Problema**: El widget cuenta hacia abajo localmente, pero puede desincronizarse con el script.

**Solución**:
- [ ] Cuando llega un IPC `updateTimer`, comparar con el valor local
- [ ] Si la diferencia es > 2 segundos, sincronizar (tomar el valor del script como verdadero)
- [ ] Si la diferencia es < 2 segundos, ignorar (el countdown local está bien)

---

#### 4.2 Mejorar visualización del widget

**Tareas opcionales**:
- [ ] Cambiar color del widget según fase
  - Work: Color primario (ej: rojo, naranja)
  - Break: Color secundario (ej: verde, azul)

- [ ] Agregar tooltip al hacer hover
  - Mostrar: "25/5 session - Work phase" o "Break phase"

- [ ] Agregar clic derecho para cancelar
  - Al hacer right click, llamar IPC `cancelSession()`
  - Mostrar confirmación opcional

- [ ] Agregar animación suave cuando el widget aparece/desaparece

---

#### 4.3 Crear `Settings.qml`

**Objetivo**: Permitir configuración del plugin

**Opciones sugeridas**:
- [ ] Toggle: "Show seconds" (mostrar 05:00 vs 5:00)
- [ ] Toggle: "Play sound on phase change"
- [ ] ColorPicker: "Work phase color"
- [ ] ColorPicker: "Break phase color"
- [ ] TextInput: "Default pomodoro split" (25/5, 50/10, o custom)

**Pista**: Busca en otros plugins de Noctalia ejemplos de `Settings.qml`

---

## 🧪 Testing Completo

### Test 1: Iniciar desde Launcher
1. Abre launcher, escribe `>bunnipom`
2. Selecciona "25/5 work session"
3. Verifica que el widget aparece con 🍅 25:00
4. Espera que el contador decremente
5. Espera 25 minutos (o cancela con right click)
6. Verifica transición a break (☕ 05:00)

### Test 2: Iniciar desde Terminal
1. Abre terminal, ejecuta `pom`
2. Elige "25/5" en el TUI
3. Verifica que el widget aparece
4. Verifica que el contador sincroniza con el script

### Test 3: Cancelar sesión
1. Inicia una sesión
2. Right click en el widget
3. Verifica que el widget desaparece
4. Verifica que el script se detiene

### Test 4: Reinicio de Noctalia durante sesión
1. Inicia una sesión
2. Reinicia Noctalia Shell
3. Verifica comportamiento (actualmente: se pierde el estado)
4. Mejora opcional: Persistir estado en archivo temporal

---

## 🐛 Troubleshooting

### El widget no aparece
- Verifica que `isActive` está en `true` en settings.json
- Verifica que el binding `visible:` está correcto
- Revisa logs de Quickshell

### El contador no decrementa
- Verifica que el Timer QML está running
- Verifica que `remainingSeconds > 0`

### IPC no funciona desde el script
- Verifica que `qs` está en tu PATH
- Prueba el comando IPC manualmente desde terminal
- Revisa que la sintaxis IPC es correcta

### El script no encuentra POMO_SPLIT
- Verifica que la variable se pasa correctamente al proceso
- Usa `export POMO_SPLIT=25/5` antes de ejecutar

---

## 📚 Recursos

- [Documentación de Noctalia Launcher Providers](https://opencode.ai/docs)
- [Quickshell Process API](busca en la doc de Quickshell)
- [IPC de Noctalia](busca ejemplos en otros plugins)

---

## 🎉 Siguientes Mejoras (Post-MVP)

Una vez que todo funcione, puedes agregar:
- [ ] Historial de sesiones completadas
- [ ] Estadísticas (sesiones por día, tiempo total)
- [ ] Notificaciones personalizadas
- [ ] Múltiples presets de pomodoro
- [ ] Integración con calendar/tasks
- [ ] Sonidos personalizados
- [ ] Modo "focus" (DND durante work phase)

---

## 📝 Notas

- Guarda este archivo como referencia durante la implementación
- Marca las tareas completadas con `[x]` a medida que avanzas
- No dudes en ajustar el plan según descubras cosas nuevas
- ¡Diviértete aprendiendo QML y la arquitectura de Noctalia!

---

**Fecha de creación**: ${new Date().toISOString().split('T')[0]}
**Versión del plan**: 1.0
