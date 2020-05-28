# Changelog

## 1.0.0 (2020-05-28)

### Backwards incompatible changes
  - rename `handle_in_and_broadcast/2` -> `handle_in_and_broadcast!/2` and `handle_in_and_broadcast_from/2` -> `handle_in_and_broadcast_from!/2` to better express that the underlying code can crash the channel
  - introduce `handle_in_and_broadcast/2` and `handle_in_and_broadcast_from/2` macros that expand to broadcast/broadcast_from invocations

## 0.2.0 (2018-09-23)

### Enhancements
  - expose `handle_in_and_broadcast_from/2` macro

## 0.1.0 (2017-04-24)

### Enhancements
  - expose `handle_in_and_broadcast/2` macro


