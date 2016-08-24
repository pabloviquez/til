# Generate Random Characters

## Intro

`/dev/urandom` and `/dev/random` are using the exact same CSPRNG (Cryptographically secure pseudorandom number generator). They only differ in very few ways that have nothing to do with "true" randomness.

**Reference:** http://www.2uo.de/myths-about-urandom/

## Generate Random Alpha-Numeric Characters

Generates a 32 string of random characters:

```
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
```

## Mac OS Version

```
export export LC_CTYPE=C
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1
```
