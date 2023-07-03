Here are some snippets of code I wrote, that I'm keeping to show some
aspect of how I write code in the small.

## bash/zsh

Wrapper for psql to reuse your .psqlrc config but in read-only mode.

```bash
ropsql() {
  PSQLRC=<(
    [ -f ~/.psqlrc ] && cat ~/.psqlrc ;
    echo 'set session characteristics as transaction read only;') \
  psql "$@"
}
compdef ropsql=psql # zsh only
```

My collection of advanced scripting tricks: https://raimonster.com/scripting-field-guide/

## lua
instead of using https://github.com/dropbox/zxcvbn to validate a password, I wrote this to validate that passwords should have lowercase,uppercase, numbers, symbols, and the minimum length varies depending on the amount of different types:

- only one type: nope
- two(for example upper and lower): 24
- three: 11
- all 4 types: 9

```lua
   local str  = io.read('*l')
   local d    = str:match("[0-9]")           and 1 or 0
   local down = str:match("[a-z]")           and 1 or 0
   local up   = str:match("[A-Z]")           and 1 or 0
   local s    = str:match("[!@#$^&*()_=+-]") and 1 or 0
   local l    = #str
   local defs = {math.huge, 24, 11, 9}
   print(d,down,up,s,l,l>=defs[d+down+up+s])
```

This code is not mine, but it's a good handle to talk about how
metatables work, and how this can be a memoizing function

```lua
 function memoize(func)
   return setmetatable({}, {
     __index = function(self, k) local v = func(k); self[k] = v; return v end,
     __call = function(self, k) return self[k] end
   })
 end
```

## python
Who needs argparse? I've seen more bad uses of argparse than good
ones. I explain here a few alternatives to argparse using plain python
that surprisingly give (IMO) better ergonomics.
https://puntoblogspot.blogspot.com/2022/04/parsing-args-with-python-alt-version.html
. IIRC Perl6 has also this approach that you can tag functions as "cli
commands", and the runtime will manage the docs and the parsing.

```python
def testing(fname):
    print(fname)

cmds = { "testing": testing }

if __name__ == "__main__":
    cmds[sys.argv[1]](*sys.argv[2:])
```

## clojure

Fancy validation of version strings ":v1.2.3-X1" or ":v1.2.3.4-X1", to
match only exactly 1 major version down. Fancy as in zipmap + fnil +
mergewith + juxt + array comparisons (apl-like).

```clojure
(defn- version-str->map [v]
  (update-vals
   (zipmap [:variant :major :minor :patch :x] ; create a map of the version parts
           (rest (re-matches #"^.*:v(\d+)\.(\d+)\.(\d+)(?:\.(\d+))?-X(\d+)$" v)))
   (fnil #(Integer/parseInt %) "0")))

(defn- should-migrate-down?
  "Returns if version `vto` is 1 major version less than `vfrom` and the `variant` is the same. This predicate is used
  to call `migrate down` on v1.45.2.1-X01 instances before a downgrade of exactly 1 major version down
  without caring about minor, patch or X.

  The smallest version that supports downgrade is 44."
  [vfrom vto]
  (let [from  (version-str->map vfrom)
        to    (version-str->map vto)
        diffs (merge-with - to from)]
    (and (= [0 -1] ((juxt :variant :major) diffs))
         (<= 44 (:major to)))))
```

## Perl

- Detecting duplicated streaks of lines in text files using Perl, with a
functional approach: https://github.com/kidd/dupplot#story

- Implementation of the Meta-II MetaCompiler as a single Perl Regex:
  https://github.com/kidd/meta-II/


## K

I "learned" K during the AoC'22 by studying the first half of ngn's
solutions to Advent of Code:
https://github.com/kidd/arraylangs-index/tree/master/notebooks
