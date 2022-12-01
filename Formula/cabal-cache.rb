class CabalCache < Formula
  desc "Haskell cabal store caching tool"
  homepage "https://github.com/haskell-works/cabal-cache"
  url "https://hackage.haskell.org/package/cabal-cache-1.0.5.1/cabal-cache-1.0.5.1.tar.gz"
  sha256 "4f464688f2d327d4f71c09697a95b3cb335dd29d0e173bb27675656906b1510a"
  license "BSD-3-Clause"
  head "git@github.com:haskell-works/cabal-cache.git", branch: "master"

  depends_on "cabal-install" => :build
  depends_on "ghc@8.10" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end
end
