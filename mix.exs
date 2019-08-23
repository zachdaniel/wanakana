defmodule Wanakana.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :wanakana,
      version: @version,
      elixir: "~> 1.9",
      description: description(),
      package: package(),
      name: "Wanakana",
      docs: docs(),
      source_url: "https://github.com:zachdaniel/wanakana",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description do
    """
    A library for converting to and from romaji, ひらがな, and カタカナ.
    """
  end

  defp package() do
    [
      name: :wanakana,
      maintainers: ["Zachary Daniel"],
      licenses: ["GNU GENERAL PUBLIC LICENSE"],
      links: %{
        "GitHub" => "https://github.com:zachdaniel/wanakana"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: [
        "README.md"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:git_ops, "~> 0.6.3", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end
end
