const {
  ap,
  curry,
  concat,
  filter,
  fork,
  j2,
  map,
  of,
  pipe,
  prop,
  propEq,
  readStdin,
  reduce,
  reject,
  trace
} = require('snang/script')

const [input] = process.argv.slice(2)
const excludes = ['@Spell', 'TOP']

const indexedArray = curry((y, x) => [x, y])
const [mArr, nArr, cArr] = map(indexedArray, [
  'matchgroup',
  'nextgroup',
  'contains'
])
const filterRelativeToStdIn = (zzz) =>
  input ? filter(([def, expected]) => def === input)(zzz) : zzz

const convertDataToErrors = reduce((a, [def, expected]) => {
  const c = pipe(
    reject(([name]) => excludes.includes(name)),
    map(
      ([name, cause]) => `Unexpected reference in ${def} (${cause}=${name})`
    )
  )(expected)
  return a.concat(c)
}, [])

const concatenateCauses = ([k, { contains, nextgroup, matchgroup }]) => [
  k,
  pipe(
    map(cArr),
    concat(map(nArr, nextgroup)),
    concat(map(mArr, matchgroup))
  )(contains)
]

const validateSyntax = pipe(
  JSON.parse,
  prop('syntaxes'),
  filter(propEq('valid', false)),
  map(pipe(of, ap([prop('name'), prop('expected')]), concatenateCauses)),
  filterRelativeToStdIn,
  convertDataToErrors
)

module.exports = pipe(
  readStdin,
  map(validateSyntax),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
