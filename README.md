<br />
<div align="center">

  <img src="imgs/logo.png" alt="Yanzari Transpiled Language">
    
  <h3 align="center">Yanzari's Transpiled Language</h3>
  <sup>YTL</sup>
  <p align="center">
    my programming language that will transpile to SRB2 Lua.
    <br />
    It will include typing, various statements (e.g., <code>with</code>), and user-defined operators, and will generate valid, optimized SRB2 Lua code.
    <br />
    <br />
    It might have a package manager in the future.
  </p>
  <sup>By Yanzari</sup>
</div>

## CheckList
- [ ] CLI
- [ ] Formatter
  - [ ] Errors
  - [ ] Warnings
- [ ] Scanner
  - [ ] Keywords
  - [ ] Operators
  - [ ] Comments
  - [ ] WildCards
  - [ ] Identifiers
  - [ ] Indents
  - [ ] Directives
    - [ ] `//!nonstrict`
    - [ ] `//!strict`
    - [ ] `//!runtime-type-check`
- [ ] Module Resolution
  - [ ] non-relative (`@`)
  - [ ] relative
- [ ] Parser
  - [ ] Expression
  - [ ] Statments
- [ ] Semantic
  - [ ] Directive Analysis
  - [ ] Type Inference
  - [ ] Type Analysis
- [ ] Optimizer
  - [ ] Constant Folding
  - [ ] Dead-Code Elimination
  - [ ] Macro Expansion
  - [ ] Unsugar
  - [ ] Type Erasure
- [ ] Code Generator
  - [ ] UnParser
  - [ ] UnLexer

## Future
- [ ] Bytecode
- [ ] Virtual Machine