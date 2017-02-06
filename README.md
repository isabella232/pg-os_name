[![Build Status](https://travis-ci.org/adjust/pg-os_name.svg)](https://travis-ci.org/adjust/pg-os_name)

# PG OS Name

A 1-byte OS name data-type for PostgreSQL. Currently supported values:

    android
    bada
    blackberry
    ios
    linux
    macos
    server
    symbian
    webos
    windows
    wphone
    unknown

### Installation

You can clone the extension and run the standard `make && make install` to
build it against your PostgreSQL server.

### Usage

The following example illustrates the use of the `os_name` type.

```SQL
CREATE TABLE events (id serial, origin os_name);

INSERT INTO events (values
  (1, 'android'),
  (2, 'ios'),
  (3, 'android')
);

SELECT * FROM events ORDER BY origin;
```

The result from the above execution will be:

```
 id | origin
----+--------
  1 | android
  3 | android
  2 | ios
(3 rows)
```

### Development

To run the tests, clone and run `make && make install && make installcheck`.
[Dumbo](https://github.com/adjust/dumbo) is the recommended development tool for
the extension.
