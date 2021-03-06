{ nixpkgs ? import <nixpkgs> {} 
, idris_plain ? nixpkgs.haskellPackages.callPackage ./idris_plain {}
}:

with nixpkgs;

let
  libraryDirectory = "${idris_plain.system}-ghc-${idris_plain.ghc.version}/${idris_plain.fname}";
in
rec {
  mkDerivation = { pname, version, buildDepends, src, buildInputs ? [] }:
    let wrappedIdris = idrisWithPackages buildDepends;
    in stdenv.mkDerivation {
      name = "${pname}-${version}";
      inherit src buildInputs;
      dontUseCmakeConfigure = true;
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
      buildPhase = ''
        export TARGET="$out"
        ${wrappedIdris}/bin/idris --build ${pname}.ipkg
      '';
      installPhase = ''
        ${wrappedIdris}/bin/idris --install ${pname}.ipkg
      '';
    };

  idrisWithPackages = pkgs: callPackage ./idris_plain/wrapper.nix {
    idris_plain = idris_plain;
    idrisLibraryPath = symlinkJoin "idris-env" ([
      "${idris_plain}/share/${libraryDirectory}"
    ] ++ pkgs);
  };

  lightyear = mkDerivation rec {
    pname = "lightyear";
    version = "e0b3e883f833c1114effc837a086b0ab9c6c44eb";
    src = fetchFromGitHub {
      owner = "jfdm";
      repo = "lightyear";
      rev = version;
      sha256 = "1636xzzvd84p7s9b6ikd6pl122v8sb7z8ivn42546px8763l0rkw";
    };
    buildDepends = [];
  };
  idris-commonmark = mkDerivation rec {
    pname = "commonmark";
    version = "31b7bb562a97fe9fefbeb4c7129d050b81b408e2";
    src = fetchgit {
      url = "https://github.com/soimort/idris-commonmark.git";
      rev = version;
      sha256 = "07caakdjv14gl831586zlpm5ysnajgpr24j94bv7hkcsn9snnk9p";
    };
    buildInputs = [ re2c ];
    buildDepends = [ ];
  };
  idris-config = mkDerivation rec {
    pname = "config";
    version = "763567ad095f720fb905ff2aa4598470ef2b741b";
    src = fetchFromGitHub {
      owner = "jfdm";
      repo = "idris-config";
      rev = version;
      sha256 = "1sa0wrkm769sw25vqq7b3xnrq6irzr9387hhh4dlfjn1kg03nah5";
    };
    buildDepends = [ lightyear ];
  };
  idris-lens = mkDerivation rec {
    pname = "lens";
    version = "3897a3a671b5622c79eea680f1b2261da4c53c22";
    src = fetchFromGitHub {
      owner = "idris-hackers";
      repo = "idris-lens";
      rev = version;
      sha256 = "13zifzdj1z4yaz8kxcnxrpls86ryh7nwr0rrvd570cqfqgdhnxj7";
    };
    buildDepends = [ ];
  };
  idris-posix = mkDerivation rec {
    pname = "posix";
    version = "18e1badad2d084186e0cd418cc3b01cd5a72000b";
    src = fetchFromGitHub {
      owner = "idris-hackers";
      repo = "idris-posix";
      rev = version;
      sha256 = "0k8lzm767swcm3hp4fgi644bjbb4lx9q2llpf9gjdp7qbdrk2ysf";
    };
    buildDepends = [ ];
  };
  quantities = mkDerivation rec {
    pname = "quantities";
    version = "f0e3cbb010843c7c46768953328579c7e62330be";
    src = fetchFromGitHub {
      owner = "timjb";
      repo = "quantities";
      rev = version;
      sha256 = "1rz259mln5387akcbv5fgss69fiaiihgk9ja4k6s1w8dhsfza6bl";
    };
    buildDepends = [ ];
  };
}
