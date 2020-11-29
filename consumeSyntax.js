const {
  C,
  filter,
  fork,
  j2,
  map,
  mergeRight,
  pipe,
  readStdin,
  reduce,
  split,
  startsWith,
  trim,
  identity: I
} = require("snang/script")

module.exports = pipe(
  readStdin,
  map(
    pipe(
      split(C.n),
      filter(startsWith("syntax")),
      map(pipe(
        split(C._),
        filter(I),
        map(trim)
      )),
      map(([_, kind, name, ...data]) => ({
        kind,
        name,
        structure: pipe(
          split("_"),
          map(z => ({
            [z.substr(0, z.search(/[A-Z]/))]:
             z.substr(z.search(/[A-Z]/), Infinity)
          })),
          reduce(mergeRight, {})
       )(name),
       data
     })),
     j2
  )),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
