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
- [x] `while`
- [x] `until`
- [x] `for`
- [x] `while` and `until` as modifiers

#### Skipping
- [x] `break`
- [x] `next`
- [x] `redo`

### Exceptions
- [x] `begin` / `rescue`
- [x] def / `rescue`
- [x] multiple `rescues`
- [x] `retry`
- [x] `ensure` part
- [x] `ensure` part with rescues
- [x] `ensure` part with rescues and else
- [x] `else` part

- [ ] customisations are not cleared between runs
- [ ] propagater unit specs need to be completed (e.g., customisations)
- [ ] analyser unit specs needed

Exception control flow might be neater if there was some notion of hierarchy in the CFG. Right now, every statement within the rescuable block has a control flow edge to each of the exception handlers. It would be neater to have a single control flow edge from some kind of "parent" node which contains each of the statements in the rescuable block.

### Blocks

Not too sure how to approach this yet.

It might be reasonable to assume that any method that takes a block could cause control to flow into that block. If we have the source for that method, we could also check for yield or a call before adding this control flow edge.

No matter what, blocks support the same skipping constructs as loops:

- [ ] `break`
- [ ] `next`
- [ ] `redo`

## Inter-method Control Flow Graphs

- [ ] `return` expressions
- [ ] direct method invocations
- [ ] method invocations via `send` ?
- [ ] ensure control flow edges from a method invocation to a block only added when callee yields to block
