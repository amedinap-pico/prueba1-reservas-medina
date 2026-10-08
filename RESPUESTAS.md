## Escenarios que elegí y por qué

Elegí los tres casos nuevos de rechazo: solapamiento parcial (specs/001-reservas-sala/spec.md:28), solicitud que cubre la reserva existente (specs/001-reservas-sala/spec.md:34) y solicitud contenida (specs/001-reservas-sala/spec.md:40). Las pruebas usan intervalos concretos para cada relación (test/crear_reserva_test.dart:47, test/crear_reserva_test.dart:54; test/crear_reserva_test.dart:70, test/crear_reserva_test.dart:77; test/crear_reserva_test.dart:93, test/crear_reserva_test.dart:100). La spec fija el mensaje exacto para el rechazo (specs/001-reservas-sala/spec.md:12). También aclara que tocarse en un extremo o coincidir en otra sala no se rechaza (specs/001-reservas-sala/spec.md:46, specs/001-reservas-sala/spec.md:51; test/crear_reserva_test.dart:112, test/crear_reserva_test.dart:131).

## Riesgo más grave del repositorio

El README recomienda poner la clave `service_role` en la configuración usada por la app (README.md:19, README.md:20). Si se compila esa clave privilegiada dentro del cliente distribuido, puede extraerse y comprometer los datos de Supabase; la propia constitución exige que no se incluyan secretos en el repositorio (.specify/memory/constitution.md:17).

## ¿La regla protege la app real?

Actualmente, no: `main` inyecta `CrearReserva` en la pantalla (lib/main.dart:14), pero el botón inserta directamente en Supabase (lib/presentation/reserva_page.dart:60), omitiendo la comprobación del dominio (lib/domain/crear_reserva.dart:16). La migración valida que el fin sea posterior al inicio, pero no impide solapamientos (supabase/migracion.sql:11). Además, la consulta y el guardado son operaciones separadas (lib/domain/crear_reserva.dart:16, lib/domain/crear_reserva.dart:31), así que dos solicitudes concurrentes podrían pasar ambas. Una restricción atómica en la base de datos daría esa garantía.
