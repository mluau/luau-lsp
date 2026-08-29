# Keywords

<!-- keyword: and -->
In general, because of how truthy and falsy values are treated,
the technical behavior is equivalent to the `AND` logical operators in other programming languages.
When **both** arguments are truthy values, the result is a truthy value. Otherwise, it is falsy.

It does not always evaluate to a `boolean`.

It evaluates the first argument (on the left) and then returns it if it's **falsy**.
Otherwise, it evaluates and then returns the second argument (on the right), no matter what the first argument is.

Examples:

```luau
nil and 20 -- nil
false and 20 -- false
true and 20 -- 20
10 and 20 -- 20
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

```luau
do
    -- Code block.
end
```

All `local` and `const` declarations inside of a code block are bound to that scope.

`do` is used with `while` and `for` loop statements to separate the conditions from the loop body.
<!-- /keyword -->

<!-- keyword: if -->
Creates an `if` *statement* or `if` *expression*, depending on the context.

If the condition evaluates to a truthy value, the code block executes, and then skips over the remaining conditional branches, if any.

Example for `if` *statement*:

```luau
if x == y then
    do_something(x)
end
```

`if` *statements* can be used with the `elseif` keyword, which creates another conditional branch.
There can exist many `elseif` clauses after the `if` clause and before the `else` clause.
It only evaluates its condition when all previous conditions are falsy.

```luau
if x == y then
    do_something(x)
elseif y == z then
    do_something_else_on_condition(y)
end
```

The `else` keyword creates a conditional branch that only and always executes when all previous conditions are falsy.
There can only exist 1 `else` clause.

```luau
if x == y then
    do_something(x)
else
    do_something_else(y)
end
```

```luau
if x == y then
    do_something(x)
elseif y == z then
    do_something_else_on_condition(y)
else
    do_something_else(z)
end
```

In Luau, an `if` *expression* is a ternary conditional operator to replace the `and-or` idiom.
See the `and` keyword or the `or` keyword for more details about this idiom.

`if` *expression* requires an explicit `else` clause and does not use the `end` keyword.
It also allows `elseif` to create another conditional branch similar to `if` statements.

Unlike `if` statements, code blocks correspond to the result to assign to the variable.

Whitespaces can be used for better user readability.

Example:

```luau
-- If x == y then assign `value` to `100`,
-- else if y == z then assign `value` to `200`,
-- else run the `do_something()` function on `y` and assign `value` to the return value of that function.

const value =
    if x == y then
        100
    elseif y == z then
        200
    else
        do_something(y)
```
<!-- /keyword -->

<!-- keyword: else -->
Creates a conditional branch to an `if` statement or `if` expression that only and always executes when all previous conditions are falsy.

Example using `else` in `if` *statement*:

```luau
if x == y then
    do_something(x)
else
    do_something_else(y)
end
```

Example using `else` in `if` *expression*:

```luau
const found_cat = if cat == nyla then nyla else none
```
<!-- /keyword -->

<!-- keyword: elseif -->
Creates a conditional branch to an `if` statement or `if` expression that only evaluates its condition when all previous conditions are falsy.

See documentation for `if` keyword for more details.

Example using `elseif` in `if` *statement*:

```luau
if x == y then
    do_something(x)
elseif y == z then
    do_something_else(y)
end
```

Example using `elseif` in `if` *expression*:

```luau
-- Notice that the if expression requires a final `else` clause.
const found_cat = if cat == nyla then nyla elseif cat == taz then cats[taz] else none
```
<!-- /keyword -->

<!-- keyword: end -->
This keyword ends a code block.

It also ends a function body. However, this is the same as a code block.
<!-- /keyword -->

<!-- keyword: false -->
The falsy `boolean` value.

It's one of the few falsy values.
The other falsy values are `nil` and `none`.
<!-- /keyword -->

<!-- keyword: for -->
Creates a `for` loop.
The exact form of the `for` loop depends on the context.

`for` loop has 2 forms: numeric and generic.

A numeric `for` loop structure has a control variable, an initial value, a limit value, a step value, and a loop body.

Examples:

```luau
for i = 3, 5 do
    print(i) -- 3 4 5
end
```

```luau
for i = 10, 5, -2 do
    print(i) -- 10 8 6
end
```

A generic `for` loop structure is a list of variables, the `in` keyword, an iterator function or the table with a `__iter` metamethod, and a loop body.

The variables correspond to the returned values from the iterator function. They can be used in the loop body.

Iterating through an array using `ipairs()`:

```luau
--[[
    Expected output:
    1 foo
    2 bar
    3 moon
    4 seal
    5 cat
    
    Notice index 7 is not printed because index 6 is `nil`.
]]
local t = {"foo", "bar", "moon", "seal", "cat", [7] = "bad"}

for index, value in ipairs(t) do
    print(index, value)
end
```
<!-- /keyword -->

<!-- keyword: function -->
Declares a `function`.
By default, all functions are "global" variables.

Adding `local` or `const` allows the function to be automatically inlined if the function body is profitable.

```luau
local function add(x, y)
    return x + y
end

result = add(1, 2)
print(result) -- 3
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

Functions can be added into a table using the `.` operator, similar to assigning a key to a value.
In this case, `local`, `const`, and `export` cannot be used before `function`.

```luau
local module = {}

function module.functionName(parameter)
    print(parameter)
end

-- equivalent to

module.functionName = function(parameter)
    print(parameter)
end

module.functionName("argument") -- call from the table
```

```luau
local table = {
    key = {}
}

function table.key.func(parameter)
    print(parameter)
end

-- equivalent to

table.key.func = function(parameter)
    print(parameter)
end

table.key.func("argument")
```

Additionally, if the `:` operator is used before the function identifier, the first parameter is implicitly defined as `self`.
In this case, the function is also referred to as a method.

Functions can be called before their definition if their identifier is defined.

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

Functions can throw an error.
Lua errors are similar to exceptions in other programming languages.
To catch these errors, use the built-in `pcall` or `xpcall` functions.
<!-- /keyword -->

<!-- keyword: in -->
`in` is a delimiter for generic `for` loops.
<!-- /keyword -->

<!-- keyword: local -->
It declares a variable to have a mutable binding.
In other words, reassigning the variable to associate with another value is allowed.

When a `local` variable is read or written to from a function, it is called an upvalue.

All `local` variables are bound to the current scope.

```luau
local flag = true
if flag then
    -- Code block in a lower scope.
    local val = 20
    print(flag, val) -- true 20
end
-- `val` no longer exists outside of the scope
print(flag, val) -- true nil
```

Declaring a `local` variable and annotating it with a type will treat that variable as that type.

```luau
--!strict
local a: string
print(a) -- nil

-- No type error.
-- However, `a = 123` is a type error because `123` is a number and not a string.
a = "meow"
print(a) -- "meow"
```

`local` can be applied to `function` to define a `local function`.

```luau
local function foo(x: string, y: number)
    print(x, y)
end
```

It is syntax sugar for defining a variable before assigning it the function.
Though, manually writing this out loses the function identifier in `debug.info()`.

```luau
local foo
foo = function(x: string, y: number)
    print(x, y)
end
```

`local function` (and `const function`) can be automatically inlined.
The function body must be simple enough for the optimization to be profitable.
Recursive function calls can't be inlined. Functions cannot be marked by the user to force function inlining.
<!-- /keyword -->

<!-- keyword: nil -->
`nil` is a falsy value.

It's one of the few falsy values.
The other falsy values are `false` and `none`.

When assigning `nil` to a key, it removes the key from the table.

```luau
local t = {["foo"] = "bar"}
t.foo = nil
print(t) -- {}
```

In some built-in functions, `nil` is the default value. Other built-in functions uses `nil` to represent the nonexistence of a value or a representable value.
For example, `tonumber("abc")` does not have any results that can represent `"abc"` as a number, so it returns `nil`.

```luau
print(tonumber("abc")) -- nil
```
<!-- /keyword -->

<!-- keyword: not -->
`not` always evaluate to a `boolean`.

When the argument is falsy, `not` returns `true`.
When the argument is truthy, `not` returns `false`.

Examples:

```luau
not true -- false
not 20 -- false

not false -- true
not nil -- true
```

Doing `not (not argument)` and other variants with more `not` keywords is redundant.
It does not return the value of `argument` unless it was originally `true` or `false`.
<!-- /keyword -->

<!-- keyword: or -->
In general, because of how truthy and falsy values are treated,
this technical behavior is equivalent to the `OR` logical operators in other programming languages.
When **either** arguments are truthy values, the result is a truthy value. Otherwise, it is falsy.

It does not always evaluate to a `boolean`.

It evaluates the first argument (on the left) and then returns it if it's **truthy**.
Otherwise, it evaluates and then returns the second argument (on the right), no matter what the first argument is.

Examples:

```luau
nil or 20 -- 20
false or 20 -- 20
true or 20 -- true
10 or 20 -- 10
```
<!-- /keyword -->

<!-- keyword: repeat -->
Creates a `repeat` loop.

The loop body executes first and then the loop evaluates the condition to start the iteration.
If the condition evaluates to a falsy value, the code block will execute again, and then this loop repeats.
In other words, the loop body executes, and then evaluates the condition, and this loop *repeats* this cycle *until* the condition is truthy.

Example of good usage:

```luau
local attempt = 0

repeat
    local status, message = RequestPacket()
    attempt += 1
until status == true or attempt == 3
```

Example of bad usage:

```luau
-- This will iterate forever (don't do this without a `break` keyword)
repeat
    print("evil laughter!")
until false
```
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
`then` is a delimiter to separate the condition in an `if` or `elseif` clause from the code body.
<!-- /keyword -->

<!-- keyword: true -->
The truthy `boolean` value.

Falsy values are `false`, `nil`, and `none`.
All other values are considered truthy.

This value can represents a placeholder for a truthy value.

For example, an approach to represent a hash set using only a Lua table uses `true` as the value.
This works because Lua tables have a hash part for unique elements, key are assigned to `true`, which is truthy,
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
`until` evaluates the condition of a `repeat` loop.
It can read `local` and `const` variables from the loop body.
<!-- /keyword -->

<!-- keyword: while -->
Creates a `while` loop.

If the condition evaluates to a truthy value, the loop body executes, and then it checks the condition again.
In other words, this loop keeps iterating *while* its condition evaluates to a truthy value.

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
It skips evaluating code after the keyword and starts the next iteration of a loop.
It is a syntax error if `continue` is a keyword and the next token is not the `end` keyword.

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
Not to be confused with `const` field.

This keyword can be put in any positions valid for the `local` keyword.

It initializes a variable to have an immutable binding.
In other words, attempting to reassign the variable to associate with another value is a syntax error.

If the associated value is a table, modifying its keys is allowed.
Only the binding between the identifier and the reference to the table is immutable.
Instead, tables still require `table.freeze()` to make the table itself read-only at runtime.

All `const` usages disallow variable declaration and only allow variable initialization.
In other words, `const IDENTIFIER` is disallowed, but `const IDENTIFIER = VALUE` is allowed.

Outside of these differences, it has the same behavior as the `local` keyword.

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

Despite `const` sounding similar to "constant", it is declaring a `const` variable.
<!-- /keyword -->

<!-- keyword: public -->
Allow access to a class field, function, or method outside the class' scope.

This keyword can be omitted if every member of the class is `public`.
In other words, there are no `private` members.

```luau
class Cat
    name: string -- implicitly public
    function meow(self) -- implicitly public
        print("meow!")
    end
end
```

```luau
class List<T>
    private inner: { T }
    -- class contains a private field, public fields/functions must be marked explicitly
    public allocated_capacity: number = 42
    public function __init(self, ...: T)
        -- do something
    end
    public function with_capacity(cap: number)
        -- do something
    end
end
```
<!-- /keyword -->

<!-- keyword: private -->
Disallow access to a class field, function, or method outside the class' scope.

Attempting to access a `private` member will result in a runtime error.

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
`export` can expose values, classes, or type aliases from a module into the file that called `require()` on the module.

<!-- NOTE: Export-by-value is still experimental. This is commented out.
For values, `export` implicitly adds the identifier (as the key) and value (as the value) into the module's returned table.
These keys are `const` variables.

```luau
-- module.luau --
export local LOCAL_VALUE = 100
export const CONST_VALUE = 200

-- foo.luau --
local module = require("path/to/foo.luau")
print(module.LOCAL_VALUE) -- 100
print(module.CONST_VALUE) -- 200

-- These are not allowed.
module.LOCAL_VALUE = 50
module.CONST_VALUE = 50
```

This is syntax sugar to the equivalent in the `module.luau`:

```luau
local LOCAL_VALUE = 100
const CONST_VALUE = 200

-- `_EXP` is a pseudo-name.
local _EXP = {}
_EXP.LOCAL_VALUE = LOCAL_VALUE
_EXP.CONST_VALUE = CONST_VALUE
return table.freeze(_EXP)
```

Because of this, it also disallows the module to have return 1 value at the end of the file.
That is, `return` is no longer required for the file to be a module.
-->

For type aliases, `export` allows the file that called `require()` on the module to use the type from the module.
The type aliases can be used before the `require()` call.

```luau
-- module.luau --
type HashedPassword = buffer
export type User = {
    Username: string,
    UserId: number,
    Password: HashedPassword,
}

-- foo.luau
type User = module.User

local module = require("path/to/foo.luau")
```

For classes, `export` allows the file that called `require()` on the module to use the class from the module.
<!-- /keyword -->

<!-- keyword: type -->
Not to be confused with `type()`, which is a global function and can be shadowed.

Creates a type alias when defined with `type IDENTIFIER = VALUE`.

For more information, see [Luau Type System](https://luau.org/types/).
It is recommended to enable strict mode when type checking.

Example for singleton types:

```luau
--!strict
type EnumIdentifier = string
type EnumValue = number

local animals = {}

local function AddEnumItem(identifier: EnumIdentifier, value: EnumValue): ()
    animals[identifier] = value
end

-- Throws a type if any parameter doesn't have the same type as in the function signature.
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
`typeof` is a function inside of a type alias or a type annotation.

It is not exactly a type function. It uses `()` instead of `<>` to pass in the argument.

Returns the inferred type of the argument.
<!-- /keyword -->

<!-- keyword: read -->
`read` is a modifier keyword inside of a type alias.
It only sets a table key's "read" property to a type.
This also works on the table's indexer.

When reading a key with a `read` modifier, the value becomes the key's type.

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
<!-- /keyword -->

<!-- keyword: write -->
`write` is a modifier keyword inside of a type alias.
It only sets a table key's "write" property to a type.
This also works on the table's indexer.

When writing a key with a `write` modifier, the value must be a subtype of the key's "write" property.

`write` modifier only sets the table key's "write" property. It does not set the "read" property.
Unless `read` is defined separately, attempting to read the table key's value results in a type error.

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
<!-- /keyword -->

<!-- keyword: self -->
In object-oriented programming, `self` is a naming convention to refer to the current object.
Lua has prototype-based programming with metatables and Luwu added first-class support for classes.
Both are related to object-oriented programming.

In any case, `self` gains a unique syntax highlighting color for user accessibility, if configured.
Depending on the usage, `self` might be the first parameter in a function.
<!-- /keyword -->

<!-- keyword: __init -->
In Luwu, this is the function identifier for a user-defined class constructor.

If `__init()` is a `public` function, the class constructor will directly run this function.

If `__init()` is a `private` function, the class requires a `public` function to run this constructor and return the object.
<!-- /keyword -->

<!-- keyword: export_class -->
Exposes the class from a module into the file that called `require()` on the module.
See documentation for the `export` keyword for more details.

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
const list = require("./list")
const List = list.List
type List<T> = list.List

const listy = List("Taz", "Nanuk", "Nyla")
```
<!-- /keyword -->

<!-- keyword: export_type -->
Exposes the type alias from a module into the file that called `require()` on the module.

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
Same as `local function`, but has initialization and reassignment behaviors from the `const` keyword.
<!-- /keyword -->

<!-- keyword: class_const -->
In a class, `const` is a modifier keyword for a class field.

During class construction in the `__init` constructor function, `const` fields must be assigned a value.
These fields can only be reassigned within the constructor.
In other cases, this is not allowed.

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
