const {
  ap,
  contains,
  filter,
  fork,
  j2,
  map,
  reduce,
  of,
  pipe,
  prop,
  propEq,
  readStdin
} = require('snang/script')

const [input] = process.argv.slice(2)
module.exports = pipe(
  readStdin,
  map(
    pipe(
      JSON.parse,
      filter(propEq('valid', false)),
      map(
        pipe(
          of,
          ap([prop('name'), prop('expected')]),
          ([k, { contains, nextgroup }]) => [
            k,
            contains.map((c) => [c, 'c']).concat(nextgroup.map((n) => [n, 'n']))
          ]
        )
      ),
      (zzz) => (input ? filter(([def, expected]) => def === input)(zzz) : zzz),
      reduce((a, [def, expected]) => {
        const c = map(
          ([name, cause]) =>
            `Unexpected key in ${def} (${
              cause === 'c' ? 'contains' : 'nextgroup'
            }=${name})`
        )(expected)
        return a.concat(c)
      }, [])
    )
  ),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
