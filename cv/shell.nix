with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "khcp";
  buildInputs = [
  rubber
  tetex
  ];

  shellHook = ''
    export PATH="$PWD/node_modules/.bin/:$PATH"
    alias scripts='jq -r ".scripts" package.json'
    function nmod() {
      for i in {mo,co,s}; do nest g $i $1; done
      yarn lint --fix
    }
'';
}
