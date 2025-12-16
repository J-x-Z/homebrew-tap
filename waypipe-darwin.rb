class WaypipeDarwin < Formula
  desc "Proxy for Wayland clients (optimized for macOS/Darwin)"
  homepage "https://github.com/J-x-Z/waypipe-darwin"
  url "https://github.com/J-x-Z/waypipe-darwin.git", branch: "main"
  version "0.9.2-darwin"
  head "https://github.com/J-x-Z/waypipe-darwin.git", branch: "main"

  depends_on "rust" => :build
  depends_on "rust-bindgen" => :build
  depends_on "lz4"
  depends_on "zstd"

  conflicts_with "waypipe", because: "both install `waypipe` binaries"

  def install
    # Set paths for zstd and lz4 dependencies (required for wrap-zstd/build.rs)
    ENV["PKG_CONFIG_PATH"] = "#{Formula["zstd"].opt_lib}/pkgconfig:#{Formula["lz4"].opt_lib}/pkgconfig"
    ENV["LIBRARY_PATH"] = "#{Formula["zstd"].opt_lib}:#{Formula["lz4"].opt_lib}"
    ENV["CPATH"] = "#{Formula["zstd"].opt_include}:#{Formula["lz4"].opt_include}"
    
    system "cargo", "install", *std_cargo_args, "--no-default-features", "--features", "lz4,zstd"
  end

  test do
    assert_match "waypipe", shell_output("#{bin}/waypipe --version")
  end
end
