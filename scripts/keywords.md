# Keywords

<!-- keyword: and -->
Boolean operator that evaluates truthy if the LHS and RHS are both true.
<!-- /keyword -->

<!-- keyword: break -->
Early exit from a `for`, `while`, or `repeat` loop.
<!-- /keyword -->

<!-- keyword: do -->
Used to separate the loop body from the looping condition or when used standalone, makes a `do ... end` block to scope local variables and expressions in a way that they don't leak to outside code.
<!-- /keyword -->

<!-- keyword: if -->
Branch on a conditional expression.
Most values are considered `truthy`, including all strings, numbers, complex types, etc.

In Luwu, `false`, `none`, and `nil` are considered falsy.

If statements:

```luau
if x == y then
    do_something(x)
end
if (x == y) or z then
    const computed = compute_something(x, y)
    do_something(computed)
else
    do_something(y)
end
if x ~= y then
    do_something(x)
elseif type(x) == "number" and type(y) == "string" then
    do_something_else(x, y)
end
```

Luwu also supports `if` *expressions*:

```luau
const thing_to_add =
    if x == y then
        do_something(compute_something(x, y))
    else
        do_something(y)
```

Unlike `if` statements, `if` expressions must contain only one expression in each of its branches, evaluate to at least one value, require an `else` branch, and do not terminate with `end`.
<!-- /keyword -->

<!-- keyword: else -->
Add a final, catch-all branch to an `if` statement or expression.
<!-- /keyword -->

<!-- keyword: elseif -->
Add a separate conditional branch to an `if` statement or expression.

```luau
if x ~= y then
    -- do something
elseif x == (y - 2) then
    -- do something else
end
const found_cat = if cat == nyla then nyla elseif cat == taz then cats[taz] else none
if cat then
    cat:meow()
end
```
<!-- /keyword -->

<!-- keyword: end -->
Used to terminate functions and blocks of code.
<!-- /keyword -->

<!-- keyword: false -->
A falsy boolean value that can be used in boolean logic. The other falsy values in Luwu are `none` and `nil`.
<!-- /keyword -->

<!-- keyword: for -->
Create loop statements to iterate over containers (or a set number of times).

```luau
-- iterate over an array
const cats: { string } = { "Taz", "Nyla", "Nanuk", "Crazy", "Mr. Purrsalot" }
for index, cat in cats do
    print(cat)
end

-- iterate over a map
const animals: { [string]: Animal } = get_animals()
for animal_name, animal in animals do
    print(`name: {animal_name}`)
end

-- iterate 10 times
for i = 1, 10 do
    print(i)
end

-- iterate through an array backwards
for i = #cats, 1, -1 do
    print(i, cat)
end
```
<!-- /keyword -->

<!-- keyword: function -->
Defines a `function`. A function may be called to evaluate a code block and `return` a result.

In Luwu, functions are first-class and can be passed around, passed to functions, used as a key in a hash table, and more.

In the type system, functions are represented with `(paramname: Type) -> (ReturnType1, ReturnType2)` syntax.

Named functions should be defined with the `const` or `local` keyword in front of them so they can be inlined by the compiler.

```luau
-- Named function 'add'
const function add(x, y)
    return x + y
end
const added = add(1, 2)
-- the above code is syntax sugar for the unnamed function:
const add = function(x, y)
    return x + y
end
const added = add(1, 2)

local function read(path: string): string?
    local success, contents = pcall(fs.readfile(path))
    if success and contents then
        return contents
    end
    return nil
end

const f = function(name: string | number)
    if type(name) == "string" then
        print(`hi {name}`)
    elseif type(name) == "number" then
        print(`hi {names[name]})`
    end
end
const res = dothing(f)
```

Functions can be used as expressions:

```luau
const cats = {
    {
        name = "Nyla",
        kittens = (function() -- an immediately invoked function expression (IIFE)
            local cats = 0
            local kittens = getkittensbyid("Nyla")
            return #kittens
        end)(),
    }
}
```

There is a special syntax for adding functions to tables:

```luau
local module = {}
function module.functionName()
    -- do something
end
```

Functions can be hoisted to be called above their actual definitions.

```luau
local extra_work: (string) -> { string }
const function do_something(thing: string)
    const result = extra_work(thing)
    return string.sub(result[1], 1, 8)
end

-- note the lack of const or local here, plain 'function' actually assigns to the `local` above.
function extra_work(thing: string): { string }
    return str.splitlines(thing)
end

const lines = "hi\nI use Luwu and Luau together\nIn the same codebase."
print(do_something(lines))
```

Calling a function can throw an error (also called an exception). To catch errors, use the builtin `pcall` or `xpcall` functions.
<!-- /keyword -->

<!-- keyword: in -->
<!-- /keyword -->

<!-- keyword: local -->
Define a new locally-scoped variable (binding).

Unlike `const` bindings, `local` bindings may be mutated by reassignment.

```luau
local firstName = getFirstName()
if firstName then
    local lastName = getLastName(firstName)
end
-- lastName no longer exists here
```

You can use this with the `function` keyword to define a `local function`.

```luau
local function foo(x: string, y: number)
    print(x, y)
end
-- this is syntax sugar (except in optimizations) to
local foo = function(x: string, y: number)
    print(x, y)
end
```
<!-- /keyword -->

<!-- keyword: nil -->
A falsy value that represents nonexistence. When set as the value of a table, erases that key from the table, possibly creating a hole in the table if the table is an array.

For an alternative that can be stored in tables, see `none`.

In the type system, `nil` can be represented by name or by the postfix operator `?`.
<!-- /keyword -->

<!-- keyword: not -->
<!-- /keyword -->

<!-- keyword: or -->
<!-- /keyword -->

<!-- keyword: repeat -->
Repeats a block `until` a condition has been reached. Local variables in the scope of the `repeat` block are visible in the `until` block.
<!-- /keyword -->

<!-- keyword: return -->
Used as a statement to exit a function and provide zero or more values back to the caller.

Most of the time, you should return one value. If you only want to return a value sometimes,
return `nil` instead of returning nothing.

```luau
-- This function returns 0 values
const function do_something(thing: string | nil | none)
    if not thing then -- handles both `nil` and `none`
        return
    end
    handle_thing(thing)
end

-- a normal function returns only one value
const function do_thing(thing)
    if isbad(thing) then
        return nil
    end
    const calculated = calc(thing)
    if calculated then
        return calculated
    end
    local derived = 0
    for _, element in thing.elements do
        const der = derive(element)
        derived += dir
    end
    return derived
end
```

A function that returns multiple values is called a "multiret function"; these include the common standard library functions `string.match` and `pcall`.

If your function returns multiple values, you should return the same number of values on all codepaths.

```luau
const function call()
    return "hi", "bye"
end
const hi, bye = call()

const name, age = string.match("Cat<([%w]+), ([%d]+)")
assert(name ~= nil and age ~= nil)
```
<!-- /keyword -->

<!-- keyword: then -->
Separates the condition in an `if` or `elseif` branch from the branch body.
<!-- /keyword -->

<!-- keyword: true -->
A truthy boolean value. Also used as a value in 'sets' to represent existence.
<!-- /keyword -->

<!-- keyword: until -->
Specifies the terminating conditional expression of a `repeat` loop.
The `until` expression may refer to locals from the `repeat` block.
<!-- /keyword -->

<!-- keyword: while -->
Creates a loop that keeps repeating while its condition holds `true`.

```luau
while #elements > 0 do
    const popped = table.remove(elements, 1)
    dosomething(popped)
end

while true do
    -- spin forever (don't do this)
end
```
<!-- /keyword -->

<!-- keyword: class -->
Define a unique data structure with fields, functions, and methods.

```luau
class Cat
    name: string
    age: number
    function speak(self, message: string?): string
        message = message or "meow"
        return `{self.name} says {message}`
    end
end
-- use the table constructor to create an `object` of this class
const cat = Cat { name = "Taz", age = 12 }
```

To import your class in another module (another file), `export` it with `export class`.

To customize the behavior of the class's constructor, give it an `__init` constructor function.

```luau
export class Person
    first_name: string
    last_name: string

    function __init(self, first, last)
        self.first_name = first
        self.last_name = last
    end
end
const attorney = Person("Mike", "Ross")
```

Use `class.isinstance` to check if an `object` is an instance of a class.

```luau
type Animal =
    | Cat
    | Dog
const function get_animal(name): Animal | none
    const animal: Animal? = get_animal_by_name(name)
    if not animal then
        return none
    end
    return animal
end

const animal = get_animal("Taz")
if animal then
    if class.isinstance(animal, Cat) then
        print(animal:meow())
    elseif class.isinstance(animal, Dog) then
        print(animal:bark())
    end
end
```

More complicated classes can have the `public`, `private`, `const` keywords, generic parameters, and default values.

```luau
export class Set<T>
    private const inner: { [T]: true? } = {}
    private function __init(self)
        -- pass, force public construction with .new
    end
    public function new<T>(): Set<T>
        return Set() :: Set<T>
    end
    public function set(self, v: T)
        self.inner[v] = true
    end
    public function has(self, v: T): boolean
        return self.inner[v] ~= nil
    end
    public function unset(self, v: T)
        if self.inner[v] then
            self.inner[v] = nil
        end
    end
end

const setty = Set.new<<string>>()
setty:set("Taz")
assert(setty:has("Taz"), "sets are broken")
setty:unset("Taz")
assert(setty:has("Taz") == false, "sets are broken 2")
```
<!-- /keyword -->

<!-- keyword: continue -->
Skip to the next iteration of a loop.
<!-- /keyword -->

<!-- keyword: const -->
Defines an immutable `local` binding. It is a syntax error to try to change the value of this binding.

```luau
const x = 2
x += 1 -- syntax error

const function foo()
    do_something()
end
```
<!-- /keyword -->

<!-- keyword: public -->
Marks a class field (property) or function (normal function or method) as accessible from outside the lexical scope of that class. This keyword can be omitted if every member of the class is `public`.

```luau
class Cat
    name: string -- implicitly public
    function meow(self) -- implicitly public
    end
end

class List<T>
    private inner: { T }
    -- class contains a private field, public fields/functions must be marked explicitly
    public allocated_capacity: number = 42
    public function __init(self, ...: T)
    end
    public function with_capacity(cap: number)
    end
end
```
<!-- /keyword -->

<!-- keyword: private -->
Forbid a class field, function, or method from being accessible outside the lexical scope of the class.
Attempting to access a `private` member from outside the class will result in a runtime error.

```luau
class RsaKeys
    public public_key: string
    private private_key: string
    public function __init(self, pub, priv)
        self.public_key = pub
        self.private_key = priv
    end
end
const key = RsaKeys(publickey(), privatekey())
print(key.public_key) -- all good
print(key.private_key) -- runtime error
```
<!-- /keyword -->

<!-- keyword: export -->
Exposes a type or value to other modules (other files) to be `require`-d.
<!-- /keyword -->

<!-- keyword: type -->
Creates a type alias, usually for a table or function type:

```luau
type Cat = {
    what: "Cat",
    name: string,
    age: number
}
const cat: Cat = { -- throws type error if missing any fields
    what = "Cat",
    name = "Taz",
    age = 12,
}
```
<!-- /keyword -->

<!-- keyword: typeof -->
<!-- /keyword -->

<!-- keyword: read -->
Set a table property as readonly.
<!-- /keyword -->

<!-- keyword: write -->
<!-- /keyword -->

<!-- keyword: self -->
<!-- /keyword -->

<!-- keyword: __init -->
<!-- /keyword -->

<!-- keyword: export_class -->
Make a class available to other modules.

```luau
-- list.luau
export class List<T>
    private inner: { T }
    -- class contains a private field, public fields/functions must be marked explicitly
    public allocated_capacity: number = 42
    public function __init(self, ...: T)
    end
    public function with_capacity(cap: number)
    end
end
-- useslist.luau
-- due to current lack of an equivalent import keyword, you need to do this
const list = require("./list")
const List = list.List
type List<T> = list.List

const listy = List("Taz", "Nanuk", "Nyla")
```

<!-- /keyword -->

<!-- keyword: export_type -->
Create and export a type alias, usually for a table or function type:

```luau
-- cats.luau
export type Cat = {
    what: "Cat",
    name: string,
    age: number
}
const cat: Cat = { -- throws type error if missing any fields
    what = "Cat",
    name = "Taz",
    age = 12,
}
-- other.luau
const cats = require("./cats")
type Cat = cats.Cat
const cat2: Cat = {
    what = "Cat",
    name = "Nanuk",
    -- Type error: missing required field 'age'...
}
```
<!-- /keyword -->

<!-- keyword: const_function -->
A `local function` that cannot be mutated. This is probably the most common type of `local function` for newer code. Like `local function`s, these may be inlined by the compiler if their function bodies are small enough.
<!-- /keyword -->

<!-- keyword: class_const -->
Marks a `const` field of a class. A `const` field may only be mutated during construction (during `__init`) and cannot be reassigned afterwards.

```luau
local last_id = 1
class Id
    -- implicitly public
    const inner: number
    function __init(self)
        self.inner = 1231321321321
        const last = last_id
        last_id += 1
        self.inner = last -- can still be mutated
    end
end
self.inner = 2 -- runtime error
<!-- /keyword -->

<!-- !stop parsing -->
<!-- The keywords below only ever appear in embedder declaration/definition files, where hover and diagnostics don't currently run -- low priority, but kept for completeness. -->

<!-- keyword: declare -->
<!-- /keyword -->

<!-- keyword: extends -->
<!-- /keyword -->

<!-- keyword: declare_extern_type -->
<!-- /keyword -->
