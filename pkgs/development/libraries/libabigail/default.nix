{ stdenv
, fetchurl
, autoreconfHook
, elfutils
, libxml2
, pkgconfig
, strace
, python3
}:

stdenv.mkDerivation rec {
  pname = "libabigail";
  version = "1.7";

  outputs = [ "bin" "out" "dev" ];

  src = fetchurl {
    url = "https://mirrors.kernel.org/sourceware/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0bf8w01l6wm7mm4clfg5rqi30m1ws11qqa4bp2vxghfwgi9ai8i7";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    strace
  ];

  buildInputs = [
    elfutils
    libxml2
  ];

  checkInputs = [
    python3
  ];

  configureFlags = [
    "--enable-bash-completion=yes"
    "--enable-cxx11=yes"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  preCheck = ''
    # runtestdiffpkg needs cache directory
    export XDG_CACHE_HOME="$TEMPDIR"
    patchShebangs tests/
  '';

  meta = with stdenv.lib; {
    description = "ABI Generic Analysis and Instrumentation Library";
    homepage = "https://sourceware.org/libabigail/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
