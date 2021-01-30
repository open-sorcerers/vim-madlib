const {
  ap,
  chain,
  concat,
  curry,
  equals,
  filter,
  fork,
  ifElse,
  j2,
  length,
  map,
  of,
  pipe,
  prop,
  propEq,
  readStdin,
  reduce,
  reject,
  trace,
  when
} = require('snang/script')
const kleur = require('kleur')
const { reject: rejectFuture, resolve } = require('fluture')

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
    map(([name, cause]) => `Unexpected reference in ${def} (${cause}=${name})`)
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

const swapToRejectionBranch = chain((raw) =>
  ifElse(
    pipe(length, equals(0)),
    () => resolve(kleur.green('Hooray, no errors!')),
    rejectFuture
  )(raw)
)

module.exports = pipe(
  readStdin,
  map(validateSyntax),
  swapToRejectionBranch,
  // convert non-empty arrays into non-zero exits
  fork(
    (err) => {
      console.error(kleur.red(`Found ${err.length} invalid relationships:`))
      console.error(err)
      process.exit(1)
    },
    (raw) => {
      console.log(raw)
      process.exit(0)
    }
  )
)(process.argv.slice(2)[0])
