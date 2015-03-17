## Control Flow Graphs

### Basics
- [x] `begin` ... `end`
- [x] `def` ... `end`

### Conditionals

#### `if` expressions
- [x] no `else`
- [x] `else`
- [x] `elsif`
- [x] ternary `a ? b : c`
- [x] expression modifier `if`
  
#### `unless` expressions
- [x] no else
- [x] else
- [x] expression modifier `unless`

#### `case` expressions
- [x] single when
- [x] else
- [x] several when
  
### Loops

#### Looping expressions
- [ ] `while`
- [ ] `until`
- [ ] `for`
- [ ] `while` and `until` as modifiers

#### Skipping
- [ ] `break`
- [ ] `next`
- [ ] `redo`

### Exceptions
- [ ] `begin` / `rescue`
- [ ] def / `rescue`
- [ ] multiple `rescues`
- [ ] `retry`
- [ ] `ensure` part
- [ ] `else` part

### Blocks

Not too sure how to approach this yet.

It might be reasonable to assume that any method that takes a block could cause control to flow into that block. If we have the source for that method, we could also check for yield or a call before adding this control flow edge.
  

## Inter-method Control Flow Graphs

- [ ] `return` expressions
- [ ] direct method invocations
- [ ] method invocations via `send` ?