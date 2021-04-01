require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.13.14.tgz"
  sha256 "6a03cbe41e2405be8fb565c610d6fd502e884566db22a939587c409bdd13e671"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b74fbd85045e94602b74ae06e48f3d02191ecdbca04cfac79cd247f09752d76f"
    sha256 cellar: :any_skip_relocation, big_sur:       "f42771474a813b970a06017ba71f33d032942da6a4e27d7f99e0203c8038b55c"
    sha256 cellar: :any_skip_relocation, catalina:      "80e6b87b9229170895337c2cee463d515484eacb4c4afec8386e2b1206986a8b"
    sha256 cellar: :any_skip_relocation, mojave:        "a74c1028d1fff6990cee37df7bd6bdb4e2529a79a1dfdaf9484cb53bd3bb51c6"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.13.14.tgz"
    sha256 "3d7c70aabf192eee27bb3c94566436d9ee8abd00502c075ff9b3ad85ed523c50"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
