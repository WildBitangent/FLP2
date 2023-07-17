# Hamilton cycles

This prolog scripts finds all unique Hamiltons cycles in given graph

- Fully implemented project.
- Test files and references in tests/
- Testing can be done using make test

### tests
All tests are finished instantly, except test3, which execution is ~1s.
Specific info is included in test files.

### Prerequisites
SWI-Prolog (tested using version 6.1.1)

### Compiling
Use included makefile

### Running
    flp20-log

## STDIN format
    <V1> <V2>\n
    <V2> <V3>\n
    ...\n
    <V_x> <V_y>\n

## Output format
    <V1>-<V2> <V3>-<V4> ... <Vn-1>-<Vn>\n
    ...\n

## Authors
Matej Karas   --   xkaras34@stud.fit.vutbr.cz
