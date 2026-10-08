import 'package:flutter_test/flutter_test.dart';
import 'package:reservas_sala/domain/crear_reserva.dart';
import 'package:reservas_sala/domain/reserva.dart';

import 'support/reservas_en_memoria.dart';

DateTime hora(int h, [int m = 0]) => DateTime(2026, 10, 14, h, m);

void main() {
  late ReservasEnMemoria repositorio;
  late CrearReserva crearReserva;

  setUp(() {
    repositorio = ReservasEnMemoria();
    crearReserva = CrearReserva(repositorio);
  });

  test('acepta una reserva válida y la guarda', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(10),
    ));

    expect(resultado.aceptada, isTrue);
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva cuyo fin no es posterior al inicio', () async {
    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(9),
    ));

    expect(resultado.aceptada, isFalse);
    expect(resultado.mensaje, 'La hora de fin debe ser posterior a la de inicio');
    expect(repositorio.reservas, isEmpty);
  });

  test('rechaza un solapamiento parcial en la misma sala', () async {
    await repositorio.guardar(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(11),
    ));

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u2',
      inicio: hora(9, 30),
      fin: hora(10, 30),
    ));

    expect(resultado.aceptada, isFalse);
    expect(
      resultado.mensaje,
      'La sala ya se encuentra reservada en el horario seleccionado.',
    );
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza un solapamiento total en la misma sala', () async {
    await repositorio.guardar(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(10),
      fin: hora(11),
    ));

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u2',
      inicio: hora(9),
      fin: hora(12),
    ));

    expect(resultado.aceptada, isFalse);
    expect(
      resultado.mensaje,
      'La sala ya se encuentra reservada en el horario seleccionado.',
    );
    expect(repositorio.reservas, hasLength(1));
  });

  test('rechaza una reserva contenida en otra de la misma sala', () async {
    await repositorio.guardar(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u1',
      inicio: hora(9),
      fin: hora(12),
    ));

    final resultado = await crearReserva(SolicitudReserva(
      salaId: 'Sala A',
      usuarioId: 'u2',
      inicio: hora(10),
      fin: hora(11),
    ));

    expect(resultado.aceptada, isFalse);
    expect(
      resultado.mensaje,
      'La sala ya se encuentra reservada en el horario seleccionado.',
    );
    expect(repositorio.reservas, hasLength(1));
  });
}
