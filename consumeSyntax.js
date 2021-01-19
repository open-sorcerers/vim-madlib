const {
  C,
  any,
  ap,
  applySpec,
  concat,
  curry,
  difference,
  equals,
  filter,
  flip,
  fork,
  identity: I,
  includes,
  init,
  j2,
  join,
  last,
  length,
  map,
  mergeRight,
  nth,
  of,
  once,
  path,
  pathOr,
  pipe,
  prop,
  readStdin,
  reduce,
  reject,
  replace,
  split,
  startsWith,
  trace,
  trim,
  uniq,
  without
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
    ) {
      return { pattern: k }
    }
    return {
      [k]:
        typeof v === 'string' && ~v.indexOf(',') ? v.split(',') : !v ? true : v
    }
  }),
  reduce(mergeRight, {})
)
const splitComma = split(',')
const swapNull = (x) =>
  x && typeof x === 'string' ? [x] : x[0] === '' ? [] : x
const getRelationalData = pipe(
  applySpec({
    contains: pathOr([], ['data', 'contains']),
    nextgroup: pathOr([], ['data', 'nextgroup']),
    matchgroup: pathOr([], ['data', 'matchgroup'])
  }),
  map(pipe(swapNull))
)

const stripAtSign = (z) => (z[0] === '@' ? z.substr(1) : z)

const skipGlobals = (z) => reject((zz) => ['TOP', '@Spell'].includes(zz), z)

const getAllNames = once(
  pipe(
    map(pipe(of, ap([prop('name'), path(['data', 'matchgroup'])]))),
    reduce(concat, []),
    uniq
  )
)
const invalidRelativeToNames = curry((names, match) =>
  pipe(skipGlobals, map(stripAtSign), without(names))(match)
)
const solveValidity = curry((names, agg, x) => {
  const { contains, nextgroup, matchgroup } = getRelationalData(x)
  const invalid = invalidRelativeToNames(names)
  const invalidContains = contains.length && invalid(contains)
  const invalidNextGroup = nextgroup.length && invalid(nextgroup)
  const invalidMatchGroup = matchgroup.length && invalid(matchgroup)
  const matched = {
    contains: invalidContains,
    nextgroup: invalidNextGroup,
    matchgroup: invalidMatchGroup
  }
  const expected = map(filter(I), matched)
  const valid =
    expected.contains.length +
      expected.nextgroup.length +
      expected.matchgroup.length ===
    0
  const y = {
    ...x,
    valid
  }
  return valid ? agg.concat(y) : agg.concat({ ...y, expected })
})

const unsliceLine = pipe(
  trim,
  split(C.n),
  map(pipe(trim, replace(/^\\/, ''), trim)),
  join(C._),
  trim
)

const unfoldLeadingSlashes = reduce((list, b) => {
  if (b.trim().startsWith('\\')) {
    const cleaned = unsliceLine(b)
    const prev = last(list)
    if (prev && list.length > 2 && prev.startsWith('syntax')) {
      return init(list).concat(prev + ' ' + cleaned)
    }
  }
  return list.concat(b)
}, [])

const secondIsMatchOrKeyword = pipe(split(C._), map(trim), nth(1), (raw) =>
  ['match', 'keyword', 'region'].includes(raw)
)

module.exports = pipe(
  readStdin,
  map(
    pipe(
      split(C.n),
      unfoldLeadingSlashes,
      filter(startsWith('syntax')),
      filter(secondIsMatchOrKeyword),
      map(pipe(split(C._), filter(I), map(trim))),
      map(([_, kind, name, ...data]) => ({
        kind,
        name,
        structure: pipe(
          split('_'),
          map((z) => {
            const AZ = z.search(/[A-Z]/)
            if (!AZ) return {}
            const key = z.substr(0, AZ)
            if (!!key) return {}
            return { [key]: z.substr(AZ, Infinity) }
          }),
          reduce(mergeRight, {})
        )(name),
        raw: data,
        data: structureData(data)
      })),
      (all) => {
        const names = getAllNames(all)
        return {
          entities: names,
          syntaxes: reduce(solveValidity(names), all, all)
        }
      },
      j2
    )
  ),
  fork(console.error, console.log)
)(process.argv.slice(2)[0])
