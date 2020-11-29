const {
  C,
  identity: I,
  reject,
  pathEq,
  filter,
  fork,
  join,
  keys,
  length,
  lt,
  map,
  pathOr,
  pipe,
  prop,
  readStdin
} = require("snang/script")

module.exports = pipe(
  readStdin,
  map(
    pipe(
      JSON.parse,
      filter(pipe(
        prop('structure'),
        keys,
        filter(I),
        length,
        lt(0)
      )),
      reject(pathEq(['structure', 'tag'], "Invalid")),
      map(z => {
        const y = pathOr(false, ['structure', 'hi'])(z);
        return y ? [z.name, y] : []
      }),
      filter(length),
      map(([k, v]) => 'hi def link ' + k + ' ' + v),
      join(C.n)
    )
  ),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
