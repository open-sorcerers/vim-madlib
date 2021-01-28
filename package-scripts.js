module.exports = {
  scripts: {
    syntaxLint: 'cat syntax/madlib.vim | node consumeSyntax.js | node validateSyntax.js'
  }
}
