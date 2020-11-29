const {
  reject,
  curry,
  any,
  prop,
  includes,
  flip,
  C,
  filter,
  fork,
  j2,
  of,
  ap,
  pathOr,
  map,
  mergeRight,
  pipe,
  concat,
  readStdin,
  reduce,
  split,
  startsWith,
  trim,
  identity: I,
  trace
} = require('snang/script')

const structureData = pipe(
  map((datapoint) => {
    const hasEq = datapoint.search(/=/)
    if (!hasEq) return {}
    const [k, v] = datapoint.split('=')
    if (
      (~k.indexOf('/') ||
        ~k.indexOf('+') ||
        ~k.indexOf('\\') ||
        ['String', 'Boolean', 'Number', 'List'].includes(k)) &&
      !v
    )
      return { pattern: k }
    if (k && !v) return { [k]: true }
    return { [k]: v }
  }),
  reduce(mergeRight, {})
)
const splitComma = split(',')
const getRelationalData = pipe(
  of,
  ap([
    pipe(pathOr('', ['data', 'contains']), splitComma),
    pipe(pathOr('', ['data', 'nextgroup']), splitComma)
  ])
)

const stripAtSign = (z) => (z[0] === '@' ? z.substr(1) : z)

const solveValidity = (agg, x) => {
  const names = map(prop('name'))(agg)
  const [contains, nextgroup] = getRelationalData(x)
  const invalid = pipe(
    filter((z) => !includes(stripAtSign(z), names)),
    filter(I)
  )
  const invalidContains = contains.length && invalid(contains)
  const invalidNextGroup = nextgroup.length && invalid(nextgroup)
  const valid = invalidContains.length + invalidNextGroup.length === 0
  const expected = map(filter(I), {
    contains: invalidContains,
    nextgroup: invalidNextGroup
  })
  const y = {
    ...x,
    valid
  }
  return valid ? agg.concat(y) : agg.concat({ ...y, expected })
}

module.exports = pipe(
  readStdin,
  map(
    pipe(
      split(C.n),
      filter(startsWith('syntax')),
      map(pipe(split(C._), filter(I), map(trim))),
      map(([_, kind, name, ...data]) => ({
        kind,
        name,
        structure: pipe(
          split('_'),
          map((z) => {
            const AZ = z.search(/[A-Z]/)
            if (!AZ) return {}
            return { [z.substr(0, AZ)]: z.substr(AZ, Infinity) }
          }),
          reduce(mergeRight, {})
        )(name),
        raw: data,
        data: structureData(data)
      })),
      (all) => reduce(solveValidity, all, all),
      j2
    )
  ),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
