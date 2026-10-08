# Spec - Reservas de Sala

## Objetivo
Como estudiante autenticado, quiero reservar una sala por un intervalo de tiempo para
utilizarla cuando la necesite.

## Reglas
- La hora de fin debe ser posterior a la hora de inicio; de lo contrario, se rechaza con el
  mensaje "La hora de fin debe ser posterior a la de inicio".
- Dos reservas de la misma sala no pueden ocupar ningún tramo de tiempo en común.
- Los intervalos incluyen la hora de inicio y excluyen la hora de fin; dos reservas que
  terminan y empiezan en el mismo instante son consecutivas y no se solapan.
- La coincidencia de horarios en salas distintas no impide aceptar ninguna de las reservas.
- Una solicitud rechazada por solapamiento muestra exactamente este mensaje:
  "La sala ya se encuentra reservada en el horario seleccionado."
- Al rechazarse una solicitud por solapamiento, la reserva existente permanece sin cambios y
  la nueva solicitud no se registra.

## Escenarios

### Escenario 1: Reserva válida
- Dado que la Sala A está disponible
- Cuando el estudiante solicita reservarla de 09:00 a 10:00
- Entonces la reserva se acepta y queda registrada a su nombre

### Escenario 2: Fin anterior al inicio
- Dado que el estudiante solicita reservar la Sala A de 10:00 a 09:00
- Cuando intenta confirmar la reserva
- Entonces se rechaza con el mensaje "La hora de fin debe ser posterior a la de inicio"

### Escenario 3: Solapamiento parcial
- Dado que existe una reserva para la Sala A de 10:00 a 11:00
- Cuando se solicita otra reserva para la Sala A de 09:30 a 10:30
- Entonces se rechaza con el mensaje "La sala ya se encuentra reservada en el horario seleccionado."
- Y la reserva existente permanece sin cambios y la nueva no se registra

### Escenario 4: La nueva reserva cubre la existente
- Dado que existe una reserva para la Sala A de 10:00 a 11:00
- Cuando se solicita otra reserva para la Sala A de 09:00 a 12:00
- Entonces se rechaza con el mensaje "La sala ya se encuentra reservada en el horario seleccionado."
- Y la reserva existente permanece sin cambios y la nueva no se registra

### Escenario 5: La nueva reserva está contenida
- Dado que existe una reserva para la Sala A de 09:00 a 12:00
- Cuando se solicita otra reserva para la Sala A de 10:00 a 11:00
- Entonces se rechaza con el mensaje "La sala ya se encuentra reservada en el horario seleccionado."
- Y la reserva existente permanece sin cambios y la nueva no se registra

### Escenario 6: Reservas consecutivas
- Dado que existe una reserva para la Sala A de 10:00 a 11:00
- Cuando se solicita otra reserva para la Sala A de 11:00 a 12:00
- Entonces la nueva reserva se acepta y queda registrada

### Escenario 7: El mismo horario en otra sala
- Dado que existe una reserva para la Sala A de 10:00 a 11:00
- Cuando se solicita una reserva para la Sala B de 10:00 a 11:00
- Entonces la nueva reserva se acepta y queda registrada
