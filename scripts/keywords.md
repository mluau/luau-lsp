# Keywords

<!-- keyword: and -->
`and` is a logical operator.
It does not always evaluate to a `boolean`.
It is a reserved keyword.

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
it allows the `and-or` idiom for ternary conditional operator, which is a side effect of the evaluation behavior.
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

In Luau, it added a lint and `if-else` *expression* for ternary conditional operators to prevent this common pitfall and correctly evaluate to `false` in that example.

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

```luau
do
    -- Code block.
end
```

In the context of a file, a chunk is a top-level code block, which is the entire source code.

This keyword is used with `while` and `for` loop statements to create the loop body.
It is the delimiter after the conditions and before the loop body.

```luau
for i = 1, 10 do
    -- Code block in a lower scope.
    -- `i` is a `local` variable.
    print(i)
end
```

```luau
for key, value in list do
    -- Code block in a lower scope.
    -- `key` and `value` are `local` variables.
    print(key, value)
end
```

All global variable declarations do not bound to the current scope.

```luau
do
    -- Code block in a lower scope.
    a = 2
end
print(a) -- 2
```

All `local` and `const` declarations inside of a code block are bound to the current scope.
After the `end` keyword, the bindings are out-of-scope and their identifier returns to associate with the previous value in the outer scope (if shadowed) or `nil` (if not shadowed).

```luau
local a = 1
do
    -- Code block in a lower scope.
    local b = 2
    print(a, b) -- 1 2
end
print(a, b) -- 1 nil
```

When the variable identifier takes the same name as an outer scope, the variable is shadowed and the later declaration takes precedence.

```luau
local a = 1
do
    -- Code block in a lower scope.
    local a = 2
    print(a) -- 2
end
print(a) -- 1
```
<!-- /keyword -->

<!-- keyword: if -->
Creates an `if` *statement* or `if` *expression*, depending on the context.
It is a reserved keyword.

If the condition evaluates to a truthy value, the code block executes, and then skips over the remaining conditional branches, if any.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

An `if` *statement* structure has a condition and a code block.
The condition goes between the `if` keyword and the `do` keyword.
See documentation for the `do` keyword for more details about code blocks.

An `if` *statement* creates a clause.
In technical terms, it creates a conditional branch.
There can only exist 1 `if` clause.
When the program is compiled into bytecode, a conditional branch corresponds to an appropriate jump instruction to conditionally skip bytecodes.

Example for `if` *statement*:

```luau
if x == y then
    do_something(x)
end
```

`if` *statements* can be used with the `elseif` keyword, which creates another conditional branch.
There can exist many `elseif` clauses after the `if` clause and before the `else` clause.
It only evaluates its condition when all previous conditions are falsy.
This is known as an `if-then-elseif` statement, or `if-elseif` statement.

```luau
if x == y then
    do_something(x)
elseif y == z then
    do_something_else_on_condition(y)
end
```

The `else` keyword creates a conditional branch that only and always executes when all previous conditions are falsy.
There can only exist 1 `else` clause.
Without `elseif`, this is known as an `if-then-else` statement, or `if-else` statement.
With `elseif`, this is known as an `if-then-elseif-then-else` statement, of `if-elseif-else` statement.

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
In other words, its appearance is similar to at least an `if-else` statement without the `end` keyword.
It also allows `elseif` to create another conditional branch similar to `if` statements.

Unlike `if` statements, code blocks correspond to the result to assign to the variable.

In pseudocode:

```txt
IDENTIFIER = if condition then result_if_true else result_if_false

IDENTIFIER = if condition_1 then result_if_true_1 elseif condition_2 then result_if_true_2 else result_if_false
```

Whitespaces can be used for better user readability.

```txt
IDENTIFIER =
    if condition then
        result_if_true
    else
        result_if_false

IDENTIFIER =
    if condition_1 then
        result_if_true_1
    elseif condition_2 then
        result_if_true_2
    else
        result_if_false
```

Example:

```luau
-- If x == y then assign `value` to `100`,
-- else run the `do_something()` function on `y` and assign `value` to the return value of that function.

const value =
    if x == y then
        100
    else
        do_something(y)
```
<!-- /keyword -->

<!-- keyword: else -->
Creates a conditional branch to an `if` statement or `if` expression that only and always executes when all previous conditions are falsy.

See documentation for `if` keyword for more details.

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
If the condition evaluates to a truthy value, the code block executes, and then skips over the remaining conditional branches, if any.

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
-- Notice that the if expression requires a final `else` keyword.
const found_cat = if cat == nyla then nyla elseif cat == taz then cats[taz] else none
```
<!-- /keyword -->

<!-- keyword: end -->
`end` is a reserved keyword.

It ends a code block. It does not end a chunk.
See documentations for the `do` keyword for more details about code blocks.

It also ends a function body. However, this is the same as a code block.
<!-- /keyword -->

<!-- keyword: false -->
The falsy `boolean` value.
It is a reserved keyword.

It is one of the few falsy values.
In Lua, the other falsy value is `nil`.
In Luwu, `none` is also a falsy value.
<!-- /keyword -->

<!-- keyword: for -->
Creates a `for` loop.
It is a reserved keyword.
The exact form of the `for` loop depends on the context.

In Lua, a `for` loop has 2 forms: numeric and generic.

A numeric `for` loop structure has a control variable, an initial value, a limit value, a step value, and a loop body.

The control variable can be used in the loop body, which is a code block, and is bound within that scope.
See documentation for the `do` keyword for more details about code blocks.

The initial value, limit value, and step value must evaluate to a number with `tonumber()`.
The step value is optional and defaults to `1`.

In pseudocode:

```txt
for NAME = INITIAL, LIMIT, STEP do
    block
end
```

Step value behavior:

- If the step value is positive, the initial value must be less than the limit value.
- If the step value is negative, the initial value must be greater than the limit value.
- If the step value is `0`, the loop is skipped.
- If the step value increments or decrements the control variable over the limit value, the loop stops iterating.

Example:

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

A generic `for` loop structure has any amount of variables, the `in` keyword, an iterator function, and a loop body.

The variables correspond to the returned values from the iterator function.
They can be used in the loop body, which is a code block, and are bound within that scope.
See documentation for the `do` keyword for more details about code blocks.

In pseudocode:

```txt
for VAR_1, VAR_2, ..., VAR_N in ITERATOR(TABLE) do
    block
end
```

In Lua, the built-in `ipairs()` and `pairs()` are iterator functions and both are called per iteration and return 2 variables.

- `ipairs()` guarantees consecutive ordering from index `1` to the last index that is not `nil` in the table.
The iterator function stops at the first `nil` element, which separates the array part and the hash part of the table, and doesn't execute the loop body.
- `pairs()` does not guarantee any ordering.
In practice, it might have a pattern to loop from the array part and then the hash part, but this is not always true.

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

Iterating through a mixed table (a table with both an array part and a hash part):

```luau
-- The output iterates through every keys in the table.
-- However, this is not always guaranteed. This is clearly seen in Lua.
--
-- In Luau, the implementation details of the initial table declaration makes it seem ordered.
-- This is not always the case when the table is modified much further.
local t = {
    [5] = "could be the first",
    [1] = "foo",
    [2] = "bar",
    [4] = "apple",
    
    ["chocolate"] = "sugar rush!",
    ["circle"] = "shape"
}

for key, value in pairs(t) do
    print(key, value)
end
```

In Luau, `ipairs()` and `pairs()` in a generic `for` loop are recognized as idioms.
They're optimized to no longer be called per iteration and directly return the variables.
There is also another generic `for` loop idiom called the generalized iteration algorithm, which has 2 parts.

- Firstly, it checks for the table's `__iter` metamethod.
If found, the generic `for` loop calls the metamethod on loop startup and uses the returned generator function, "state", and "index".
The generator function is not optimized and is always called per iteration.
This function implements the iterator protocol as seen in the `next()` built-in function.
The parameters passed into this function are the "state" and "index" from the metamethod.
The returned values are the key/index and the value.
After an iteration, the returned key/index becomes the new "index" value and the generator function is called again.
When "index" is `nil`, the iteration stops.

```luau
-- Run the example first before starting to read through this example.
-- Start reading from at the metatable.

local function increment(state, index)
	-- For illustration purposes, this function is simple.
	-- It increments the index by 1 and returns "meow" every iteration.
	
	-- This shows calling the iterator function every iteration.
	print("hit generator")
	
	local new_index
	if index then
		new_index = index + 1
	else
		new_index = 1
	end
	
	if new_index == 3 then
		-- This shows stopping the iteration with the returned index/key as `nil`.
		-- The returned value is unused.
		return nil, "grr"
	end
	
	-- Returns the index/key and the value.
	return new_index, "meow"
end

local meta = {
    -- >> Start here << --
    -- >> Start here << --
    -- >> Start here << --
	__iter = function(self)
		-- This shows the `for` loop calling `__iter` once.
		print("hit __iter")
		
		-- Returns the generator function, "state", and "index".
		-- After returning, "state" and "index" are magically passed into the generator function.
		return increment, self, nil
	end
}

local tbl = setmetatable({}, meta)

for k, v in tbl do
	-- This prints after the iterator function every iteration.
	print(k, v)
end
```

- Secondly, it uses the default table iteration algorithm. This algorithm is similar to `pairs()` and returns 2 variables.
Unlike `pairs()`, it guarantees the same ordering as `ipairs()` until an index is `nil` (this index is skipped),
and then changing to an unspecified ordering as `pairs()` for the remaining keys.

```luau
--[[
    This is a previous example. The `for` loop idiom is changed.
    
    Expected output:
    1 foo
    2 bar
    ...
    unspecified
    ...
    
    Notice that 1 and 2 are always ordered.
    
    The remaining keys should have an unspecified ordering.
    However, the implementation details of Luau's initial table declaration makes it seem ordered.
]]
local t = {
    [5] = "could be the first",
    [1] = "foo",
    [2] = "bar",
    [4] = "apple",
    
    ["chocolate"] = "sugar rush!",
    ["circle"] = "shape"
}

for key, value in t do
    print(key, value)
end
```
<!-- /keyword -->

<!-- keyword: function -->
`function` is a reserved keyword.

It declares a `function`.
By default, all functions are "global" variables.

A function structure has a list of parameters and a function body.
Technically, Lua defines the list of parameters as the function body as well.
In this documentation, the function body is only the code block.
See documentation for the `do` keyword for more details about code blocks.

When calling a function, it allows specifying the arguments to pass into the function.
The order of arguments passed into the function corresponds to the order of parameters in the function body.
Parameters are `local` variables and follow the same rules as them, so the variable identifier naming rules and their scope is bound to the function body.

Optionally, functions can return zero or more values using the `return` keyword.
See documentation for the `return` keyword for more details.

Pseudocode to define a function:

```txt
function(PARAMETER_1, PARAMETER_2, ..., PARAMETER_N)
    block
end
```

This definition does not have an identifier.
This is also known as an unnamed function or an anonymous function.

There is also a syntax sugar function definition:

```txt
function IDENTIFIER(PARAMETER_1, PARAMETER_2, ..., PARAMETER_N)
    block
end
```

...which is the equivalent to this definition. Not to be confused with the syntax sugar for `local function`:

```txt
IDENTIFIER = function(PARAMETER_1, PARAMETER_2, ..., PARAMETER_N)
    block
end
```

However, it is not strictly equivalent in Luau because calling `debug.info(foo, "n")` returns `"foo"` (the function name) in the first example and `""` (empty string) in the second example.
This is because the assigned value is considered an anonymous function. In contrast, in Lua, calling `debug.getinfo(foo)` returns `"foo"` (the function name) in both examples.
Furthermore, in both Lua and Luau, the bytecode compiler emits a specialized bytecode instruction for the first example, but emits extra bytecode instructions for the second example.
Though, this difference is negligible.

Optionally, function parameter allows a "vararg expression" using ellipsis (`...`) at the end of the parameter list.
This makes the function a variadic function.
All arguments starting from the one corresponding to `...` will be collected into this expression.
When using this value in an expression, it will only evaluate using the first element.
The vararg expression can directly return a value at a specific index using `select()`,
or be converted into a table with `{...}` or using `table.pack(...)`.

Functions are first-class citizens.
Their reference can be passed into a function using the identifier as arguments,
returned from a function as a value, assigned to a variable, and used as keys in tables.

In Luau, the type definition for functions in type alias has this syntax in pseudocode:

```txt
(PARAM_1: PARAM_TYPE_1, PARAM_2: PARAM_TYPE_2, ..., PARAM_N: PARAM_TYPE_N) -> (RETURN_TYPE_1, RETURN_TYPE_2, ..., RETURN_TYPE_N)
```

In this case, parameter names are optional.
Parentheses for the return type are optional when there is only 1 return type.

When type annotating the function, it has this pseudocode:

```txt
function IDENTIFIER(PARAM_1: PARAM_TYPE_1, PARAM_2: PARAM_TYPE_2, ..., PARAM_N: PARAM_TYPE_N): (RETURN_TYPE_1, RETURN_TYPE_2, ..., RETURN_TYPE_N)
    block
end
```

Parameter types are necessary when the function should expect a specific type for the arguments.
Parentheses for the return type are optional when there is only 1 return type.

Example of declaring a function and calling the function:

```luau
function add(x, y)
    return x + y
end

result = add(1, 2)
print(result) -- 3
```

Functions can be prefixed with a `local` or `const` keyword.
See documentation on the `local` keyword for more details.

```luau
local function foo(x, y)
    print(x, y)
end
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
function module.functionName()
    -- do something
end
module.functionName() -- call from the table
```

```luau
local table = {
    key = {}
}

function table.key.func(parameter)
    print(parameter)
end

table.key.func("argument")
```

Additionally, if the `:` operator is used before the function identifier, the first parameter is implicitly defined as `self`.
In this case, the function is also referred to as a method.

```luau
local table = {
    key = {}
}

function table.key:func(parameter)
    print(self)
    print(parameter)
end

-- The function definition above is syntax sugar for below.

function table.key.func(self, parameter)
    print(self)
    print(parameter)
end



table.key:func("argument")

-- The function call above is syntax sugar for below.
-- However, Luau optimized the syntax sugar.
-- Also, the original function definition doesn't have to be a method for this syntax to work.

table.key.func(table.key, "argument")
```

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
To catch errors, use the builtin `pcall` or `xpcall` functions.
<!-- /keyword -->

<!-- keyword: in -->
`in` is a reserved keyword.

It is a delimiter for generic `for` loops.
See documentation for the `for` keyword for more details.
<!-- /keyword -->

<!-- keyword: local -->
`local` is a reserved keyword.

It declares a variable to have a mutable binding.
In other words, reassigning the variable to associate with another value is allowed.

Variable identifiers must only include ASCII alphanumerical characters and `_`, and must not start with a number.
They must not have the same identifier as reserved keywords. They can have the same identifier as other keywords.

When a `local` variable is read or written to from a function, it is called an upvalue.
In this case, technically, the function is also referred to as a closure.

The `local` keyword is an antonym to "global" variables.
In Lua, global variables are declared as `IDENTIFIER = VALUE` when the variable isn't assigned,
and assigns itself as a key into the `_G` global variable.

All `local` variables are bound to the current scope, which is related to code blocks.
See documentation for the `do` keyword for more details about code blocks.

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

In Lua, declaring a variable (without assigning a value) results in `nil`.

```luau
local a
print(a) -- nil
```

In Luau, declaring a `local` variable and annotating it with a type will treat that variable as that type.
However, this does not change runtime behavior, only at the type system level, and reading the `local` variable still results in `nil`.

```luau
--!strict
local a: string
print(a) -- nil

-- No type error.
-- However, `a = 123` is a type error because `123` is a number and not a string.
a = "meow"
print(a) -- "meow"
```

Technically, there is a limit to the amount of `local` variables (including function arguments) and upvalues.
In Lua, the former is 60 per function, while the latter is 200 per function.
In Luau, both limits are 200 per function.

In Luau, if a `local` variable is never reassigned (shadowing is not reassignment),
the bytecode compiler performs constant folding optimization to avoid hitting the limit for `local` variables and upvalues.
If the value is a table, it must be clear that the keys must are never reassigned so that this optimization happens - this case only happens for trivial situations.

`local` can be applied to `function` to define a `local function`.

```luau
local function foo(x: string, y: number)
    print(x, y)
end
```

In Lua and Luau (with caveats, explained below), it is syntax sugar for defining a variable before assigning it the function.
This approach allows calling the function itself within the function body, which allows recursive function calls.

```luau
local foo
foo = function(x: string, y: number)
    print(x, y)
end
```

However, it is not strictly equivalent in Luau because calling `debug.info(foo, "n")` returns `"foo"` (the function name) in the first example and `""` (empty string) in the second example.
This is because the assigned value is considered an anonymous function. In contrast, in Lua, calling `debug.getinfo(foo)` returns `"foo"` (the function name) in both examples.
Furthermore, in both Lua and Luau, the bytecode compiler emits a specialized bytecode instruction for the first example, but emits extra bytecode instructions for the second example.
Though, this difference is negligible.

In Luau, `local function` (and `const function`) can be automatically inlined.
The function body must be simple enough for the optimization to be profitable.
Otherwise, no function inlining happens and the bytecode compiler emits a function call instruction.
Technically, the bytecode compiler calculates an estimated profit using a pre-defined bytecode cost of all bytecodes within the function body.
Recursive function calls can't be inlined. Functions cannot be marked by the user to force function inlining.
<!-- /keyword -->

<!-- keyword: nil -->
`nil` is a falsy value.
It is a reserved keyword.

It is one of the few falsy values.
In Lua, the other falsy value is `false`.
In Luwu, `none` is also a falsy value.

For a variable (including function parameters), unassigned variables default to `nil`.
When reading a variable that isn't assigned, `nil` is returned as the default value.

```luau
-- Assume `foo` is unassigned.
print(foo) -- nil
```

```luau
local function foo(bar)
    print(bar) -- nil
end

foo()
```

For a table, `nil` cannot be the table's key.
When initializing the table, any key assigned to `nil` is omitted.
When assigning an index or a key to `nil`, the index or key is removed from the table, if any.
When reading an index or a key that isn't assigned, `nil` is returned.
For an alternative that can be stored in tables, see documentation for the `none` keyword.

```luau
local t = {
    foo = nil,
    bar = true
}
print(t) -- {bar = true}
print(t.foo) -- nil

t.apple = nil
print(t) -- {bar = true}

t.bar = nil
print(t) -- {}
```

For a function, if the function returns no values, it does not return anything, not even `nil`.
However, if the function returns 1 value that is `nil`, it does return `nil`.
At runtime, there are no differences between these cases.

For a module, if the module returns no values, it cannot be required and throws an error at runtime.
If the module returns `nil`, it can be required. This satisfies the requirement for a module.

For the Luau type system, `nil` can be represented as `nil` or by the postfix operator `?`.
For both the function and module cases above, it treats the former case as `()` (no value, this type is only annotated in functions) and the latter case as `nil`.
These are different from each other because they are incompatible with each other.

For the length operator (`#`), this might not be reliable to get the expected array length when the table has `nil` in the array part.

For implementing the iterator protocol for the `__iter` metamethod, when the "index" is `nil`, the iteration stops.
See documentation for the `for` keyword for the generalized iteration algorithm and the `__iter` metamethod.

In other usages, especially built-in functions and the C API, `nil` may represents the nonexistence of a value or a representable value,
or a value to trigger one of the previous cases.
For example, `tonumber("abc")` does not have any results that can represent `"abc"` as a number, so it returns `nil`.

```luau
print(tonumber("abc")) -- nil
```
<!-- /keyword -->

<!-- keyword: not -->
`not` is a logical operator.
It always evaluate to a `boolean`.
It is a reserved keyword.

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
`or` is a logical operator.
It does not always evaluate to a `boolean`.
It is a reserved keyword.

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
it allows the `and-or` idiom for ternary conditional operator, which is a side effect of the evaluation behavior.
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

In Luau, it added a lint and `if-else` *expression* for ternary conditional operators to prevent this common pitfall and correctly evaluate to `false` in that example.

```luau
if true then false else 30 -- false
```
<!-- /keyword -->

<!-- keyword: repeat -->
Creates a `repeat` loop.
It is a reserved keyword.

The loop body executes first and then the loop evaluates the condition to start the iteration.
If the condition evaluates to a falsy value, the code block will execute again, and then this loop repeats.
In other words, the loop body executes, and then evaluates the condition, and this loop *repeats* this cycle *until* the condition is truthy.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

A `repeat` loop structure has a loop body, `until` keyword, and the condition.
The loop body is a code block. See documentation for the `do` keyword for more details about code blocks.
The condition is checked for falsy *after* the code block executes and then checked again until it is truthy.
This condition is also within the scope of the loop body.

In pseudocode:

```txt
repeat
    block
until condition
```

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
`then` is a reserved keyword.

It's a delimiter to separate the condition in an `if` or `elseif` clause from the body.
See documentation for the `if` keyword for more details.
<!-- /keyword -->

<!-- keyword: true -->
The truthy `boolean` value.
It is a reserved keyword.

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
Creates a `while` loop.
It is a reserved keyword.

If the condition evaluates to a truthy value, the loop body executes, and then it checks the condition again.
In other words, this loop keeps iterating *while* its condition evaluates to a truthy value.

In Lua and Luau, `false` and `nil` are considered falsy.
In Luwu, it added `none` and it's also considered falsy.
All other values are considered truthy.

A `while` loop structure has a condition and a loop body.
The condition is checked for truthy *before* the code block executes and then checked again until it is falsy.
The loop body is a code block. See documentation for the `do` keyword for more details about code blocks.

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

The technical term for this type of loop is a pre-test loop.
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
This keyword can be put in any positions valid for the `local` keyword.

It initializes a variable to have an immutable binding.
In other words, attempting to reassign the variable to associate with another value is a syntax error.
However, if the associated value is a table, modifying its keys is allowed.
Instead, tables still require `table.freeze()` to make the table read-only.

All `const` usages disallow variable declaration and only allow variable initialization.
In other words, `const IDENTIFIER` is disallowed, but `const IDENTIFIER = VALUE` is allowed.

All `const` variables are bound to the current scope, which is related to code blocks.
See documentation for the `do` keyword for more details about code blocks.

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

Outside of reassignment differences, `const` is the same as `local`.
See documentation for the `local` keyword for more details.

Despite `const` sounding similar to "constant", it is declaring a variable.
To prevent ambiguity with `local`, they're called `const` variable.
Variables declared using `local` is a `local` variable.
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
`export` is a contextual keyword.
It is possible to declare a variable using `export` as the identifier, which loses its functionality.

It can expose values, classes, or type aliases from a module into the file that called `require()` on the module.

<!-- NOTE: Export-by-value is still experimental. This is commented out.
For values and classes, `export` implicitly adds the identifier (as the key) and value (as the value) into the module's returned table.
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
-- due to current lack of an equivalent import keyword, you need to do this
const list = require("./list")
const List = list.List
type List<T> = list.List

const listy = List("Taz", "Nanuk", "Nyla")
```
<!-- /keyword -->

<!-- keyword: export_type -->
Exposes the type alias from a module into the file that called `require()` on the module.
See documentation for the `export` keyword for more details.

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
Same as `local function`, but has assignment behaviors from the `const` keyword.
See documentation for the `local` keyword for more details about `local function`.
<!-- /keyword -->

<!-- keyword: class_const -->
In a class, `const` is a modifier keyword for a class field.

During class construction in the `__init` constructor function, `const` fields must be assigned a value.
These fields can only be reassigned within the constructor.
In other cases, this is not allowed.

If a `const` field is unassigned, throws a type error.
At runtime, this is a runtime error.

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
