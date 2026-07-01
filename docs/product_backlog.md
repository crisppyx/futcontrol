# Product Backlog - FutControl

## Epic 1: Registrar equipos de fútbol

### User Story 1
*As a* administrador del sistema,  
*I want* registrar un nuevo equipo de fútbol,  
*So that* pueda almacenar su información en la base de datos.

### Acceptance Criteria

#### Escenario: Registro exitoso
*Given* que el administrador se encuentra en el formulario de registro y todos los campos obligatorios están completos,  
*When* presiona el botón *Guardar*,  
*Then* el sistema registra el equipo y muestra un mensaje de confirmación.

#### Escenario: Registro no exitoso
*Given* que el administrador deja uno o más campos obligatorios vacíos,  
*When* presiona el botón *Guardar*,  
*Then* el sistema muestra un mensaje de error indicando que debe completar todos los campos y no registra el equipo.

---

## Epic 2: Consultar equipos de fútbol

### User Story 2
*As a* administrador del sistema,  
*I want* consultar los equipos registrados,  
*So that* pueda visualizar y revisar su información.

### Acceptance Criteria

#### Escenario: Consulta exitosa
*Given* que existen equipos registrados en el sistema,  
*When* el administrador accede a la sección de equipos,  
*Then* el sistema muestra la lista completa con la información de cada equipo.

#### Escenario: Consulta no exitosa
*Given* que no existen equipos registrados,  
*When* el administrador accede a la sección de equipos,  
*Then* el sistema muestra el mensaje *"No hay equipos registrados"*.

---

## Epic 3: Actualizar y eliminar equipos

### User Story 3
*As a* administrador del sistema,  
*I want* actualizar o eliminar la información de un equipo,  
*So that* la base de datos permanezca correcta y actualizada.

### Acceptance Criteria

#### Escenario: Actualización exitosa
*Given* que el equipo existe en la base de datos,  
*When* el administrador modifica la información y selecciona *Actualizar*,  
*Then* el sistema guarda los cambios y muestra un mensaje de éxito.

#### Escenario: Actualización no exitosa
*Given* que el administrador intenta actualizar un equipo con información inválida o incompleta,  
*When* presiona *Actualizar*,  
*Then* el sistema muestra un mensaje de error y no guarda los cambios.

#### Escenario: Eliminación exitosa
*Given* que el equipo existe en el sistema,  
*When* el administrador selecciona *Eliminar* y confirma la acción,  
*Then* el sistema elimina el equipo y deja de mostrarlo en la lista.

#### Escenario: Eliminación no exitosa
*Given* que el administrador cancela la eliminación del equipo,  
*When* confirma la cancelación,  
*Then* el sistema conserva el equipo sin realizar cambios
