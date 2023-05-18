Here are some snippets of code I wrote, that I'm keeping to show some
aspect of how I write code in the small.

## bash

```bash
ropsql() {
  PSQLRC=<(
    [ -f ~/.psqlrc ] && cat ~/.psqlrc ;
    echo 'set session characteristics as transaction read only;') \
  psql "$@"
}
compdef ropsql=psql # zsh only
```

## lua
instead of using https://github.com/dropbox/zxcvbn to validate a password,

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

## python
Who needs argparse?

```python
def testing(fname):
    print(fname)

cmds = { "testing": testing }

if __name__ == "__main__":
    cmds[sys.argv[1]](*sys.argv[2:])
```

## clojure

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

## perl

https://github.com/kidd/dupplot/blob/master/dupplot.pl
