# Keywords

<!-- keyword: and -->
`and` is a logical operator. It does not always evaluate to a `boolean`.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

There are no metamethods that can implicitly fire when evaluating `and`.

Unlike other programming languages, `and` does not always evaluate to a `boolean`.
It evaluates the first argument (on the left) and then returns it if it's **falsy**.
Otherwise, it evaluates and then returns the second argument (on the right), no matter what the first argument is.
This behavior is called short-circuit evaluation, but the result is not always a `boolean`.

Examples:

```luau
nil and 20 -- nil
false and 20 -- false
true and 20 -- 20
10 and 20 -- 20
```

See [Logical Operators](https://lua.org/manual/5.1/manual.html#2.5.3) section on Lua 5.1 reference manual for more examples,
along with other information about other logical operators.

In general, because of how truthy and falsy values are treated,
this technical behavior is equivalent to boolean operators in other programming languages.

Using this technical behavior, `and` can be used as a conditional statement without requiring an `if` statement.
The examples show `20` as the truthy result, while it is `nil` and `false` as the falsy result.

Combining the `and` keyword and the `or` keyword, which also has similar short-circuit evaluation behavior,
it allows the `and-or` ternary operator, which is a side effect of the evaluation behavior.
The first argument is the condition, second argument is the truthy result, and third argument is the falsy result.

Examples:

```luau
true and 20 or 30 -- 20
false and 20 or 30 -- 30
10 and 20 or 30 -- 20
```

However, the truthy result (second argument) cannot be falsy as that does not work because of the `or` keyword.

```luau
true and false or 30 -- 30 (expected `false`)
```

In Luau, it added a lint and `if-else` *expression* for ternary operators to prevent this common pitfall and correctly evaluate to `false` in that example.

```luau
if true then false else 30 -- false
```
<!-- /keyword -->

<!-- keyword: break -->
This keyword performs an early exit from a `for`, `while`, or `repeat` loop statement.
It jumps the control flow to after the loop body.

Example:

```luau
-- This code snippet will iterate from 0 to 5 and prints those numbers,
-- the control flow hits `break` because of the `if` statement and then it jumps to after the loop.
-- Finally, it will print `Exited with count: 6`.

local count = 0

while count < 10 do
    if count == 6 then
        break
    end
    
    print(count)
    count += 1
end
-- `break` jumps to the line this comment is at.
print("Exited with count:", count)
```

Technically, the source code is compiled into bytecode.
The `break` keyword simply jumps to the next bytecode after the loop.
<!-- /keyword -->

<!-- keyword: do -->
Begins a code block. For variables, it creates a scope.
The current code block ends at the corresponding `end` keyword to the `do` keyword.

In the context of a file, a chunk is a top-level code block, which is the entire source code.

This keyword is used with `while` and `for` loop statements to create the loop body.
It is the delimiter after the conditions and before the loop body.

Example:

```luau
for i = 1, 10 do -- delimiter
    print(i)
end
```

All `local` and `const` declarations inside of a code block are bound to the current scope.
All global variable declarations do not bound to the current scope.
When the variable identifier takes the same name as an outer scope, the variable is shadowed and the later declaration takes precedence.
After the `end` keyword, the bindings are out-of-scope and their identifier returns to associate with the previous value in the outer scope (if shadowed) or `nil` (if not shadowed).
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
`end` is a reserved keyword.
It ends a code block. See hover documentations for the `do` keyword for more details about code blocks.

It also ends a function body. However, this is the same as a code block.

It cannot end a chunk.
<!-- /keyword -->

<!-- keyword: false -->
The falsy `boolean` value. It is a reserved keyword/

It is one of the few falsy values.
In Lua, the other falsy value is `nil`.
In Luwu, `none` is also a falsy value.
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
`not` is a logical operator. It always evaluate to a `boolean`.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

There are no metamethods that can implicitly fire when evaluating `not`.

When the argument is falsy, `not` returns `true`.
When the argument is truthy, `not` returns `false`.

Examples:

```luau
not true -- false
not 20 -- false

not false -- true
not nil -- true
```

Doing `not (not argument)` and other variants with more `not` keywords is redundant
and does not return the value of `argument` unless it is originally `true` or `false`.
<!-- /keyword -->

<!-- keyword: or -->
`or` is a logical operator. It does not always evaluate to a `boolean`.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

There are no metamethods that can implicitly fire when evaluating `or`.

Unlike other programming languages, `or` does not always evaluate to a `boolean`.
It evaluates the first argument (on the left) and then returns it if it's **truthy**.
Otherwise, it evaluates and then returns the second argument (on the right), no matter what the first argument is.
This behavior is called short-circuit evaluation, but the result is not always a `boolean`.

Examples:

```luau
nil or 20 -- 20
false or 20 -- 20
true or 20 -- true
10 or 20 -- 10
```

See [Logical Operators](https://lua.org/manual/5.1/manual.html#2.5.3) section on Lua 5.1 reference manual for more examples,
along with other information about other logical operators.

In general, because of how truthy and falsy values are treated,
this technical behavior is equivalent to boolean operators in other programming languages.

Using this technical behavior, `or` can be used for default values without requiring an `if` statement.
The examples show `20` as the default value as that is a truthy value.

Combining the `or` keyword and the `and` keyword, which also has similar short-circuit evaluation behavior,
it allows the `and-or` ternary operator, which is a side effect of the evaluation behavior.
The first argument is the condition, second argument is the truthy result, and third argument is the falsy result.

Examples:

```luau
true and 20 or 30 -- 20
false and 20 or 30 -- 30
10 and 20 or 30 -- 20
```

However, the truthy result (second argument) cannot be falsy as that does not work because of the `or` keyword.

```luau
true and false or 30 -- 30 (expected `false`)
```

In Luau, it added a lint and `if-else` *expression* for ternary operators to prevent this common pitfall and correctly evaluate to `false` in that example.

```luau
if true then false else 30 -- false
```
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
The truthy `boolean` value. It is a reserved keyword.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

This value can become a placeholder for a truthy value.
For example, an approach to represent a hash set using only a Lua table uses `true` as the value.
This works because Lua tables have a hash part for unique elements, key are assigned to `true`, which is truthy and refers to the same `true` internally,
and reading an unassigned key defaults to `nil`, which is falsy.

```luau
local set = {
    foo = true,
    bar = true,
    apple = true,
    pie = true,
    milk = true
}

-- Check for a `foo` element in `set`.
-- `set.foo` returns `true`, which is a truthy value, so this code block runs.
if set.foo then
    print("set has foo")
end

-- Check for a `banana` element in `set`.
-- `set.banana` returns `nil`, which is a falsy value, so this code block doesn't run.
if set.banana then
    print("set has banana")
end
```
<!-- /keyword -->

<!-- keyword: until -->
Specifies the terminating conditional expression of a `repeat` loop.
The `until` expression may refer to locals from the `repeat` block.
<!-- /keyword -->

<!-- keyword: while -->
Creates a `while` loop. It is a reserved keyword.
This loop keeps repeating *while* its condition evaluates to a truthy value.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

A `while` loop structure has a condition and a loop body.
The condition follows after the `while` keyword and starts/continues iteration if it evaluates to a truthy value.
The loop body is a code block. See hover documentation for the `do` keyword for more details about code blocks.

In pseudocode:

```txt
while condition do
    block
end
```

Example of good usage:

```luau
-- This will iterate while the `elements` table still has items to remove.
while #elements > 0 do
    const popped = table.remove(elements)
    dosomething(popped)
end
```

Example of bad usage:

```luau
-- This will iterate forever (don't do this without a `break` keyword)
while true do
    print("evil laughter!")
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
In Luau, `continue` is not a reserved keyword.
It is possible to declare a variable using `continue` as the identifier, which loses its functionality.

It skips evaluating code after the keyword and starts the next iteration of a loop.
It is a syntax error if `continue` is a keyword but the next token is not the `end` keyword.

Example:

```luau
-- This code snippet iterates from 1 to 5, but skips 3 when printing.
-- In other words, it prints 1, 2, 4, and 5.

local count = 1

while count < 5 do
    count += 1
    
    if count == 3 then
        continue
    end
    
    print(count)
end
```
<!-- /keyword -->

<!-- keyword: const -->
In Luau, `const` is a contextual keyword.
It cannot be shadowed by a declaration using this name as the identifier.

Initializes a variable to have an immutable binding.
In other words, attempting to reassign the variable to associate with another value is a syntax error.
However, if the associated value is a table, modifying its keys is allowed.
Instead, tables still require `table.freeze()` to make the table read-only.

All `const` usages disallow variable declaration and only allow variable initialization.
In other words, `const IDENTIFIER` is disallowed, but `const IDENTIFIER = VALUE` is allowed.

Despite `const` sounding similar to "constant", it is declaring a variable.
To prevent ambiguity with `local`, they're called `const` variable.
Variables declared using `local` is a `local` variable.

A `const` variable can be shadowed by a `local` variable, or by a `const` variable.
This will *override* the previous value.

Example:

```luau
const x = 2
x = 1 -- Syntax error. Attempting to reassign the variable.
x += 1 -- Syntax error. Compound assignment is attempting to write to the variable.

const function foo()
    do_something()
end
foo = 1 -- Syntax error. Attempting to reassign the variable.
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
In Luau, `type` is a contextual keyword.
This identifier cannot be shadowed by a declaration using this name as the identifier.

Not to be confused with `type()`, which is a global function and can be shadowed.

Creates a type alias when defined with `type IDENTIFIER = VALUE` (whitespaces for illustration purposes).

For more information, see [Luau Type System](https://luau.org/types/).

Example for singleton types:

```luau
--!strict
type EnumIdentifier = string
type EnumValue = number

local animals = {}

local function AddEnumItem(identifier: EnumIdentifier, value: EnumValue): ()
    animals[identifier] = value
end

AddEnumItem("Cat", 1)
AddEnumItem("Seal", 2)
AddEnumItem("Fish", 3)
```

Example for a table type:

```luau
--!strict
type Cat = {
    what: "Cat",
    name: string,
    age: number
}

const cat: Cat = { -- Throws a type error if it's missing any fields
    what = "Cat",
    name = "Taz",
    age = 12,
}
```

Example for a function type:

```luau
--!strict
type OperatorFunction = (operand_1: number, operand_2: number) -> number -- Parameter names are optional.

local add: OperatorFunction
add = function(operand_1: number, operand_2: number): number -- Throws a type error if mismatching parameter types or return type.
    return operand_1 + operand_2
end

add(1, 2)
add(3, 4)
```
<!-- /keyword -->

<!-- keyword: typeof -->
`typeof` is a function inside of type alias or type annotation.
It is not exactly a type function.
It uses `()` instead of `<>` to pass in the argument.

Returns the inferred type of the argument.
<!-- /keyword -->

<!-- keyword: read -->
`read` is a modifier keyword inside of a type alias.
It only sets a table key's "read" property to a type.
This also works on the table's indexer.

When reading a key with a `read` modifier, the value becomes the key's type.

`read` modifier only sets the table key's "read" property. It does not set the "write" property.
Unless `write` is defined separately, attempting to write to the table key results in a type error.

When the table key does not have a modifier, both `read` and `write` are implicitly assigned to the key's type.
If both `read` and `write` modifiers for a table key are explicitly defined and assigned to the same type, it is converted to use no modifiers.

Adding the `read` modifier only changes the table key at the type system level, it does not affect runtime.
Nevertheless, the table key is still considered "read-only" if it only has a declaration with a `read` modifier.

Example with using the `read` modifier:

```luau
--!strict
type T = {
    read a: string
}

local tab: T = {
    a = "1"
}

-- No type error. This is reading the value of `tab.a`.
local res = tab.a .. "2"
print(res) -- "12"

-- Type error. Attempting to write to `tab.a`, but it doesn't have a "write" property, so this is not allowed.
tab.a = "100"
```

Example with clear distinction between the `read` and `write` modifiers:

```luau
--!strict
type TOCTOU = {
    read a: string, -- This is still separated by a comma like a normal table key.
    write a: number
}

local some_table: TOCTOU = {
    a = "1"
}

-- No type error. This is reading the value of `tab.a` here.
-- However, `some_table.a + 1` is a type error.
local res = some_table.a .. "2"
print(res) -- "12"

-- No type error. This is writing to `tab.a` here.
-- However, `some_table.a = "1"` is a type error.
some_table.a = 1
```

When using `table.freeze()` onto a table, all keys without a modifier in the table type will have the `read` modifier, and all keys with a `write` modifier will disappear.
In this case, the table keys are also "read-only" at runtime because of this function.

```luau
--!strict
type STRANGE_TYPE = {
    read a: string,
    write a: number,
    b: boolean
}

local strange: STRANGE_TYPE = {
    a = "1",
    b = true
}

--[[
    `res` will get this type:
    {
        read a: string,
        read b: boolean
    }
    
    Notice that the "write" property disappeared and the `b` key only has its "read" property.
]]
local res = table.freeze(strange)
```
<!-- /keyword -->

<!-- keyword: write -->
`write` is a modifier keyword inside of a type alias.
It only sets a table key's "write" property to a type.
This also works on the table's indexer.

When writing a key with a `write` modifier, the value must be a subtype of the key's "write" property.

`write` modifier only sets the table key's "write" property. It does not set the "read" property.
Unless `read` is defined separately, attempting to read the table key's value results in a type error.

When the table key does not have a modifier, both `read` and `write` are implicitly assigned to the key's type.
If both `read` and `write` modifiers for a table key are explicitly defined and assigned to the same type, it is converted to use no modifiers.

Adding the `write` modifier only changes the table key at the type system level, it does not affect runtime.
Nevertheless, the table key is still considered "write-only" if it only has a declaration with a `write` modifier.

Example with using the `write` modifier:

```luau
--!strict
type T = {
    write a: string
}

local tab: T = {
    a = "1"
}

-- No type error. This is writing to `tab.a`.
tab.a = "100"

-- Type error. Attempting to read `tab.a`, but it doesn't have a "read" property, so this is not allowed.
local res = tab.a .. "2"
print(res) -- "12"
```

Example with clear distinction between the `read` and `write` modifiers:

```luau
--!strict
type TOCTOU = {
    read a: string, -- This is still separated by a comma like a normal table key.
    write a: number
}

local some_table: TOCTOU = {
    a = "1"
}

-- No type error. This is reading the value of `tab.a` here.
-- However, `some_table.a + 1` is a type error.
local res = some_table.a .. "2"
print(res) -- "12"

-- No type error. This is writing to `tab.a` here.
-- However, `some_table.a = "1"` is a type error.
some_table.a = 1
```

When using `table.freeze()` onto a table, all keys without a modifier in the table type will have the `read` modifier, and all keys with a `write` modifier will disappear.
In this case, the table keys are "read-only" at runtime because of this function.

```luau
--!strict
type STRANGE_TYPE = {
    read a: string,
    write a: number,
    b: boolean
}

local strange: STRANGE_TYPE = {
    a = "1",
    b = true
}

--[[
    `res` will have this table type:
    {
        read a: string,
        read b: boolean
    }
    Notice that the "write" property disappeared and the `b` key only has its "read" property.
]]
local res = table.freeze(strange)
```
<!-- /keyword -->

<!-- keyword: self -->
In object-oriented programming, `self` is a naming convention to refer to the current object.
Lua has prototype-based programming with metatables and Luwu added first-class support for classes.
Both are related to object-oriented programming.

In any case, `self` gains a unique syntax highlighting for user accessibility.
Depending on the usage, `self` might be the first parameter in a function.
<!-- /keyword -->

<!-- keyword: __init -->
In Luwu, this is the function identifier for a user-defined class constructor.

If `__init()` is a `public` function, the class constructor will directly run this function.

If `__init()` is a `private` function, the class requires a `public` function to run this constructor and return the object.
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
A `local function` that cannot be mutated. Like `local function`s, these may be inlined by the compiler if their function bodies are small enough.
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
```
<!-- /keyword -->

<!-- !stop parsing -->
<!-- The keywords below only ever appear in embedder declaration/definition files, where hover and diagnostics don't currently run -- low priority, but kept for completeness. -->

<!-- keyword: declare -->
<!-- /keyword -->

<!-- keyword: extends -->
<!-- /keyword -->

<!-- keyword: declare_extern_type -->
<!-- /keyword -->
