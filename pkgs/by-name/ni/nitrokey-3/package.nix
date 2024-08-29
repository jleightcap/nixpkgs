{
  lib,
  hostPlatform,
  fetchFromGitHub,
  writeShellScriptBin,
  gcc,
  flip-link,
  python3,
  llvmPackages,
  board ? "nk3am",
  provisioner ? false,
  develop ? false,
}:
let
  buildTarget =
    {
      "nk3xn" = {
        makeTarget = "build-nk3xn";
        makefilePath = "runners/embedded";
        targetPlatform = "thumbv8em-none-eabi";
      };
      "nk3am" = {
        makeTarget = "build-nk3am.bl";
        makefilePath = "runners/embedded";
        targetPlatform = "thumbv7em-none-eabihf";
      };
      "nkpk" = {
        makeTarget = "build";
        makefilePath = "runners/nkpk";
        targetPlatform = "thumbv7em-none-eabihf";
      };
    }
    ."${board}";

  cross = import ../../../.. {
    system = hostPlatform.system;
    crossSystem = lib.systems.examples.arm-embedded // {
      rust.rustcTarget = buildTarget.targetPlatform;
    };
  };

  # we need to manually pass the target platform's rust-lld for now
  # it is called by flip-linker and this will work as long as cargo-binutils
  # is not installed, as it provides `rust-lld` as well.
  rust-lld = writeShellScriptBin "rust-lld" ''
    ${cross.rustPlatform.rust.rustc.llvmPackages.lld}/bin/ld.lld "$@"
  '';

  inherit (cross) rustPlatform;
in
rustPlatform.buildRustPackage rec {
  pname = "nitrokey-3-${board}${lib.optionalString provisioner "-provisioner"}-firmware";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-3-firmware";
    rev = "v${version}";
    sha256 = "sha256-zl3kSgMJrfn7RAN3sabZvCp6hqWc2Ffma29KL5eP6kg=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    # specify hashes of many git dependencies
    outputHashes = {
      "admin-app-0.1.0" = "sha256-yWYdeb6nG7EUBrOECOFiH0foCHgUG2pqhMrdlnaIf8o=";
      "apdu-dispatch-0.1.2" = "sha256-ZADBJR71FIUFUUkDJNswwfEG/cvB6XOALtn0BDfYf6k=";
      "cbor-smol-0.4.0" = "sha256-FcU3oP1KL02ur2O+OCOp/FxmF0DSFgE+jOsNdfh0dPU=";
      "ctap-types-0.1.2" = "sha256-cRgAMmX8F9HsnVAcOizdsmch1CfOPIRmfpxNG39+zLs=";
      "ctaphid-dispatch-0.1.1" = "sha256-6Ryyo8cpaqt9mYjMymak1xy8AEqbeEvDPzXyQZkSw7E=";
      "encrypted_container-0.1.0" = "sha256-1YsmVtDia/to5hjxKYxnEsRsPYxPbDcHdUUa+9ADPR0=";
      "fido-authenticator-0.1.1" = "sha256-tfwPfazXc24y1Y/RejK1jwSo4/94Shkm33FMnpE2cpU=";
      "littlefs2-0.4.0" = "sha256-19UwPy+2/tjW6E3zeTGd5EKK2QD14HjNgabEKXI+Gi0=";
      "littlefs2-sys-0.1.7" = "sha256-F4+mKHftnKSyPuSBFmyArH1+AWW6U7ud9OnUnnjSY/g=";
      "lpc55-hal-0.3.0" = "sha256-8EDsdDxR3p1ez0b9B1AwHX6B8WDYioEFuKaxodwNQak=";
      "opcard-1.4.0" = "sha256-OnKAch3Lad/uSIPcTPCj/R7dvkLE5MwG/r+4oB7U0y0=";
      "p256-cortex-m4-0.1.0-alpha.6" = "sha256-yFswggC3nEE4sBOtLLiFdrPXpdn8oAjGT5GHkj98v/w=";
      "piv-authenticator-0.3.4" = "sha256-LQoEel0tOnoGd9QyTTY0bc6VmgzH5G8xKhWO3VoVv94=";
      "serde-indexed-0.1.0" = "sha256-X+L7pq035cORM7PVUaCscHnbV9EgzAFCRGI9yoo7W8k=";
      "trussed-0.1.0" = "sha256-BmTdq8gEjYzQKZgTG7ECbEXiY3aB2i+lP15xPLkBvnI=";
      "trussed-auth-0.3.0" = "sha256-XFcmI2k7OfhUk8/E0TV12vnQqpSuUJ6ahitA1oLt2ws=";
      "trussed-chunked-0.1.0" = "sha256-Cpz4jeP2xTwMHBWJ/0D5ltCTZxqlD5c43qtxdCTKxok=";
      "trussed-hkdf-0.2.0" = "sha256-VgbG/kuMM2AHE7wQmoOy2vEQ7tBZckZHHIWCH28snlc=";
      "trussed-rsa-alloc-0.1.0" = "sha256-gFQ2rf7Cx2Fk3EnhzyxYf9KrTwipCo3f2FAnKDhpj2U=";
      "trussed-se050-backend-0.3.0" = "sha256-HqZuUxnkBFt6g7Ix+pnJO/CPPbJFVnGg3ak6UZ8s0Tw=";
      "trussed-se050-manage-0.1.0" = "sha256-6grFxI1zkRwSYIAvlCKzJXtump5zULqOaTVA7AP2VXk";
      "trussed-usbip-0.0.1" = "sha256-jFePfw+WL59SFvORhmpM8zEiay25nIbwdgHgRgYAwoM=";
      "usbd-ccid-0.2.0" = "sha256-Y/Exbrhb/4QP+zXlGIRRyxpYV2U4d/9ka2rg/NRKEw0=";
      "usbd-ctaphid-0.1.0" = "sha256-B9jSvi16wYqvLY3O6iIU5QOjNTbf4c6BT2KzcjbJLek=";
      "webcrypt-0.8.0" = "sha256-uVO9ULh5c98CIkVYIBuqKqXk+vvGPyDVoaxzMjYWnf0=";
    };
  };

  dontCargoBuild = true;
  nativeBuildInputs = [
    flip-link
    python3
    rust-lld
    # for c++filt
    gcc
  ];

  # lld: error: unknown argument '-Wl,--undefined=AUDITABLE_VERSION_INFO'
  # https://github.com/cloud-hypervisor/rust-hypervisor-firmware/issues/249
  auditable = false;

  # nitrokey>   Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.so', 'libclang-*.so', 'libclang.so.*', 'libclang-*.so.*'], set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found (invalid: [])"
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # We don't execute make binaries directly because there is a target related to tests.
  # $(MAKE) -C runners/embedded build-all FEATURES=test
  # https://github.com/Nitrokey/nitrokey-3-firmware/blob/main/Makefile#L18-L33
  buildPhase = ''
    make -C ${buildTarget.makefilePath} ${buildTarget.makeTarget} \
    FEATURES=${lib.optionalString provisioner "provisioner"}
  '';

  doCheck = false; # TODO: tests?

  dontCargoInstall = true;
  installPhase = ''
    runHook preInstall
    cp -r ${buildTarget.makefilePath}/artifacts $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware for the Nitrokey 3 device";
    homepage = "https://github.com/Nitrokey/nitrokey-3-firmware";
    platforms = lib.platforms.all; # TODO: set this to the exact architecture we're building
    license = with licenses; [
      asl20
      mit
    ];
  };
}
